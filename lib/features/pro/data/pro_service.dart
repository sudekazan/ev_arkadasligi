import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/firebase/app_error.dart';
import '../../../core/firebase/firebase_env.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/data/user_repository.dart';
import '../../household/data/household_repository.dart';

const proEntitlement = 'pro';

/// Pro limits from PLAN.md "Gelir modeli".
abstract final class ProLimits {
  static const freeHouseholds = 1;
  static const freeRecurring = 3;
  static const freeReceiptScans = 5;
  static const proReceiptScans = 200;
  static const freeReportMonths = 1;
}

/// Thin wrapper over RevenueCat. Prices always come from the store via
/// RevenueCat; the app never hard-codes them.
class ProService {
  bool _configured = false;
  final _active = StreamController<bool>.broadcast();

  String get _apiKey =>
      Platform.isIOS ? FirebaseEnv.revenueCatIosKey : FirebaseEnv.revenueCatAndroidKey;

  bool get available => _apiKey.isNotEmpty;

  Stream<bool> get entitlementActive => _active.stream;

  Future<void> configure(String uid) async {
    if (!available) return;
    try {
      if (!_configured) {
        await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.warn);
        await Purchases.configure(PurchasesConfiguration(_apiKey)..appUserID = uid);
        Purchases.addCustomerInfoUpdateListener((info) => _active.add(_isActive(info)));
        _configured = true;
      } else {
        await Purchases.logIn(uid);
      }
      _active.add(_isActive(await Purchases.getCustomerInfo()));
    } catch (e, s) {
      reportError(e, s);
    }
  }

  Future<void> logOut() async {
    if (!_configured) return;
    try {
      await Purchases.logOut();
    } catch (_) {}
    _active.add(false);
  }

  bool _isActive(CustomerInfo info) =>
      info.entitlements.active.containsKey(proEntitlement);

  /// Monthly and annual packages of the current offering.
  Future<List<Package>> packages() async {
    if (!_configured) throw const AppException(AppErrorCode.network);
    final offerings = await Purchases.getOfferings();
    final packages = offerings.current?.availablePackages ?? const <Package>[];
    final relevant = packages
        .where((p) => p.packageType == PackageType.monthly || p.packageType == PackageType.annual)
        .toList()
      ..sort((a, b) => a.packageType == PackageType.annual ? -1 : 1);
    if (relevant.isEmpty) throw const AppException(AppErrorCode.network);
    return relevant;
  }

  /// Returns whether Pro is active afterwards; throws [CancelledException]
  /// when the user closes the store sheet.
  Future<bool> purchase(Package package) async {
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      final active = _isActive(result.customerInfo);
      _active.add(active);
      return active;
    } on PlatformException catch (e) {
      if (PurchasesErrorHelper.getErrorCode(e) == PurchasesErrorCode.purchaseCancelledError) {
        throw const CancelledException();
      }
      rethrow;
    }
  }

  Future<bool> restore() async {
    if (!_configured) throw const AppException(AppErrorCode.network);
    final active = _isActive(await Purchases.restorePurchases());
    _active.add(active);
    return active;
  }
}

final proServiceProvider = Provider<ProService>((ref) => ProService());

/// The device user's own RevenueCat entitlement.
final ownEntitlementProvider = StreamProvider<bool>((ref) {
  final uid = ref.watch(currentUidProvider);
  final service = ref.watch(proServiceProvider);
  if (uid == null) return Stream.value(false);
  unawaited(service.configure(uid));
  return service.entitlementActive;
});

/// Pro features in the current household (any member's subscription counts).
final householdIsProProvider = Provider<bool>((ref) {
  final household = ref.watch(currentHouseholdProvider).value;
  return (household?.isPro ?? false) || (ref.watch(ownEntitlementProvider).value ?? false);
});

/// The user's own Pro status, which lifts the household-count limit.
final userHasProProvider = Provider<bool>((ref) {
  final profile = ref.watch(userProfileProvider).value;
  return (profile?.hasOwnPro ?? false) || (ref.watch(ownEntitlementProvider).value ?? false);
});
