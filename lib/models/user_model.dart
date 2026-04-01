class UserModel {
  final String id;
  final String name;
  final String email;
  final String? bio;
  final String? profileImageUrl;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool isFollowing;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
    this.profileImageUrl,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.isFollowing = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? bio,
    String? profileImageUrl,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    bool? isFollowing,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      isFollowing: isFollowing ?? this.isFollowing,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}