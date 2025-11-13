import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/navigation_service.dart';
import '../providers/notification_providers.dart';
import '../services/notification_service.dart';

class NotificationModuleListener extends ConsumerStatefulWidget {
  const NotificationModuleListener({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationModuleListener> createState() => _NotificationModuleListenerState();
}

class _NotificationModuleListenerState extends ConsumerState<NotificationModuleListener> {
  @override
  Widget build(BuildContext context) {
    ref.listen<NotificationState>(notificationProvider, (previous, current) {
      // 偵測有新通知加入
      if ((previous?.notifications.length ?? 0) < current.notifications.length) {
        final newNotification = current.notifications.first;
        _showNewNotificationSnackBar(newNotification.title, newNotification.content);
      }
    });

    return const SizedBox.shrink();
  }

  void _showNewNotificationSnackBar(String title, String content) {
    final context = NavigationService.currentContext;
    if (context == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: '查看',
          onPressed: () {
            // 可以打開通知彈窗
            ref.read(notificationServiceProvider).showNotificationDialog();
          },
        ),
      ),
    );
  }
}