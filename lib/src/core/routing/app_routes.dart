abstract final class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String moodLog = '/mood/log';
  static const String moodHistory = '/mood/history';

  static const Set<String> publicRoutes = {
    onboarding,
    login,
    signup,
    forgotPassword,
  };

  static const Set<String> authOnlyRoutes = {
    login,
    signup,
    forgotPassword,
  };

  static bool isPublicRoute(String location) {
    return publicRoutes.contains(location);
  }

  static bool isAuthOnlyRoute(String location) {
    return authOnlyRoutes.contains(location);
  }
}
