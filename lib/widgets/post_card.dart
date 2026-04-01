import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../models/post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onProfileTap;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onProfileTap,
  });

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onProfileTap,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    backgroundImage: post.userProfileUrl != null
                        ? NetworkImage(post.userProfileUrl!)
                        : null,
                    child: post.userProfileUrl == null
                        ? Text(
                            post.userName.isNotEmpty
                                ? post.userName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: onProfileTap,
                        child: Text(
                          post.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            _formatTime(post.createdAt),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          if (post.category != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                post.category!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.more_horiz,
                    color: AppTheme.textSecondary,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              post.content,
              style: const TextStyle(
                fontSize: 15,
                color: AppTheme.textPrimary,
                height: 1.4,
              ),
            ),
          ),
          if (post.imageUrl != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              child: Image.network(
                post.imageUrl!,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: AppTheme.dividerColor,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 48,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    color: AppTheme.dividerColor,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _ActionButton(
                  icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                  label: _formatCount(post.likesCount),
                  color: post.isLiked ? AppTheme.errorColor : AppTheme.textSecondary,
                  onTap: onLike,
                ),
                const SizedBox(width: 24),
                _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: _formatCount(post.commentsCount),
                  color: AppTheme.textSecondary,
                  onTap: onComment,
                ),
                const SizedBox(width: 24),
                _ActionButton(
                  icon: Icons.share_outlined,
                  label: _formatCount(post.sharesCount),
                  color: AppTheme.textSecondary,
                  onTap: onShare,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}