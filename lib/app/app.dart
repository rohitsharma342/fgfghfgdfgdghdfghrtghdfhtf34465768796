import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'routes.dart';

class SocialConnectApp extends StatelessWidget {
  const SocialConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Social Connect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRoutes.router,
    );
  }
}