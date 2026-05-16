import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mood_canvas/src/core/error/failure.dart';
import 'package:mood_canvas/src/features/auth/domain/entities/user.dart';
import 'package:mood_canvas/src/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:mood_canvas/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:mood_canvas/src/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:mood_canvas/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mood_canvas/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:mood_canvas/src/features/auth/presentation/bloc/auth_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

class MockForgotPasswordUseCase extends Mock implements ForgotPasswordUseCase {}

void main() {
  late MockLoginUseCase loginUseCase;
  late MockSignUpUseCase signUpUseCase;
  late MockForgotPasswordUseCase forgotPasswordUseCase;

  const user = AppUser(id: '1', email: 'test@example.com', name: 'Test');

  setUp(() {
    loginUseCase = MockLoginUseCase();
    signUpUseCase = MockSignUpUseCase();
    forgotPasswordUseCase = MockForgotPasswordUseCase();
  });

  blocTest<AuthBloc, AuthState>(
    'emits success when login succeeds',
    build: () => AuthBloc(
      loginUseCase: loginUseCase,
      signUpUseCase: signUpUseCase,
      forgotPasswordUseCase: forgotPasswordUseCase,
    ),
    setUp: () {
      when(
        () => loginUseCase(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => right(user));
    },
    act: (bloc) => bloc.add(
      const LoginRequested(email: 'test@example.com', password: 'secret'),
    ),
    expect: () => [
      const AuthState(status: AuthStatus.loading),
      const AuthState(status: AuthStatus.success, user: user),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits failure when login fails',
    build: () => AuthBloc(
      loginUseCase: loginUseCase,
      signUpUseCase: signUpUseCase,
      forgotPasswordUseCase: forgotPasswordUseCase,
    ),
    setUp: () {
      when(
        () => loginUseCase(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => left(const ServerFailure('Invalid credentials')),
      );
    },
    act: (bloc) => bloc.add(
      const LoginRequested(email: 'test@example.com', password: 'wrong'),
    ),
    expect: () => [
      const AuthState(status: AuthStatus.loading),
      isA<AuthState>().having(
        (s) => s.status,
        'status',
        AuthStatus.failure,
      ),
    ],
  );
}
