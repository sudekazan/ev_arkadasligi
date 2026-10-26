import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/converters.dart';
import '../../../core/firebase/firebase_providers.dart';
import '../domain/app_user.dart';
import 'auth_repository.dart';

class UserRepository {
  UserRepository(this._db, this._auth);

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  DocumentReference<Map<String, dynamic>> _doc(String uid) => _db.collection('users').doc(uid);

  /// Streams the profile, creating it on first sign-in.
  Stream<AppUser?> watch(String uid) async* {
    await for (final snap in _doc(uid).snapshots()) {
      if (!snap.exists) {
        if (!snap.metadata.isFromCache) await _create(uid);
        continue;
      }
      yield AppUser.fromJson(docWithId(snap));
    }
  }

  Future<void> _create(String uid) async {
    final user = _auth.currentUser;
    final fallbackName = user?.email?.split('@').first ?? '';
    final ref = _doc(uid);
    await _db.runTransaction((tx) async {
      if ((await tx.get(ref)).exists) return;
      tx.set(ref, {
      'displayName': (user?.displayName?.trim().isNotEmpty ?? false)
          ? user!.displayName!.trim()
          : fallbackName,
      'avatarEmoji': '🙂',
      'locale': 'tr',
      'householdIds': <String>[],
      'fcmTokens': <String>[],
      'notificationPrefs': <String, bool>{},
      'createdAt': Timestamp.now(),
      });
    });
  }

  /// Sets the name chosen at registration; safe before or after [_create].
  Future<void> setDisplayName(String uid, String name) =>
      _doc(uid).set({'displayName': name.trim()}, SetOptions(merge: true));

  /// Updates the profile and the public copy in every household.
  Future<void> updateProfile(
    AppUser user, {
    required String displayName,
    required String avatarEmoji,
    String? iban,
  }) async {
    final batch = _db.batch();
    batch.update(_doc(user.id), {
      'displayName': displayName,
      'avatarEmoji': avatarEmoji,
      'iban': iban,
    });
    for (final hid in user.householdIds) {
      batch.update(_db.doc('households/$hid/members/${user.id}'), {
        'displayName': displayName,
        'avatarEmoji': avatarEmoji,
        'iban': iban,
      });
    }
    await batch.commit();
  }

  Future<void> setLocale(String uid, String locale) =>
      _doc(uid).update({'locale': locale});

  Future<void> setNotificationPref(String uid, String kind, bool enabled) =>
      _doc(uid).update({'notificationPrefs.$kind': enabled});

  Future<void> addFcmToken(String uid, String token) =>
      _doc(uid).update({'fcmTokens': FieldValue.arrayUnion([token])});

  Future<void> removeFcmToken(String uid, String token) =>
      _doc(uid).update({'fcmTokens': FieldValue.arrayRemove([token])});
}

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(ref.watch(firestoreProvider), ref.watch(firebaseAuthProvider)),
);

final userProfileProvider = StreamProvider<AppUser?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);
  return ref.watch(userRepositoryProvider).watch(uid);
});
