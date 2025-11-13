import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';

/// 通知狀態類別 - 管理通知列表與未讀數量
class NotificationState {
  final List<NotificationModel> notifications;        // 簡化示例：通知訊息字串陣列
  final int unreadCount;

  const NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
  });

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    int? unreadCount,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  String toString() => 'NotificationState(unread: $unreadCount, total: ${notifications.length})';
}

/// 管理通知狀態的 Notifier
class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier() : super(const NotificationState());

  /// 新增通知
  void addNotification(String title, String content) {
    final newNotification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      isRead: false,
      // createdAt: DateTime.now(),
    );

    final newList = [newNotification, ...state.notifications];
    state = state.copyWith(
      notifications: newList,
      unreadCount: state.unreadCount + 1,
    );

    print('📩 新增通知: $title (未讀: ${state.unreadCount})');
  }

  /// 標記單個通知為已讀
  void markAsRead(String id) {
    final updatedList = state.notifications.map((notification) {
      if (notification.id == id && !notification.isRead) {
        return notification.markAsRead();
      }
      return notification;
    }).toList();

    final unreadCount = updatedList.where((n) => !n.isRead).length;

    state = state.copyWith(
      notifications: updatedList,
      unreadCount: unreadCount,
    );

    print('✅ 標記已讀: $id (剩餘未讀: $unreadCount)');
  }

  /// 標記所有通知為已讀
  void markAllAsRead() {
    final updatedList = state.notifications
        .map((notification) => notification.markAsRead())
        .toList();

    state = state.copyWith(
      notifications: updatedList,
      unreadCount: 0,
    );

    print('✅ 全部標記已讀');
  }

  /// 刪除單個通知
  void deleteNotification(String id) {
    final notification = state.notifications.firstWhere((n) => n.id == id);
    final newList = state.notifications.where((n) => n.id != id).toList();
    final unreadCount = notification.isRead
        ? state.unreadCount
        : state.unreadCount - 1;

    state = state.copyWith(
      notifications: newList,
      unreadCount: unreadCount,
    );

    print('🗑️ 刪除通知: $id');
  }

  /// 清空所有通知
  void clearAll() {
    state = const NotificationState();
    print('🗑️ 清空所有通知');
  }

  /// 獲取未讀通知
  List<NotificationModel> get unreadNotifications {
    return state.notifications.where((n) => !n.isRead).toList();
  }

  /// 獲取已讀通知
  List<NotificationModel> get readNotifications {
    return state.notifications.where((n) => n.isRead).toList();
  }
}

/// Provider 註冊
final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>(
      (ref) => NotificationNotifier(),
);