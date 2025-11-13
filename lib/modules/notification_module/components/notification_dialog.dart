import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notification_providers.dart';
import '../services/notification_service.dart';
import '../models/notification_model.dart';

class NotificationDialog extends ConsumerWidget {
  const NotificationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationProvider);
    final notificationService = ref.read(notificationServiceProvider);

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('通知中心 (${notificationState.unreadCount})'),
          if (notificationState.unreadCount > 0)
            TextButton(
              onPressed: () => notificationService.markAllAsRead(),
              child: const Text('全部已讀'),
            ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: notificationState.notifications.isEmpty
            ? const Center(child: Text('目前沒有通知'))
            : ListView.separated(
          itemCount: notificationState.notifications.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final notification = notificationState.notifications[index];
            return _NotificationTile(
              notification: notification,
              onTap: () {
                // 點擊時標記為已讀並顯示詳情
                if (!notification.isRead) {
                  notificationService.markAsRead(notification.id);
                }
                _showNotificationDetail(context, notification);
              },
              onDelete: () {
                notificationService.deleteNotification(notification.id);
              },
            );
          },
        ),
      ),
      actions: [
        if (notificationState.notifications.isNotEmpty)
          TextButton(
            onPressed: () => notificationService.clearNotifications(),
            child: const Text('清空全部'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('關閉'),
        ),
      ],
    );
  }

  void _showNotificationDetail(BuildContext context, NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(notification.content),
              // const SizedBox(height: 16),
              // Text(
              //   DateFormat('yyyy/MM/dd HH:mm').format(notification.createdAt),
              //   style: const TextStyle(fontSize: 12, color: Colors.grey),
              // ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('關閉'),
          ),
        ],
      ),
    );
  }
}

/// 通知項目 Widget
class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: Icon(
          notification.isRead ? Icons.mail_outline : Icons.mail,
          color: notification.isRead ? Colors.grey : Colors.blue,
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // const SizedBox(height: 4),
            // Text(
            //   _formatTime(notification.createdAt),
            //   style: const TextStyle(fontSize: 12, color: Colors.grey),
            // ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  // String _formatTime(DateTime dateTime) {
  //   final now = DateTime.now();
  //   final difference = now.difference(dateTime);
  //
  //   if (difference.inMinutes < 1) {
  //     return '剛剛';
  //   } else if (difference.inHours < 1) {
  //     return '${difference.inMinutes} 分鐘前';
  //   } else if (difference.inDays < 1) {
  //     return '${difference.inHours} 小時前';
  //   } else if (difference.inDays < 7) {
  //     return '${difference.inDays} 天前';
  //   } else {
  //     return DateFormat('MM/dd').format(dateTime);
  //   }
  // }
}
