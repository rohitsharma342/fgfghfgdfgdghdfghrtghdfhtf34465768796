import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/static_data_service.dart';

enum DashboardTab { feed, trending, notifications }

class DashboardController extends ChangeNotifier {
  DashboardTab _currentTab = DashboardTab.feed;
  List<PostModel> _feedPosts = [];
  List<PostModel> _trendingPosts = [];
  List<PostModel> _filteredPosts = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isLoading = false;
  String? _errorMessage;

  DashboardTab get currentTab => _currentTab;
  List<PostModel> get feedPosts => _filteredPosts.isEmpty && _searchQuery.isEmpty && _selectedCategory == 'All' 
      ? _feedPosts 
      : _filteredPosts;
  List<PostModel> get trendingPosts => _trendingPosts;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<String> get categories => StaticDataService.categories;

  Future<void> loadFeed() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    _feedPosts = List.from(StaticDataService.posts);
    _trendingPosts = List.from(StaticDataService.trendingPosts);
    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  void setCurrentTab(DashboardTab tab) {
    _currentTab = tab;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredPosts = _feedPosts.where((post) {
      bool matchesSearch = _searchQuery.isEmpty ||
          post.content.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          post.author.name.toLowerCase().contains(_searchQuery.toLowerCase());
      
      bool matchesCategory = _selectedCategory == 'All' ||
          post.category == _selectedCategory;
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void toggleLike(String postId) {
    final index = _feedPosts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = _feedPosts[index];
      _feedPosts[index] = post.copyWith(
        isLiked: !post.isLiked,
        likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
      );
      _applyFilters();
      notifyListeners();
    }
  }

  void toggleBookmark(String postId) {
    final index = _feedPosts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = _feedPosts[index];
      _feedPosts[index] = post.copyWith(
        isBookmarked: !post.isBookmarked,
      );
      _applyFilters();
      notifyListeners();
    }
  }

  void addPost(PostModel post) {
    _feedPosts.insert(0, post);
    _applyFilters();
    notifyListeners();
  }

  Future<void> refreshFeed() async {
    await loadFeed();
  }
}