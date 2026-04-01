class PostModel {
  final String id;
  final String userId;
  final String userName;
  final String? userProfileUrl;
  final String content;
  final String? imageUrl;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isLiked;
  final DateTime createdAt;
  final String? category;

  PostModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userProfileUrl,
    required this.content,
    this.imageUrl,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.isLiked = false,
    DateTime? createdAt,
    this.category,
  }) : createdAt = createdAt ?? DateTime.now();

  PostModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userProfileUrl,
    String? content,
    String? imageUrl,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    bool? isLiked,
    DateTime? createdAt,
    String? category,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfileUrl: userProfileUrl ?? this.userProfileUrl,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
    );
  }
}