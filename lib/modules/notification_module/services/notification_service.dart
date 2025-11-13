import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notification_providers.dart';
import '../components/notification_dialog.dart';
import '../models/notification_model.dart';
import '../../../core/services/navigation_service.dart';

/// 通知服務介面
abstract class INotificationService {
  void pushNotification(String title, String content);
  void markAsRead(String id);
  void markAllAsRead();
  void deleteNotification(String id);
  void clearNotifications();
  void showNotificationDialog();
  List<NotificationModel> getUnreadNotifications();
  List<NotificationModel> getAllNotifications();
}

/// 通知服務實作
class NotificationService implements INotificationService {
  final Ref _ref;

  NotificationService(this._ref);

  @override
  void pushNotification(String title, String content) {
    print('🆕 新通知: $title');
    _ref.read(notificationProvider.notifier).addNotification(title, content);
  }

  @override
  void markAsRead(String id) {
    _ref.read(notificationProvider.notifier).markAsRead(id);
  }

  @override
  void markAllAsRead() {
    _ref.read(notificationProvider.notifier).markAllAsRead();
  }

  @override
  void deleteNotification(String id) {
    _ref.read(notificationProvider.notifier).deleteNotification(id);
  }

  @override
  void clearNotifications() {
    _ref.read(notificationProvider.notifier).clearAll();
  }

  @override
  List<NotificationModel> getUnreadNotifications() {
    return _ref.read(notificationProvider.notifier).unreadNotifications;
  }

  @override
  List<NotificationModel> getAllNotifications() {
    return _ref.read(notificationProvider).notifications;
  }

  @override
  void showNotificationDialog() {
    final context = NavigationService.currentContext;
    if (context == null) {
      print('❌ Context 不可用，無法顯示通知彈窗');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => const NotificationDialog(),
    );
  }
}

/// Provider 註冊服務
final notificationServiceProvider = Provider<INotificationService>(
      (ref) => NotificationService(ref),
);