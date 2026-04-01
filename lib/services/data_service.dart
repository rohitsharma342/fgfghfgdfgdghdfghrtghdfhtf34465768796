import '../models/post_model.dart';
import '../models/user_model.dart';
import '../models/notification_model.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final List<PostModel> _posts = [
    PostModel(
      id: 'post_1',
      userId: 'user_2',
      userName: 'Sarah Wilson',
      userProfileUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      content: 'Just finished an amazing hike in the mountains! The view was absolutely breathtaking. Nature really has a way of putting things into perspective. 🏔️',
      imageUrl: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800',
      likesCount: 234,
      commentsCount: 45,
      sharesCount: 12,
      category: 'Travel',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    PostModel(
      id: 'post_2',
      userId: 'user_3',
      userName: 'Mike Chen',
      userProfileUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      content: 'Excited to announce that our startup just closed our Series A funding! Thanks to everyone who believed in us from day one. This is just the beginning! 🚀',
      likesCount: 567,
      commentsCount: 89,
      sharesCount: 34,
      category: 'Business',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    PostModel(
      id: 'post_3',
      userId: 'user_4',
      userName: 'Emily Davis',
      userProfileUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
      content: 'Made this delicious homemade pasta from scratch today! Nothing beats fresh ingredients and a little patience in the kitchen. 🍝',
      imageUrl: 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=800',
      likesCount: 189,
      commentsCount: 32,
      sharesCount: 8,
      category: 'Food',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    PostModel(
      id: 'post_4',
      userId: 'user_5',
      userName: 'Alex Thompson',
      userProfileUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      content: 'Just completed my first marathon! 42.195 km of pure determination. To everyone starting their fitness journey - keep going, the finish line is worth it! 💪',
      imageUrl: 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=800',
      likesCount: 456,
      commentsCount: 78,
      sharesCount: 23,
      category: 'Fitness',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    PostModel(
      id: 'post_5',
      userId: 'user_6',
      userName: 'Jessica Brown',
      userProfileUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
      content: 'Reading this incredible book about the history of technology. Its fascinating how far weve come in just a few decades. Any book recommendations? 📚',
      likesCount: 123,
      commentsCount: 56,
      sharesCount: 5,
      category: 'Books',
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    ),
    PostModel(
      id: 'post_6',
      userId: 'user_7',
      userName: 'David Kim',
      userProfileUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150',
      content: 'Sunset at the beach today was magical. Sometimes you just need to stop and appreciate the simple things in life. 🌅',
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
      likesCount: 345,
      commentsCount: 23,
      sharesCount: 15,
      category: 'Photography',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  final List<PostModel> _trendingPosts = [
    PostModel(
      id: 'trending_1',
      userId: 'user_8',
      userName: 'Tech Insider',
      userProfileUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=150',
      content: 'Breaking: New AI breakthrough could revolutionize how we interact with technology. The future is here! 🤖',
      imageUrl: 'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=800',
      likesCount: 2345,
      commentsCount: 456,
      sharesCount: 234,
      category: 'Technology',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    PostModel(
      id: 'trending_2',
      userId: 'user_9',
      userName: 'World News',
      userProfileUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150',
      content: 'Climate summit reaches historic agreement! World leaders commit to ambitious sustainability goals. 🌍',
      likesCount: 1890,
      commentsCount: 345,
      sharesCount: 567,
      category: 'News',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    PostModel(
      id: 'trending_3',
      userId: 'user_10',
      userName: 'Sports Central',
      userProfileUrl: 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=150',
      content: 'Incredible comeback in the championship game! This will go down in history as one of the greatest matches ever played! ⚽',
      imageUrl: 'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?w=800',
      likesCount: 3456,
      commentsCount: 789,
      sharesCount: 345,
      category: 'Sports',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
  ];

  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: 'notif_1',
      type: NotificationType.like,
      title: 'New Like',
      message: 'Sarah Wilson liked your post',
      userId: 'user_2',
      postId: 'post_1',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    NotificationModel(
      id: 'notif_2',
      type: NotificationType.comment,
      title: 'New Comment',
      message: 'Mike Chen commented on your post: "Great work!"',
      userId: 'user_3',
      postId: 'post_2',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    NotificationModel(
      id: 'notif_3',
      type: NotificationType.follow,
      title: 'New Follower',
      message: 'Emily Davis started following you',
      userId: 'user_4',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    NotificationModel(
      id: 'notif_4',
      type: NotificationType.mention,
      title: 'Mentioned You',
      message: 'Alex Thompson mentioned you in a post',
      userId: 'user_5',
      postId: 'post_4',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 'notif_5',
      type: NotificationType.share,
      title: 'Post Shared',
      message: 'Jessica Brown shared your post',
      userId: 'user_6',
      postId: 'post_5',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    NotificationModel(
      id: 'notif_6',
      type: NotificationType.like,
      title: 'New Like',
      message: 'David Kim and 5 others liked your post',
      postId: 'post_6',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  List<PostModel> get posts => List.unmodifiable(_posts);
  List<PostModel> get trendingPosts => List.unmodifiable(_trendingPosts);
  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  Future<List<PostModel>> getFeedPosts({String? filter, String? searchQuery}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    List<PostModel> result = List.from(_posts);
    
    if (filter != null && filter != 'All') {
      result = result.where((p) => p.category == filter).toList();
    }
    
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((p) =>
        p.content.toLowerCase().contains(query) ||
        p.userName.toLowerCase().contains(query)
      ).toList();
    }
    
    return result;
  }

  Future<List<PostModel>> getTrendingPosts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _trendingPosts;
  }

  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _notifications;
  }

  Future<List<PostModel>> getUserPosts(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _posts.where((p) => p.userId == userId).toList();
  }

  Future<UserModel> getUserProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final users = {
      'user_2': UserModel(
        id: 'user_2',
        name: 'Sarah Wilson',
        email: 'sarah@example.com',
        bio: 'Adventure seeker | Nature lover | Photography enthusiast 📸',
        profileImageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
        followersCount: 5432,
        followingCount: 234,
        postsCount: 156,
      ),
      'user_3': UserModel(
        id: 'user_3',
        name: 'Mike Chen',
        email: 'mike@example.com',
        bio: 'Entrepreneur | Tech enthusiast | Building the future 🚀',
        profileImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        followersCount: 12345,
        followingCount: 567,
        postsCount: 234,
      ),
    };
    
    return users[userId] ?? UserModel(
      id: userId,
      name: 'Unknown User',
      email: 'unknown@example.com',
    );
  }

  void addPost(PostModel post) {
    _posts.insert(0, post);
  }

  void toggleLike(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = post.copyWith(
        isLiked: !post.isLiked,
        likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
      );
    }
  }

  void markNotificationAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  void markAllNotificationsAsRead() {
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }

  int get unreadNotificationCount =>
    _notifications.where((n) => !n.isRead).length;
}