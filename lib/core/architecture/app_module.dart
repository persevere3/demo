import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 應用模組基類 - 定義所有模組必須實現的接口
abstract class AppModule {
  /// 模組名稱 - 用於調試和日誌
  String get name;

  /// 依賴的其他模組類型 - 確保初始化順序正確
  List<Type> get dependencies => [];

  /// 模組初始化 - 在應用啟動時調用
  Future<void> initialize();

  /// 模組清理 - 在應用關閉時調用
  Future<void> dispose();

  /// 提供給其他模組使用的 Riverpod Providers
  List<Override> get providerOverrides => [];

  /// 全局監聽器 Widget - 處理該模組的全局狀態變化
  Widget? get globalListener;

  /// 該模組提供的路由
  Map<String, WidgetBuilder> get routes => {};
}