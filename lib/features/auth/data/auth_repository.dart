import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/app_error.dart';
import '../../../core/firebase/firebase_env.dart';
import '../../../core/firebase/firebase_providers.dart';

class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  static const _appleEnabled = bool.fromEnvironment('APPLE_SIGN_IN_ENABLED');

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  /// Google needs a real OAuth client, so it is hidden against the demo project.
  bool get googleAvailable => !FirebaseEnv.isDemo;

  /// Apple sign-in is required on iOS once the Apple developer setup is done.
  bool get appleAvailable => Platform.isIOS && _appleEnabled;

  Future<void> signInWithEmail(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email.trim(), password: password);

  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await cred.user?.updateDisplayName(name.trim());
  }

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email.trim());

  /// Google sign-in through Firebase's provider flow (system browser sheet).
  /// The native google_sign_in plugin conflicts with Firebase iOS SDK 13.
  Future<void> signInWithGoogle() async {
    try {
      await _auth.signInWithProvider(GoogleAuthProvider()..addScope('email'));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'web-context-canceled' || e.code == 'canceled') {
        throw const CancelledException();
      }
      rethrow;
    }
  }

  Future<void> signInWithApple() async {
    final provider = AppleAuthProvider()
      ..addScope('email')
      ..addScope('name');
    await _auth.signInWithProvider(provider);
  }

  Future<void> signOut() => _auth.signOut();
}

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(ref.watch(firebaseAuthProvider)));

final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges(),
);

final currentUidProvider = Provider<String?>((ref) => ref.watch(authStateProvider).value?.uid);
