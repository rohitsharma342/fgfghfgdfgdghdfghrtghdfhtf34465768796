import 'user_model.dart';

class PostModel {
  final String id;
  final String content;
  final List<String> mediaUrls;
  final UserModel author;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isLiked;
  final bool isBookmarked;
  final DateTime createdAt;
  final String? category;

  PostModel({
    required this.id,
    required this.content,
    this.mediaUrls = const [],
    required this.author,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.isLiked = false,
    this.isBookmarked = false,
    required this.createdAt,
    this.category,
  });

  PostModel copyWith({
    String? id,
    String? content,
    List<String>? mediaUrls,
    UserModel? author,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    bool? isLiked,
    bool? isBookmarked,
    DateTime? createdAt,
    String? category,
  }) {
    return PostModel(
      id: id ?? this.id,
      content: content ?? this.content,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      author: author ?? this.author,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'mediaUrls': mediaUrls,
      'author': author.toJson(),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
      'createdAt': createdAt.toIso8601String(),
      'category': category,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      author: UserModel.fromJson(json['author'] ?? {}),
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      sharesCount: json['sharesCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isBookmarked: json['isBookmarked'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      category: json['category'],
    );
  }
}