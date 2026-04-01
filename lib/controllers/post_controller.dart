import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/static_data_service.dart';

class PostController extends ChangeNotifier {
  String _content = '';
  List<String> _selectedMedia = [];
  bool _isLoading = false;
  String? _errorMessage;
  double _uploadProgress = 0.0;

  String get content => _content;
  List<String> get selectedMedia => _selectedMedia;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get uploadProgress => _uploadProgress;
  bool get canPost => _content.isNotEmpty || _selectedMedia.isNotEmpty;

  void setContent(String content) {
    _content = content;
    notifyListeners();
  }

  void addMedia(String mediaUrl) {
    if (_selectedMedia.length < 4) {
      _selectedMedia.add(mediaUrl);
      notifyListeners();
    }
  }

  void removeMedia(int index) {
    if (index >= 0 && index < _selectedMedia.length) {
      _selectedMedia.removeAt(index);
      notifyListeners();
    }
  }

  void clearMedia() {
    _selectedMedia = [];
    notifyListeners();
  }

  Future<PostModel?> createPost() async {
    if (!canPost) {
      _errorMessage = 'Please add some content or media';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _errorMessage = null;
    _uploadProgress = 0.0;
    notifyListeners();

    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      _uploadProgress = i / 10;
      notifyListeners();
    }

    final newPost = PostModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _content,
      mediaUrls: List.from(_selectedMedia),
      author: StaticDataService.currentUser,
      createdAt: DateTime.now(),
    );

    _content = '';
    _selectedMedia = [];
    _isLoading = false;
    _uploadProgress = 0.0;
    notifyListeners();

    return newPost;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _content = '';
    _selectedMedia = [];
    _isLoading = false;
    _errorMessage = null;
    _uploadProgress = 0.0;
    notifyListeners();
  }
}