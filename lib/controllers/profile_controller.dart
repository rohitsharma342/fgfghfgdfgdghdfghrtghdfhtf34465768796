import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../services/static_data_service.dart';

class ProfileController extends ChangeNotifier {
  UserModel? _user;
  List<PostModel> _userPosts = [];
  bool _isLoading = false;
  bool _isOwnProfile = false;
  String? _errorMessage;

  UserModel? get user => _user;
  List<PostModel> get userPosts => _userPosts;
  bool get isLoading => _isLoading;
  bool get isOwnProfile => _isOwnProfile;
  String? get errorMessage => _errorMessage;

  Future<void> loadProfile(String? userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    if (userId == null || userId == 'current') {
      _user = StaticDataService.currentUser;
      _isOwnProfile = true;
      _userPosts = StaticDataService.posts
          .where((post) => post.author.id == 'current' || post.author.id == '1')
          .toList();
    } else {
      _user = StaticDataService.users.firstWhere(
        (u) => u.id == userId,
        orElse: () => StaticDataService.users[0],
      );
      _isOwnProfile = false;
      _userPosts = StaticDataService.posts
          .where((post) => post.author.id == userId)
          .toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  void toggleFollow() {
    if (_user != null && !_isOwnProfile) {
      _user = _user!.copyWith(
        isFollowing: !_user!.isFollowing,
        followersCount: _user!.isFollowing
            ? _user!.followersCount - 1
            : _user!.followersCount + 1,
      );
      notifyListeners();
    }
  }

  void updateProfile({
    String? name,
    String? bio,
    String? profileImageUrl,
  }) {
    if (_user != null && _isOwnProfile) {
      _user = _user!.copyWith(
        name: name ?? _user!.name,
        bio: bio ?? _user!.bio,
        profileImageUrl: profileImageUrl ?? _user!.profileImageUrl,
      );
      notifyListeners();
    }
  }

  void clearProfile() {
    _user = null;
    _userPosts = [];
    _isOwnProfile = false;
    notifyListeners();
  }
}