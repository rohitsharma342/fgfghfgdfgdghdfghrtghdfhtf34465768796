import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/post_model.dart';
import '../services/auth_service.dart';

class PostController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  String _content = '';
  String? _selectedImageUrl;
  bool _isLoading = false;
  String? _errorMessage;
  double _uploadProgress = 0.0;

  String get content => _content;
  String? get selectedImageUrl => _selectedImageUrl;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get uploadProgress => _uploadProgress;
  bool get canPost => _content.trim().isNotEmpty || _selectedImageUrl != null;

  final List<String> sampleImages = [
    'https://images.unsplash.com/photo-1682687220742-aba13b6e50ba?w=800',
    'https://images.unsplash.com/photo-1682687221038-404670f01d03?w=800',
    'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=800',
    'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800',
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
  ];

  void setContent(String value) {
    _content = value;
    notifyListeners();
  }

  void selectImage(String? imageUrl) {
    _selectedImageUrl = imageUrl;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _content = '';
    _selectedImageUrl = null;
    _isLoading = false;
    _errorMessage = null;
    _uploadProgress = 0.0;
    notifyListeners();
  }

  Future<PostModel?> createPost() async {
    if (!canPost) {
      _errorMessage = 'Please add some content or an image to your post.';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      for (var i = 0; i <= 100; i += 20) {
        await Future.delayed(const Duration(milliseconds: 200));
        _uploadProgress = i / 100;
        notifyListeners();
      }

      final user = _authService.currentUser;
      if (user == null) {
        _errorMessage = 'You must be logged in to create a post.';
        _isLoading = false;
        notifyListeners();
        return null;
      }

      final post = PostModel(
        id: 'post_${const Uuid().v4()}',
        userId: user.id,
        userName: user.name,
        userProfileUrl: user.profileImageUrl,
        content: _content.trim(),
        imageUrl: _selectedImageUrl,
        createdAt: DateTime.now(),
      );

      _isLoading = false;
      reset();
      return post;
    } catch (e) {
      _errorMessage = 'Failed to create post. Please try again.';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}