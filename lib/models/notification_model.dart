enum NotificationType {
  like,
  comment,
  follow,
  mention,
  share,
}

class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final String? actorName;
  final String? actorImageUrl;
  final String? targetId;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.actorName,
    this.actorImageUrl,
    this.targetId,
    this.isRead = false,
    required this.createdAt,
  });

  NotificationModel copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? message,
    String? actorName,
    String? actorImageUrl,
    String? targetId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      actorName: actorName ?? this.actorName,
      actorImageUrl: actorImageUrl ?? this.actorImageUrl,
      targetId: targetId ?? this.targetId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}