import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../controllers/notification_controller.dart';
import '../widgets/notification_tile.dart';
import '../widgets/loading_indicator.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationController>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Notifications'),
        actions: [
          Consumer<NotificationController>(
            builder: (context, controller, child) {
              if (controller.unreadCount > 0) {
                return TextButton(
                  onPressed: controller.markAllAsRead,
                  child: const Text(
                    'Mark all read',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<NotificationController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const LoadingIndicator();
          }

          if (controller.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    size: 80,
                    color: AppTheme.textSecondaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No notifications yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "You're all caught up!",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            );
          }

          final unreadNotifications =
              controller.notifications.where((n) => !n.isRead).toList();
          final readNotifications =
              controller.notifications.where((n) => n.isRead).toList();

          return ListView(
            children: [
              if (unreadNotifications.isNotEmpty) ...[
                _buildSectionHeader('New'),
                ...unreadNotifications.map(
                  (notification) => NotificationTile(
                    notification: notification,
                    onTap: () => controller.markAsRead(notification.id),
                  ),
                ),
              ],
              if (readNotifications.isNotEmpty) ...[
                _buildSectionHeader('Earlier'),
                ...readNotifications.map(
                  (notification) => NotificationTile(
                    notification: notification,
                    onTap: () {},
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppTheme.backgroundColor,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.textSecondaryColor,
        ),
      ),
    );
  }
}