enum NotificationType { like, comment, follow, mention, share }

class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final String? userId;
  final String? postId;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.userId,
    this.postId,
    this.isRead = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  NotificationModel copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? message,
    String? userId,
    String? postId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      userId: userId ?? this.userId,
      postId: postId ?? this.postId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}