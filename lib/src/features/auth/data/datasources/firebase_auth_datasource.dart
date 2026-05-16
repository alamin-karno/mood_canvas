import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:mood_canvas/src/core/error/error.dart';
import 'package:mood_canvas/src/utils/typedefs.dart';

import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

class FirebaseAuthDataSource implements AuthRemoteDataSource {
  FirebaseAuthDataSource({firebase_auth.FirebaseAuth? auth})
      : _auth = auth ?? firebase_auth.FirebaseAuth.instance;

  final firebase_auth.FirebaseAuth _auth;

  @override
  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().map((user) {
      if (user == null) return null;
      return UserModel.fromFirebaseUser(user);
    });
  }

  @override
  FutureEither<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return runTask(() async {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw Exception('Sign in failed: no user returned');
      }
      return UserModel.fromFirebaseUser(user);
    }, requiresNetwork: true);
  }

  @override
  FutureEither<UserModel> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return runTask(() async {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw Exception('Sign up failed: no user returned');
      }
      await user.updateDisplayName(name);
      return UserModel.fromFirebaseUser(user);
    }, requiresNetwork: true);
  }

  @override
  FutureEither<void> sendPasswordResetEmail({required String email}) {
    return runTask(
      () => _auth.sendPasswordResetEmail(email: email),
      requiresNetwork: true,
    );
  }

  @override
  FutureEither<void> signOut() {
    return runTask(() => _auth.signOut());
  }

  @override
  FutureEither<UserModel?> getCurrentUser() async {
    return runTask(() async {
      final user = _auth.currentUser;
      if (user == null) return null;
      return UserModel.fromFirebaseUser(user);
    });
  }
}
