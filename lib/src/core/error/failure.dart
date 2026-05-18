import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message, {this.error});

  final String message;
  final dynamic error;

  @override
  List<Object?> get props => [message, error];

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.error});
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.error});
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.error});
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.error});
}
