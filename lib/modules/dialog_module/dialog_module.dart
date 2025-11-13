import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/architecture/app_module.dart';
import 'providers/dialog_providers.dart';
import 'services/dialog_service.dart';
import 'listeners/dialog_module_listener.dart';

/// Dialog 功能模組
class DialogModule extends AppModule {
  @override
  String get name => 'Dialog';

  @override
  List<Type> get dependencies => []; // Dialog 模組不依賴其他模組

  @override
  Future<void> initialize() async {
    print('🎯 DialogModule: 開始初始化');

    // 這裡可以做一些初始化工作，比如：
    // - 載入 Dialog 相關的配置
    // - 初始化 Dialog 樣式
    // - 設置默認參數

    print('✅ DialogModule: 初始化完成');
  }

  @override
  List<Override> get providerOverrides => [
    // 如果需要覆寫 Provider，在這裡添加
    // 例如：測試環境使用 Mock 實作
  ];

  @override
  Widget? get globalListener => const DialogModuleListener();

  @override
  Map<String, WidgetBuilder> get routes => {
    // 如果 Dialog 模組有專門的路由頁面，在這裡添加
  };

  @override
  Future<void> dispose() async {
    print('🧹 DialogModule: 開始清理');

    // 清理模組資源
    // 例如：關閉所有開啟的 Dialog、清理緩存等

    print('✅ DialogModule: 清理完成');
  }
}