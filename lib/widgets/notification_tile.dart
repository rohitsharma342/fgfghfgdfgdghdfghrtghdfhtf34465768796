import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../models/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  IconData _getIcon() {
    switch (notification.type) {
      case NotificationType.like:
        return Icons.favorite;
      case NotificationType.comment:
        return Icons.chat_bubble;
      case NotificationType.follow:
        return Icons.person_add;
      case NotificationType.mention:
        return Icons.alternate_email;
      case NotificationType.share:
        return Icons.share;
    }
  }

  Color _getIconColor() {
    switch (notification.type) {
      case NotificationType.like:
        return Colors.red;
      case NotificationType.comment:
        return Colors.blue;
      case NotificationType.follow:
        return Colors.green;
      case NotificationType.mention:
        return Colors.purple;
      case NotificationType.share:
        return Colors.orange;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: notification.isRead
            ? Colors.transparent
            : AppTheme.primaryColor.withOpacity(0.05),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _getIconColor().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIcon(),
                color: _getIconColor(),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight:
                          notification.isRead ? FontWeight.w500 : FontWeight.bold,
                      fontSize: 15,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(notification.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}