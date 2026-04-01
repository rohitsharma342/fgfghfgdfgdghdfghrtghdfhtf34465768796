import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/post_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/notification_controller.dart';
import 'routes.dart';

class SocialConnectApp extends StatelessWidget {
  const SocialConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => PostController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => NotificationController()),
      ],
      child: MaterialApp(
        title: 'Social Connect',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}