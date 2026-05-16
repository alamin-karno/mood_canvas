import 'package:fpdart/fpdart.dart';

import '../../utils/error_handler.dart';
import '../../utils/logger.dart';
import '../../utils/typedefs.dart';
import 'failure.dart';

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
