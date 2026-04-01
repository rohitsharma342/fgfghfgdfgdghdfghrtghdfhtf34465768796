import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../services/auth_service.dart';
import '../services/data_service.dart';

class ProfileController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final DataService _dataService = DataService();
  
  UserModel? _user;
  List<PostModel> _userPosts = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isEditing = false;

  UserModel? get user => _user;
  List<PostModel> get userPosts => _userPosts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEditing => _isEditing;

  Future<void> loadProfile(String? userId, bool isOwnProfile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (isOwnProfile) {
        _user = _authService.currentUser;
      } else if (userId != null) {
        _user = await _dataService.getUserProfile(userId);
      }

      if (_user != null) {
        _userPosts = await _dataService.getUserPosts(_user!.id);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load profile. Please try again.';
      _isLoading = false;
      notifyListeners();
    }
  }

  void setEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  Future<void> updateProfile(String name, String bio) async {
    if (_user == null) return;

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _user = _user!.copyWith(name: name, bio: bio);
    _isEditing = false;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFollow() async {
    if (_user == null) return;

    _user = _user!.copyWith(
      isFollowing: !_user!.isFollowing,
      followersCount: _user!.isFollowing
          ? _user!.followersCount - 1
          : _user!.followersCount + 1,
    );
    notifyListeners();
  }

  void toggleLike(String postId) {
    final index = _userPosts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _userPosts[index];
      _userPosts[index] = post.copyWith(
        isLiked: !post.isLiked,
        likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
      );
      notifyListeners();
    }
  }
}