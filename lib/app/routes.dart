import 'package:flutter/material.dart';
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
  static const String registration = '/registration';
  static const String dashboard = '/dashboard';
  static const String postCreation = '/post-creation';
  static const String profile = '/profile';
  static const String notifications = '/notifications';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case registration:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case postCreation:
        return MaterialPageRoute(builder: (_) => const PostCreationScreen());
      case profile:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(
            userId: args?['userId'],
            isOwnProfile: args?['isOwnProfile'] ?? true,
          ),
        );
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}