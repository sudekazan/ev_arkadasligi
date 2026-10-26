import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Analytics events from PLAN.md "Gelir modeli".
class AnalyticsService {
  FirebaseAnalytics? get _analytics =>
      Firebase.apps.isEmpty ? null : FirebaseAnalytics.instance;

  void _log(String name, [Map<String, Object>? params]) {
    final a = _analytics;
    if (a == null) return;
    unawaited(a.logEvent(name: name, parameters: params).catchError((_) {}));
  }

  void paywallViewed(String source) => _log('paywall_viewed', {'source': source});

  void purchaseCompleted(String productId) =>
      _log('purchase_completed', {'product_id': productId});

  void receiptScanned({required bool success}) =>
      _log('receipt_scanned', {'success': success ? 1 : 0});

  void limitReached(String limit) => _log('limit_reached', {'limit': limit});

  void householdCreated() => _log('household_created');

  void memberJoined() => _log('member_joined');

  void expenseAdded(String splitType, String category) =>
      _log('expense_added', {'split_type': splitType, 'category': category});
}

final analyticsProvider = Provider<AnalyticsService>((ref) => AnalyticsService());
