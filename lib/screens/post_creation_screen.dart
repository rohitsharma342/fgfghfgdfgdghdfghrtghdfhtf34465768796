import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../controllers/post_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/custom_button.dart';

class PostCreationScreen extends StatefulWidget {
  const PostCreationScreen({super.key});

  @override
  State<PostCreationScreen> createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends State<PostCreationScreen> {
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostController>().reset();
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _handlePost() async {
    final postController = context.read<PostController>();
    final post = await postController.createPost();

    if (post != null && mounted) {
      context.read<DashboardController>().addNewPost(post);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post created successfully!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  void _showImagePicker() {
    final postController = context.read<PostController>();
    
    showModalBottomSheet(
      context: context,
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
                'Select an Image',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: postController.sampleImages.length,
                  itemBuilder: (context, index) {
                    final imageUrl = postController.sampleImages[index];
                    return GestureDetector(
                      onTap: () {
                        postController.selectImage(imageUrl);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  postController.selectImage(null);
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.clear),
                label: const Text('Remove Image'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Create Post'),
        actions: [
          Consumer<PostController>(
            builder: (context, controller, _) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CustomButton(
                  text: 'Post',
                  onPressed: controller.canPost ? _handlePost : null,
                  isLoading: controller.isLoading,
                  isSmall: true,
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<PostController>(
        builder: (context, controller, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (controller.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
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
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 18,
                            color: AppTheme.errorColor,
                          ),
                          onPressed: controller.clearError,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                TextField(
                  controller: _contentController,
                  maxLines: 8,
                  maxLength: 500,
                  decoration: const InputDecoration(
                    hintText: "What's on your mind?",
                    border: InputBorder.none,
                    filled: false,
                  ),
                  style: const TextStyle(fontSize: 16),
                  onChanged: (value) => controller.setContent(value),
                ),
                const Divider(),
                const SizedBox(height: 16),
                if (controller.selectedImageUrl != null) ...
                  [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            controller.selectedImageUrl!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: AppTheme.dividerColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    size: 48,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => controller.selectImage(null),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                if (controller.isLoading)
                  Column(
                    children: [
                      LinearProgressIndicator(
                        value: controller.uploadProgress,
                        backgroundColor: AppTheme.dividerColor,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Posting... ${(controller.uploadProgress * 100).toInt()}%',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _ActionButton(
                      icon: Icons.image_outlined,
                      label: 'Photo',
                      onTap: _showImagePicker,
                    ),
                    const SizedBox(width: 16),
                    _ActionButton(
                      icon: Icons.videocam_outlined,
                      label: 'Video',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Video upload coming soon!'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    _ActionButton(
                      icon: Icons.location_on_outlined,
                      label: 'Location',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Location tagging coming soon!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}