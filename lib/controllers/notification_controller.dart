import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/data_service.dart';

class NotificationController extends ChangeNotifier {
  final DataService _dataService = DataService();
  
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> loadNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notifications = await _dataService.getNotifications();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load notifications. Please try again.';
      _isLoading = false;
      notifyListeners();
    }
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _dataService.markNotificationAsRead(notificationId);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    _dataService.markAllNotificationsAsRead();
    notifyListeners();
  }
}