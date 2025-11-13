import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../core/architecture/app_module.dart';
import 'listeners/error_module_listener.dart';

class ErrorModule extends AppModule {
  @override
  String get name => 'Error';

  @override
  List<Type> get dependencies => [];

  @override
  Future<void> initialize() async {
    print('⚠️ ErrorModule 初始化...');

    // 設置全局錯誤捕獲
    FlutterError.onError = (FlutterErrorDetails details) {
      print('❌ Flutter Error: ${details.exception}');
      // 可以在這裡調用 errorService.logException()
    };

    // 捕獲非 Flutter 錯誤
    PlatformDispatcher.instance.onError = (error, stack) {
      print('❌ Platform Error: $error');
      return true;
    };

    await Future.delayed(const Duration(milliseconds: 100));
    print('✅ ErrorModule 初始化完成');
  }

  @override
  Widget? get globalListener => const ErrorModuleListener();

  @override
  Future<void> dispose() async {
    print('🧹 ErrorModule 清理...');
  }
}