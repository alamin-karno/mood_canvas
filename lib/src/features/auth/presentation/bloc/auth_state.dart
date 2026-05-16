import 'package:equatable/equatable.dart';

import 'package:mood_canvas/src/core/error/failure.dart';
import 'package:mood_canvas/src/features/auth/domain/entities/user.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.failure,
    this.message,
  });

  const AuthState.initial() : this();

  final AuthStatus status;
  final AppUser? user;
  final Failure? failure;
  final String? message;

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    Failure? failure,
    String? message,
    bool clearFailure = false,
    bool clearMessage = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      failure: clearFailure ? null : (failure ?? this.failure),
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, user, failure, message];
}
