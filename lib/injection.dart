import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:get_it/get_it.dart';

import 'src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'src/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'src/features/auth/data/repositories/auth_repository_impl.dart';
import 'src/features/auth/domain/repositories/auth_repository.dart';
import 'src/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'src/features/auth/domain/usecases/login_usecase.dart';
import 'src/features/auth/domain/usecases/logout_usecase.dart';
import 'src/features/auth/domain/usecases/sign_up_usecase.dart';
import 'src/features/auth/presentation/bloc/auth_bloc.dart';
import 'src/features/auth/presentation/bloc/session_bloc.dart';
import 'src/features/mood_tracker/data/datasources/firestore_mood_tracker_datasource.dart';
import 'src/features/mood_tracker/data/datasources/mood_tracker_remote_datasource.dart';
import 'src/features/mood_tracker/data/repositories/mood_tracker_repository_impl.dart';
import 'src/features/mood_tracker/domain/repositories/mood_tracker_repository.dart';
import 'src/features/mood_tracker/domain/usecases/delete_mood_usecase.dart';
import 'src/features/mood_tracker/domain/usecases/log_mood_usecase.dart';
import 'src/features/mood_tracker/domain/usecases/watch_mood_history_usecase.dart';
import 'src/features/mood_tracker/presentation/bloc/mood_tracker_bloc.dart';
import 'src/services/storage_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupInjection() async {
  // Services
  getIt.registerLazySingleton<StorageService>(() => StorageService.instance);

  // Auth data
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => FirebaseAuthDataSource(auth: firebase_auth.FirebaseAuth.instance),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );

  // Auth use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => SignUpUseCase(getIt()));
  getIt.registerLazySingleton(() => ForgotPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));

  // Mood tracker data
  getIt.registerLazySingleton<MoodTrackerRemoteDataSource>(
    FirestoreMoodTrackerDataSource.new,
  );
  getIt.registerLazySingleton<MoodTrackerRepository>(
    () => MoodTrackerRepositoryImpl(remoteDataSource: getIt()),
  );

  // Mood tracker use cases
  getIt.registerLazySingleton(() => LogMoodUseCase(getIt()));
  getIt.registerLazySingleton(() => WatchMoodHistoryUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteMoodUseCase(getIt()));

  // Blocs
  getIt.registerLazySingleton<SessionBloc>(
    () => SessionBloc(
      repository: getIt(),
      logoutUseCase: getIt(),
    ),
  );

  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: getIt(),
      signUpUseCase: getIt(),
      forgotPasswordUseCase: getIt(),
    ),
  );

  getIt.registerFactory<MoodTrackerBloc>(
    () => MoodTrackerBloc(
      logMoodUseCase: getIt(),
      watchMoodHistoryUseCase: getIt(),
      deleteMoodUseCase: getIt(),
    ),
  );
}
