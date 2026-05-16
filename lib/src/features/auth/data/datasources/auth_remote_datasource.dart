import 'package:mood_canvas/src/utils/typedefs.dart';

import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;

  FutureEither<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  FutureEither<UserModel> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  FutureEither<void> sendPasswordResetEmail({required String email});

  FutureEither<void> signOut();

  FutureEither<UserModel?> getCurrentUser();
}
