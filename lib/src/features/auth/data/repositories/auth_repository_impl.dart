import 'package:mood_canvas/src/utils/typedefs.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Stream<AppUser?> get onAuthStateChanged {
    return _remoteDataSource.authStateChanges.map(
      (model) => model?.toEntity(),
    );
  }

  @override
  FutureEither<AppUser> login({
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.map((model) => model.toEntity());
  }

  @override
  FutureEither<AppUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.createUserWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );
    return result.map((model) => model.toEntity());
  }

  @override
  FutureEither<void> forgotPassword({required String email}) {
    return _remoteDataSource.sendPasswordResetEmail(email: email);
  }

  @override
  FutureEither<void> logout() {
    return _remoteDataSource.signOut();
  }

  @override
  FutureEither<AppUser?> checkAuthState() async {
    final result = await _remoteDataSource.getCurrentUser();
    return result.map((model) => model?.toEntity());
  }
}
