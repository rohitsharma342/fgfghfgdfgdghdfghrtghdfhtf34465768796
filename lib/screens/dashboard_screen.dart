import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../app/routes.dart';
import '../config/theme.dart';
import '../controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/notification_controller.dart';
import '../services/static_data_service.dart';
import '../widgets/post_card.dart';
import '../widgets/loading_indicator.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardController>().loadFeed();
      context.read<NotificationController>().loadNotifications();
    });
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      final tabs = [DashboardTab.feed, DashboardTab.trending, DashboardTab.notifications];
      context.read<DashboardController>().setCurrentTab(tabs[_tabController.index]);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFeedTab(),
                _buildTrendingTab(),
                _buildNotificationsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.createPost),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.surfaceColor,
      elevation: 0,
      title: const Text(
        'Social Connect',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimaryColor,
        ),
      ),
      actions: [
        Consumer<NotificationController>(
          builder: (context, notifController, child) {
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => context.push(AppRoutes.notifications),
                ),
                if (notifController.unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.errorColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        notifController.unreadCount > 9
                            ? '9+'
                            : notifController.unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        GestureDetector(
          onTap: () => context.push(AppRoutes.profile),
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.dividerColor,
              backgroundImage: CachedNetworkImageProvider(
                StaticDataService.currentUser.profileImageUrl!,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      color: AppTheme.surfaceColor,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  context.read<DashboardController>().setSearchQuery(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Search posts or users...',
                  prefixIcon: Icon(Icons.search, color: AppTheme.textSecondaryColor),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Consumer<DashboardController>(
            builder: (context, controller, child) {
              return Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedCategory,
                    icon: const Icon(Icons.filter_list, size: 20),
                    items: controller.categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(
                          category,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.setSelectedCategory(value);
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.surfaceColor,
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Feed'),
          Tab(text: 'Trending'),
          Tab(text: 'Activity'),
        ],
        labelColor: AppTheme.primaryColor,
        unselectedLabelColor: AppTheme.textSecondaryColor,
        indicatorColor: AppTheme.primaryColor,
        indicatorWeight: 3,
      ),
    );
  }

  Widget _buildFeedTab() {
    return Consumer<DashboardController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const LoadingIndicator();
        }

        if (controller.feedPosts.isEmpty) {
          return _buildEmptyState(
            icon: Icons.article_outlined,
            title: 'No posts yet',
            message: 'Be the first to share something!',
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshFeed,
          color: AppTheme.primaryColor,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: controller.feedPosts.length,
            itemBuilder: (context, index) {
              final post = controller.feedPosts[index];
              return PostCard(
                post: post,
                onLike: () => controller.toggleLike(post.id),
                onComment: () {},
                onShare: () {},
                onBookmark: () => controller.toggleBookmark(post.id),
                onProfileTap: () => context.push(
                  '${AppRoutes.profile}?userId=${post.author.id}',
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTrendingTab() {
    return Consumer<DashboardController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const LoadingIndicator();
        }

        if (controller.trendingPosts.isEmpty) {
          return _buildEmptyState(
            icon: Icons.trending_up,
            title: 'No trending posts',
            message: 'Check back later for popular content!',
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshFeed,
          color: AppTheme.primaryColor,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: controller.trendingPosts.length,
            itemBuilder: (context, index) {
              final post = controller.trendingPosts[index];
              return PostCard(
                post: post,
                onLike: () => controller.toggleLike(post.id),
                onComment: () {},
                onShare: () {},
                onBookmark: () => controller.toggleBookmark(post.id),
                onProfileTap: () => context.push(
                  '${AppRoutes.profile}?userId=${post.author.id}',
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildNotificationsTab() {
    return Consumer<NotificationController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const LoadingIndicator();
        }

        if (controller.notifications.isEmpty) {
          return _buildEmptyState(
            icon: Icons.notifications_outlined,
            title: 'No notifications',
            message: 'You\'re all caught up!',
          );
        }

        return ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                backgroundImage: notification.actorImageUrl != null
                    ? CachedNetworkImageProvider(notification.actorImageUrl!)
                    : null,
                child: notification.actorImageUrl == null
                    ? const Icon(Icons.person, color: AppTheme.primaryColor)
                    : null,
              ),
              title: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: notification.actorName ?? '',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: ' ${notification.message}'),
                  ],
                ),
              ),
              trailing: !notification.isRead
                  ? Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
              onTap: () => controller.markAsRead(notification.id),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppTheme.textSecondaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}