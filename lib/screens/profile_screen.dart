import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../controllers/profile_controller.dart';
import '../controllers/auth_controller.dart';
import '../widgets/post_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/empty_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;
  final bool isOwnProfile;

  const ProfileScreen({
    super.key,
    this.userId,
    this.isOwnProfile = true,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileController>().loadProfile(
            widget.userId,
            widget.isOwnProfile,
          );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _startEditing() {
    final controller = context.read<ProfileController>();
    _nameController.text = controller.user?.name ?? '';
    _bioController.text = controller.user?.bio ?? '';
    controller.setEditing(true);
  }

  void _saveProfile() {
    context.read<ProfileController>().updateProfile(
          _nameController.text.trim(),
          _bioController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Profile'),
        actions: [
          if (widget.isOwnProfile)
            Consumer<ProfileController>(
              builder: (context, controller, _) {
                if (controller.isEditing) {
                  return Row(
                    children: [
                      TextButton(
                        onPressed: () => controller.setEditing(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: _saveProfile,
                        child: const Text('Save'),
                      ),
                    ],
                  );
                }
                return IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: _startEditing,
                );
              },
            ),
        ],
      ),
      body: Consumer<ProfileController>(
        builder: (context, controller, _) {
          if (controller.isLoading && controller.user == null) {
            return const LoadingIndicator();
          }

          if (controller.user == null) {
            return const EmptyState(
              icon: Icons.person_off_outlined,
              title: 'Profile Not Found',
              message: 'Unable to load profile information.',
            );
          }

          final user = controller.user!;

          return RefreshIndicator(
            onRefresh: () => controller.loadProfile(
              widget.userId,
              widget.isOwnProfile,
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                          backgroundImage: user.profileImageUrl != null
                              ? NetworkImage(user.profileImageUrl!)
                              : null,
                          child: user.profileImageUrl == null
                              ? Text(
                                  user.name.isNotEmpty
                                      ? user.name[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 16),
                        if (controller.isEditing) ...[
                          CustomTextField(
                            controller: _nameController,
                            label: 'Name',
                            hint: 'Enter your name',
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: _bioController,
                            label: 'Bio',
                            hint: 'Tell us about yourself',
                            maxLines: 3,
                          ),
                        ] else ...[
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (user.bio != null && user.bio!.isNotEmpty)
                            Text(
                              user.bio!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ],
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatItem(
                              label: 'Posts',
                              value: user.postsCount.toString(),
                            ),
                            _StatItem(
                              label: 'Followers',
                              value: _formatCount(user.followersCount),
                            ),
                            _StatItem(
                              label: 'Following',
                              value: _formatCount(user.followingCount),
                            ),
                          ],
                        ),
                        if (!widget.isOwnProfile) ...[
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 200,
                            child: CustomButton(
                              text: user.isFollowing ? 'Following' : 'Follow',
                              onPressed: controller.toggleFollow,
                              isOutlined: user.isFollowing,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.grid_view_rounded,
                          color: AppTheme.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Posts (${controller.userPosts.length})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (controller.userPosts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: EmptyState(
                        icon: Icons.article_outlined,
                        title: 'No Posts Yet',
                        message: 'Posts will appear here.',
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.userPosts.length,
                      itemBuilder: (context, index) {
                        final post = controller.userPosts[index];
                        return PostCard(
                          post: post,
                          onLike: () => controller.toggleLike(post.id),
                          onComment: () {},
                          onShare: () {},
                          onProfileTap: () {},
                        );
                      },
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
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

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}