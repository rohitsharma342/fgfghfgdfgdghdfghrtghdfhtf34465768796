import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/theme.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/post_controller.dart';
import '../services/static_data_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

class PostCreationScreen extends StatefulWidget {
  const PostCreationScreen({super.key});

  @override
  State<PostCreationScreen> createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends State<PostCreationScreen> {
  final _contentController = TextEditingController();
  final _focusNode = FocusNode();

  final List<String> _sampleImages = [
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
    'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800',
    'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=800',
    'https://images.unsplash.com/photo-1433086966358-54859d0ed716?w=800',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostController>().reset();
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handlePost() async {
    final postController = context.read<PostController>();
    final dashboardController = context.read<DashboardController>();

    final newPost = await postController.createPost();
    if (newPost != null && mounted) {
      dashboardController.addPost(newPost);
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post created successfully!'),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Image',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _sampleImages.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        context.read<PostController>().addMedia(_sampleImages[index]);
                        Navigator.pop(context);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: _sampleImages[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: const Text('Create Post'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Consumer<PostController>(
              builder: (context, controller, child) {
                return CustomButton(
                  text: 'Post',
                  onPressed: controller.canPost ? _handlePost : null,
                  isLoading: controller.isLoading,
                  height: 36,
                );
              },
            ),
          ),
        ],
      ),
      body: Consumer<PostController>(
        builder: (context, controller, child) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: CachedNetworkImageProvider(
                              StaticDataService.currentUser.profileImageUrl!,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  StaticDataService.currentUser.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                TextField(
                                  controller: _contentController,
                                  focusNode: _focusNode,
                                  maxLines: null,
                                  maxLength: AppConstants.maxPostLength,
                                  onChanged: controller.setContent,
                                  style: const TextStyle(fontSize: 16),
                                  decoration: const InputDecoration(
                                    hintText: "What's on your mind?",
                                    border: InputBorder.none,
                                    counterText: '',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (controller.selectedMedia.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildMediaPreview(controller),
                      ],
                      if (controller.errorMessage != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.errorColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: AppTheme.errorColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  controller.errorMessage!,
                                  style: const TextStyle(
                                    color: AppTheme.errorColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (controller.isLoading)
                LinearProgressIndicator(
                  value: controller.uploadProgress,
                  backgroundColor: AppTheme.dividerColor,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                ),
              _buildBottomBar(controller),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMediaPreview(PostController controller) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: controller.selectedMedia.asMap().entries.map((entry) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: entry.value,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => controller.removeMedia(entry.key),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildBottomBar(PostController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          top: BorderSide(color: AppTheme.dividerColor.withOpacity(0.5)),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.image_outlined),
              color: controller.selectedMedia.length >= AppConstants.maxMediaCount
                  ? AppTheme.textSecondaryColor.withOpacity(0.5)
                  : AppTheme.primaryColor,
              onPressed: controller.selectedMedia.length >= AppConstants.maxMediaCount
                  ? null
                  : _showImagePicker,
            ),
            IconButton(
              icon: const Icon(Icons.gif_box_outlined),
              color: AppTheme.primaryColor,
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.location_on_outlined),
              color: AppTheme.primaryColor,
              onPressed: () {},
            ),
            const Spacer(),
            Text(
              '${controller.content.length}/${AppConstants.maxPostLength}',
              style: TextStyle(
                fontSize: 12,
                color: controller.content.length > AppConstants.maxPostLength - 50
                    ? AppTheme.errorColor
                    : AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}