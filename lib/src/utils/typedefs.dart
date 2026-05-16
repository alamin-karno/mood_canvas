import 'package:fpdart/fpdart.dart';

import '../core/error/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
