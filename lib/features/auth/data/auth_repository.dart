import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/firebase/app_error.dart';
import '../../../core/firebase/firebase_env.dart';
import '../../../core/firebase/firebase_providers.dart';

class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;
  bool _googleInitialized = false;

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

  Future<void> signInWithGoogle() async {
    final google = GoogleSignIn.instance;
    if (!_googleInitialized) {
      await google.initialize(
        serverClientId:
            FirebaseEnv.googleServerClientId.isEmpty ? null : FirebaseEnv.googleServerClientId,
        clientId: Platform.isIOS && FirebaseEnv.iosClientId.isNotEmpty
            ? FirebaseEnv.iosClientId
            : null,
      );
      _googleInitialized = true;
    }
    try {
      final account = await google.authenticate();
      final idToken = account.authentication.idToken;
      await _auth.signInWithCredential(GoogleAuthProvider.credential(idToken: idToken));
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) throw const CancelledException();
      rethrow;
    }
  }

  Future<void> signInWithApple() async {
    final provider = AppleAuthProvider()
      ..addScope('email')
      ..addScope('name');
    await _auth.signInWithProvider(provider);
  }

  Future<void> signOut() async {
    if (_googleInitialized) await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }
}

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(ref.watch(firebaseAuthProvider)));

final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges(),
);

final currentUidProvider = Provider<String?>((ref) => ref.watch(authStateProvider).value?.uid);
