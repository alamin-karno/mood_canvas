import 'package:get_it/get_it.dart';

import 'src/features/mood_tracker/data/datasources/local_mood_tracker_datasource.dart';
import 'src/features/mood_tracker/data/datasources/mood_tracker_datasource.dart';
import 'src/features/mood_tracker/data/repositories/mood_tracker_repository_impl.dart';
import 'src/features/mood_tracker/domain/repositories/mood_tracker_repository.dart';
import 'src/features/mood_tracker/domain/usecases/log_mood_usecase.dart';
import 'src/features/mood_tracker/domain/usecases/watch_mood_history_usecase.dart';
import 'src/features/mood_tracker/presentation/bloc/mood_tracker_bloc.dart';
import 'src/services/storage_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupInjection() async {
  getIt.registerLazySingleton<StorageService>(() => StorageService.instance);

  getIt.registerLazySingleton<MoodTrackerDataSource>(
    LocalMoodTrackerDataSource.new,
  );
  getIt.registerLazySingleton<MoodTrackerRepository>(
    () => MoodTrackerRepositoryImpl(dataSource: getIt()),
  );

  getIt.registerLazySingleton(() => LogMoodUseCase(getIt()));
  getIt.registerLazySingleton(() => WatchMoodHistoryUseCase(getIt()));

  getIt.registerFactory<MoodTrackerBloc>(
    () => MoodTrackerBloc(
      logMoodUseCase: getIt(),
      watchMoodHistoryUseCase: getIt(),
    ),
  );
}
