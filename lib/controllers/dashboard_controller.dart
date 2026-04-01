import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/data_service.dart';

enum DashboardTab { feed, trending, notifications }

class DashboardController extends ChangeNotifier {
  final DataService _dataService = DataService();
  
  DashboardTab _currentTab = DashboardTab.feed;
  List<PostModel> _feedPosts = [];
  List<PostModel> _trendingPosts = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> filters = [
    'All',
    'Travel',
    'Business',
    'Food',
    'Fitness',
    'Books',
    'Photography',
    'Technology',
    'News',
    'Sports',
  ];

  DashboardTab get currentTab => _currentTab;
  List<PostModel> get feedPosts => _feedPosts;
  List<PostModel> get trendingPosts => _trendingPosts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;
  int get unreadNotificationCount => _dataService.unreadNotificationCount;

  Future<void> loadFeedPosts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _feedPosts = await _dataService.getFeedPosts(
        filter: _selectedFilter,
        searchQuery: _searchQuery,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load posts. Please try again.';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTrendingPosts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _trendingPosts = await _dataService.getTrendingPosts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load trending posts. Please try again.';
      _isLoading = false;
      notifyListeners();
    }
  }

  void setTab(DashboardTab tab) {
    _currentTab = tab;
    notifyListeners();
    
    if (tab == DashboardTab.feed && _feedPosts.isEmpty) {
      loadFeedPosts();
    } else if (tab == DashboardTab.trending && _trendingPosts.isEmpty) {
      loadTrendingPosts();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadFeedPosts();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    loadFeedPosts();
  }

  void toggleLike(String postId) {
    _dataService.toggleLike(postId);
    
    final feedIndex = _feedPosts.indexWhere((p) => p.id == postId);
    if (feedIndex != -1) {
      final post = _feedPosts[feedIndex];
      _feedPosts[feedIndex] = post.copyWith(
        isLiked: !post.isLiked,
        likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
      );
    }
    
    final trendingIndex = _trendingPosts.indexWhere((p) => p.id == postId);
    if (trendingIndex != -1) {
      final post = _trendingPosts[trendingIndex];
      _trendingPosts[trendingIndex] = post.copyWith(
        isLiked: !post.isLiked,
        likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
      );
    }
    
    notifyListeners();
  }

  void addNewPost(PostModel post) {
    _feedPosts.insert(0, post);
    _dataService.addPost(post);
    notifyListeners();
  }

  void refresh() {
    if (_currentTab == DashboardTab.feed) {
      loadFeedPosts();
    } else if (_currentTab == DashboardTab.trending) {
      loadTrendingPosts();
    }
  }
}