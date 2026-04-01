import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../controllers/notification_controller.dart';
import '../widgets/notification_tile.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/empty_state.dart';

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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Notifications'),
        actions: [
          Consumer<NotificationController>(
            builder: (context, controller, _) {
              if (controller.unreadCount > 0) {
                return TextButton(
                  onPressed: controller.markAllAsRead,
                  child: const Text('Mark all read'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<NotificationController>(
        builder: (context, controller, _) {
          if (controller.isLoading && controller.notifications.isEmpty) {
            return const LoadingIndicator();
          }

          if (controller.notifications.isEmpty) {
            return const EmptyState(
              icon: Icons.notifications_off_outlined,
              title: 'No Notifications',
              message: 'You\'re all caught up! Check back later.',
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.loadNotifications(),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: controller.notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final notification = controller.notifications[index];
                return NotificationTile(
                  notification: notification,
                  onTap: () {
                    controller.markAsRead(notification.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Opened: ${notification.title}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}