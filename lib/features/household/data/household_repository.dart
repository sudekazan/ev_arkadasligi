import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/converters.dart';
import '../../../core/firebase/firebase_providers.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/data/user_repository.dart';
import '../domain/household.dart';

/// Membership changes go through callable functions; see functions/src/household.ts.
class HouseholdRepository {
  HouseholdRepository(this._db, this._functions);

  final FirebaseFirestore _db;
  final FirebaseFunctions _functions;

  DocumentReference<Map<String, dynamic>> _doc(String hid) =>
      _db.collection('households').doc(hid);

  Future<Map<String, dynamic>> _call(String name, Map<String, dynamic> data) async {
    final result = await _functions.httpsCallable(name).call<Object?>(data);
    return Map<String, dynamic>.from(result.data as Map? ?? const {});
  }

  /// Returns (householdId, inviteCode).
  Future<(String, String)> create({required String name, required String currency}) async {
    final r = await _call('createHousehold', {'name': name, 'currency': currency});
    return (r['householdId'] as String, r['inviteCode'] as String);
  }

  Future<String> join(String code) async {
    final r = await _call('joinHousehold', {'code': code.trim().toUpperCase()});
    return r['householdId'] as String;
  }

  Future<void> leave(String hid) => _call('leaveHousehold', {'hid': hid});

  Future<void> removeMember(String hid, String uid) =>
      _call('removeMember', {'hid': hid, 'uid': uid});

  Future<String> regenerateInviteCode(String hid) async {
    final r = await _call('regenerateInviteCode', {'hid': hid});
    return r['inviteCode'] as String;
  }

  /// Push reminder to a debtor; the server allows one per person per day.
  Future<void> sendReminder(String hid, String toUid) =>
      _call('sendReminder', {'hid': hid, 'toUid': toUid});

  Stream<Household?> watch(String hid) => _doc(hid)
      .snapshots()
      .map((s) => s.exists ? Household.fromJson(docWithId(s)) : null);

  Stream<List<Household>> watchMine(String uid) => _db
      .collection('households')
      .where('memberIds', arrayContains: uid)
      .snapshots()
      .map((q) => q.docs.map((d) => Household.fromJson(docWithId(d))).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt)));

  Stream<List<Member>> watchMembers(String hid) => _doc(hid)
      .collection('members')
      .snapshots()
      .map((q) => q.docs.map((d) => Member.fromJson(docWithId(d))).toList()
        ..sort((a, b) => a.joinedAt.compareTo(b.joinedAt)));

  Future<void> update(String hid, {required String name, required String currency}) =>
      _doc(hid).update({'name': name, 'currency': currency});

  Future<void> setRentWeight(String hid, String uid, int weight) =>
      _doc(hid).collection('members').doc(uid).update({'rentWeight': weight});
}

final householdRepositoryProvider = Provider<HouseholdRepository>(
  (ref) => HouseholdRepository(ref.watch(firestoreProvider), ref.watch(functionsProvider)),
);

/// The household chosen in the switcher, persisted on the device.
class SelectedHousehold extends Notifier<String?> {
  static const _key = 'selectedHouseholdId';

  @override
  String? build() => ref.watch(sharedPreferencesProvider).getString(_key);

  Future<void> select(String hid) async {
    state = hid;
    await ref.read(sharedPreferencesProvider).setString(_key, hid);
  }
}

final selectedHouseholdProvider =
    NotifierProvider<SelectedHousehold, String?>(SelectedHousehold.new);

/// Effective current household: the selected one if still a member, else the first.
final currentHouseholdIdProvider = Provider<String?>((ref) {
  final ids = ref.watch(userProfileProvider).value?.householdIds ?? const [];
  if (ids.isEmpty) return null;
  final selected = ref.watch(selectedHouseholdProvider);
  return ids.contains(selected) ? selected : ids.first;
});

final currentHouseholdProvider = StreamProvider<Household?>((ref) {
  final hid = ref.watch(currentHouseholdIdProvider);
  if (hid == null) return Stream.value(null);
  return ref.watch(householdRepositoryProvider).watch(hid);
});

final myHouseholdsProvider = StreamProvider<List<Household>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(const []);
  return ref.watch(householdRepositoryProvider).watchMine(uid);
});

/// All member documents, including people who left (for old expenses).
final membersProvider = StreamProvider<List<Member>>((ref) {
  final hid = ref.watch(currentHouseholdIdProvider);
  if (hid == null) return Stream.value(const []);
  return ref.watch(householdRepositoryProvider).watchMembers(hid);
});

final memberMapProvider = Provider<Map<String, Member>>((ref) {
  final members = ref.watch(membersProvider).value ?? const [];
  return {for (final m in members) m.id: m};
});

/// Current members in join order.
final activeMembersProvider = Provider<List<Member>>((ref) {
  final ids = ref.watch(currentHouseholdProvider).value?.memberIds ?? const [];
  final members = ref.watch(membersProvider).value ?? const [];
  return members.where((m) => ids.contains(m.id)).toList();
});
