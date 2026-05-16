import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../injection.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/session_bloc.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/home/presentation/screens/home_page.dart';
import '../../features/mood_tracker/presentation/bloc/mood_tracker_bloc.dart';
import '../../features/mood_tracker/presentation/pages/mood_canvas_page.dart';
import '../../features/mood_tracker/presentation/pages/mood_history_page.dart';
import '../../features/mood_tracker/presentation/pages/mood_tracker_page.dart';
import '../../features/onboarding/presentation/screens/onboarding_page.dart';
import 'app_routes.dart';
import 'global_navigator.dart';
import 'go_router_refresh.dart';

GoRouter? _appRouter;

GoRouter get appRouter {
  return _appRouter ??= _createRouter();
}

GoRouter _createRouter() {
  final sessionBloc = getIt<SessionBloc>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.onboarding,
    refreshListenable: GoRouterRefreshStream(sessionBloc.stream),
    redirect: (context, state) {
      final session = sessionBloc.state;
      final location = state.matchedLocation;

      if (session.status == SessionStatus.unknown) {
        return null;
      }

      final isAuthenticated = session.status == SessionStatus.authenticated;

      if (!isAuthenticated && !AppRoutes.isPublicRoute(location)) {
        return AppRoutes.onboarding;
      }

      if (isAuthenticated && AppRoutes.isAuthOnlyRoute(location)) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<AuthBloc>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<AuthBloc>(),
          child: const SignupScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<AuthBloc>(),
          child: const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.moodLog,
        name: 'moodLog',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<MoodTrackerBloc>(),
          child: const MoodCanvasPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.moodHistory,
        name: 'moodHistory',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<MoodTrackerBloc>(),
          child: const MoodHistoryPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.moodTracker,
        name: 'moodTracker',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<MoodTrackerBloc>(),
          child: const MoodTrackerPage(),
        ),
      ),
    ],
  );
}
