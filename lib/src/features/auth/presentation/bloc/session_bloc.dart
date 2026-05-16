import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/logout_usecase.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

class SessionCheckRequested extends SessionEvent {
  const SessionCheckRequested();
}

class SessionUserChanged extends SessionEvent {
  const SessionUserChanged(this.user);

  final AppUser? user;

  @override
  List<Object?> get props => [user];
}

class SessionLogoutRequested extends SessionEvent {
  const SessionLogoutRequested();
}

enum SessionStatus { unknown, authenticated, unauthenticated }

class SessionState extends Equatable {
  const SessionState({
    this.status = SessionStatus.unknown,
    this.user,
  });

  const SessionState.unknown() : this();

  const SessionState.authenticated(AppUser user)
      : this(status: SessionStatus.authenticated, user: user);

  const SessionState.unauthenticated()
      : this(status: SessionStatus.unauthenticated);

  final SessionStatus status;
  final AppUser? user;

  @override
  List<Object?> get props => [status, user];
}

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc({
    required AuthRepository repository,
    required LogoutUseCase logoutUseCase,
  })  : _repository = repository,
        _logoutUseCase = logoutUseCase,
        super(const SessionState.unknown()) {
    on<SessionCheckRequested>(_onCheckRequested);
    on<SessionUserChanged>(_onUserChanged);
    on<SessionLogoutRequested>(_onLogoutRequested);

    add(const SessionCheckRequested());
  }

  final AuthRepository _repository;
  final LogoutUseCase _logoutUseCase;
  StreamSubscription<AppUser?>? _authSub;

  Future<void> _onCheckRequested(
    SessionCheckRequested event,
    Emitter<SessionState> emit,
  ) async {
    final result = await _repository.checkAuthState();
    result.fold(
      (_) => emit(const SessionState.unauthenticated()),
      (user) {
        if (user != null) {
          emit(SessionState.authenticated(user));
        } else {
          emit(const SessionState.unauthenticated());
        }
      },
    );

    await _authSub?.cancel();
    _authSub = _repository.onAuthStateChanged.listen((user) {
      add(SessionUserChanged(user));
    });
  }

  void _onUserChanged(
    SessionUserChanged event,
    Emitter<SessionState> emit,
  ) {
    if (event.user != null) {
      emit(SessionState.authenticated(event.user!));
    } else {
      emit(const SessionState.unauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    SessionLogoutRequested event,
    Emitter<SessionState> emit,
  ) async {
    await _logoutUseCase();
    emit(const SessionState.unauthenticated());
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }
}
