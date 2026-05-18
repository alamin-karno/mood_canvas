import 'package:fpdart/fpdart.dart';
import 'package:mood_canvas/src/core/error/failure.dart';
import 'package:mood_canvas/src/utils/error_handler.dart';
import 'package:mood_canvas/src/utils/logger.dart';
import 'package:mood_canvas/src/utils/typedefs.dart';

FutureEither<T> runTask<T>(
  Future<T> Function() action, {
  bool requiresNetwork = false,
}) async {
  try {
    final result = await action();
    return right(result);
  } catch (error, stackTrace) {
    AppLogger.error('Task execution failed $error', [error, stackTrace]);
    final errorMessage = AppErrorHandler.format(error);
    return left(ServerFailure(errorMessage, error: error));
  }
}
