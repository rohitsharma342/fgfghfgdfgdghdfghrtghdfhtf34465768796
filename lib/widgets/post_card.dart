import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../models/post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onBookmark;
  final VoidCallback? onProfileTap;

  const PostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onBookmark,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildContent(),
            if (post.mediaUrls.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildMedia(),
            ],
            const SizedBox(height: 12),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return GestureDetector(
      onTap: onProfileTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.dividerColor,
            backgroundImage: post.author.profileImageUrl != null
                ? CachedNetworkImageProvider(post.author.profileImageUrl!)
                : null,
            child: post.author.profileImageUrl == null
                ? Text(
                    post.author.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.author.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                Text(
                  _formatTimeAgo(post.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          if (post.category != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: AppTheme.textSecondaryColor),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Text(
      post.content,
      style: const TextStyle(
        fontSize: 15,
        height: 1.4,
        color: AppTheme.textPrimaryColor,
      ),
    );
  }

  Widget _buildMedia() {
    if (post.mediaUrls.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: post.mediaUrls[0],
          fit: BoxFit.cover,
          width: double.infinity,
          height: 200,
          placeholder: (context, url) => Container(
            height: 200,
            color: AppTheme.dividerColor,
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            height: 200,
            color: AppTheme.dividerColor,
            child: const Icon(Icons.error),
          ),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: post.mediaUrls.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: post.mediaUrls[index],
              fit: BoxFit.cover,
              width: 200,
              height: 200,
              placeholder: (context, url) => Container(
                width: 200,
                color: AppTheme.dividerColor,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                width: 200,
                color: AppTheme.dividerColor,
                child: const Icon(Icons.error),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        _ActionButton(
          icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
          label: _formatCount(post.likesCount),
          color: post.isLiked ? Colors.red : AppTheme.textSecondaryColor,
          onTap: onLike,
        ),
        const SizedBox(width: 24),
        _ActionButton(
          icon: Icons.chat_bubble_outline,
          label: _formatCount(post.commentsCount),
          onTap: onComment,
        ),
        const SizedBox(width: 24),
        _ActionButton(
          icon: Icons.share_outlined,
          label: _formatCount(post.sharesCount),
          onTap: onShare,
        ),
        const Spacer(),
        IconButton(
          icon: Icon(
            post.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: post.isBookmarked ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
          ),
          onPressed: onBookmark,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
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
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: color ?? AppTheme.textSecondaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: color ?? AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}