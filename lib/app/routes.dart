import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/registration_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/post_creation_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/notifications_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String createPost = '/create-post';
  static const String profile = '/profile';
  static const String notifications = '/notifications';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        path: dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: createPost,
        builder: (context, state) => const PostCreationScreen(),
      ),
      GoRoute(
        path: profile,
        builder: (context, state) {
          final userId = state.uri.queryParameters['userId'];
          return ProfileScreen(userId: userId);
        },
      ),
      GoRoute(
        path: notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
}