import 'package:fpdart/fpdart.dart';
import 'package:mood_canvas/src/core/error/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
