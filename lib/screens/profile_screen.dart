import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../app/routes.dart';
import '../config/theme.dart';
import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import '../widgets/post_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_indicator.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileController>().loadProfile(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Consumer<ProfileController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const LoadingIndicator();
          }

          if (controller.user == null) {
            return const Center(
              child: Text('User not found'),
            );
          }

          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(controller),
              SliverToBoxAdapter(
                child: _buildProfileHeader(controller),
              ),
              SliverToBoxAdapter(
                child: _buildStats(controller),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Posts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                ),
              ),
              controller.userPosts.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.article_outlined,
                              size: 64,
                              color: AppTheme.textSecondaryColor.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No posts yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = controller.userPosts[index];
                          return PostCard(
                            post: post,
                            onLike: () {},
                            onComment: () {},
                            onShare: () {},
                            onBookmark: () {},
                          );
                        },
                        childCount: controller.userPosts.length,
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(ProfileController controller) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppTheme.primaryColor,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black26,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        if (controller.isOwnProfile)
          PopupMenuButton<String>(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.more_vert, color: Colors.white),
            ),
            onSelected: (value) async {
              if (value == 'logout') {
                await context.read<AuthController>().logout();
                if (context.mounted) {
                  context.go(AppRoutes.login);
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 20),
                    SizedBox(width: 12),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20, color: AppTheme.errorColor),
                    SizedBox(width: 12),
                    Text('Logout', style: TextStyle(color: AppTheme.errorColor)),
                  ],
                ),
              ),
            ],
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileController controller) {
    final user = controller.user!;
    return Container(
      color: AppTheme.surfaceColor,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Transform.translate(
            offset: const Offset(0, -60),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.dividerColor,
                    backgroundImage: user.profileImageUrl != null
                        ? CachedNetworkImageProvider(user.profileImageUrl!)
                        : null,
                    child: user.profileImageUrl == null
                        ? Text(
                            user.name[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                if (user.bio != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    user.bio!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                if (controller.isOwnProfile)
                  CustomButton(
                    text: 'Edit Profile',
                    onPressed: () {},
                    isOutlined: true,
                    icon: Icons.edit,
                    width: 160,
                    height: 44,
                  )
                else
                  CustomButton(
                    text: user.isFollowing ? 'Following' : 'Follow',
                    onPressed: controller.toggleFollow,
                    isOutlined: user.isFollowing,
                    icon: user.isFollowing ? Icons.check : Icons.person_add,
                    width: 140,
                    height: 44,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(ProfileController controller) {
    final user = controller.user!;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('Posts', user.postsCount),
          Container(
            width: 1,
            height: 40,
            color: AppTheme.dividerColor,
          ),
          _buildStatItem('Followers', user.followersCount),
          Container(
            width: 1,
            height: 40,
            color: AppTheme.dividerColor,
          ),
          _buildStatItem('Following', user.followingCount),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count) {
    return Column(
      children: [
        Text(
          _formatCount(count),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}