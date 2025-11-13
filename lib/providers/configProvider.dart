import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/config/app_config.dart';

// 定義 Provider 傳遞全局 AppConfig
final configProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError(); // 預設實作，用於測試時提示
});