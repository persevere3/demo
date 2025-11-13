import 'package:flutter/material.dart';
import '../../core/architecture/app_module.dart';
import '../notification_module/listeners/notification_listener.dart';

class NotificationModule extends AppModule {
  @override
  String get name => 'Notification';

  @override
  Future<void> initialize() async {
    print('🔔 NotificationModule 初始化...');
    // 可以載入遠程通知設定、取得推播授權等
    await Future.delayed(const Duration(milliseconds: 100));
    print('✅ NotificationModule 初始化完成');
  }

  @override
  Widget? get globalListener => const NotificationModuleListener();

  @override
  Future<void> dispose() async {
    print('🧹 NotificationModule 清理...');
    await Future.delayed(const Duration(milliseconds: 50));
    print('✅ NotificationModule 清理完成');
  }
}