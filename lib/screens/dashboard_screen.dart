import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/routes.dart';
import '../config/theme.dart';
import '../controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/post_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_indicator.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardController>().loadFeedPosts();
    });
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      final controller = context.read<DashboardController>();
      switch (_tabController.index) {
        case 0:
          controller.setTab(DashboardTab.feed);
          break;
        case 1:
          controller.setTab(DashboardTab.trending);
          break;
        case 2:
          controller.setTab(DashboardTab.notifications);
          break;
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await context.read<AuthController>().logout();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed(AppRoutes.login);
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Connect'),
        actions: [
          Consumer<DashboardController>(
            builder: (context, controller, _) {
              final unreadCount = controller.unreadNotificationCount;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.notifications);
                    },
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.errorColor,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          unreadCount > 9 ? '9+' : unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.profile,
                arguments: {'isOwnProfile': true},
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _showLogoutDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Feed'),
            Tab(text: 'Trending'),
            Tab(text: 'Discover'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search posts or users...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                context
                                    .read<DashboardController>()
                                    .setSearchQuery('');
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      context
                          .read<DashboardController>()
                          .setSearchQuery(value);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Consumer<DashboardController>(
                  builder: (context, controller, _) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.dividerColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        value: controller.selectedFilter,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.filter_list),
                        items: controller.filters.map((filter) {
                          return DropdownMenuItem(
                            value: filter,
                            child: Text(filter),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.setFilter(value);
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFeedTab(),
                _buildTrendingTab(),
                _buildDiscoverTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.postCreation);
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFeedTab() {
    return Consumer<DashboardController>(
      builder: (context, controller, _) {
        if (controller.isLoading && controller.feedPosts.isEmpty) {
          return const LoadingIndicator();
        }

        if (controller.feedPosts.isEmpty) {
          return EmptyState(
            icon: Icons.article_outlined,
            title: 'No Posts Yet',
            message: 'Be the first to share something with the community!',
            actionLabel: 'Create Post',
            onAction: () {
              Navigator.of(context).pushNamed(AppRoutes.postCreation);
            },
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadFeedPosts(),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: controller.feedPosts.length,
            itemBuilder: (context, index) {
              final post = controller.feedPosts[index];
              return PostCard(
                post: post,
                onLike: () => controller.toggleLike(post.id),
                onComment: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Comments feature coming soon!'),
                    ),
                  );
                },
                onShare: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share feature coming soon!'),
                    ),
                  );
                },
                onProfileTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.profile,
                    arguments: {
                      'userId': post.userId,
                      'isOwnProfile': false,
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTrendingTab() {
    return Consumer<DashboardController>(
      builder: (context, controller, _) {
        if (controller.isLoading && controller.trendingPosts.isEmpty) {
          return const LoadingIndicator();
        }

        if (controller.trendingPosts.isEmpty) {
          return const EmptyState(
            icon: Icons.trending_up,
            title: 'No Trending Posts',
            message: 'Check back later for trending content!',
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadTrendingPosts(),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: controller.trendingPosts.length,
            itemBuilder: (context, index) {
              final post = controller.trendingPosts[index];
              return PostCard(
                post: post,
                onLike: () => controller.toggleLike(post.id),
                onComment: () {},
                onShare: () {},
                onProfileTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.profile,
                    arguments: {
                      'userId': post.userId,
                      'isOwnProfile': false,
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDiscoverTab() {
    return const EmptyState(
      icon: Icons.explore_outlined,
      title: 'Discover New Connections',
      message: 'Explore and find interesting people to follow!',
    );
  }
}