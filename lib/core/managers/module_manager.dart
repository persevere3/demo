import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../architecture/app_module.dart';

/// 模組管理器 - 負責所有模組的生命週期管理
class ModuleManager {
  static final List<AppModule> _modules = [];
  static final Map<Type, AppModule> _moduleMap = {};
  static bool _initialized = false;

  /// 註冊模組 - 應用啟動時調用
  static void registerModule(AppModule module) {
    if (_initialized) {
      throw StateError('Cannot register modules after initialization');
    }

    _modules.add(module);
    _moduleMap[module.runtimeType] = module;
    print('📦 已註冊模組: ${module.name}');
  }

  /// 初始化所有模組 - 按依賴順序初始化
  static Future<void> initializeModules() async {
    if (_initialized) return;

    print('🚀 開始初始化模組...');

    // 按依賴關係排序模組
    final sortedModules = _topologicalSort(_modules);

    // 依序初始化每個模組
    for (final module in sortedModules) {
      print('⚡ 初始化模組: ${module.name}');
      await module.initialize();
    }

    _initialized = true;
    print('✅ 所有模組初始化完成');
  }

  /// 獲取所有全局監聽器
  static List<Widget> get globalListeners {
    return _modules
        .map((module) => module.globalListener)
        .where((listener) => listener != null)
        .cast<Widget>()
        .toList();
  }

  /// 獲取所有 Provider 覆寫
  static List<Override> get providerOverrides {
    return _modules.expand((module) => module.providerOverrides).toList();
  }

  /// 獲取所有路由
  static Map<String, WidgetBuilder> get routes {
    final Map<String, WidgetBuilder> allRoutes = {};
    for (final module in _modules) {
      allRoutes.addAll(module.routes);
    }
    return allRoutes;
  }

  /// 拓撲排序 - 根據依賴關係排序模組初始化順序
  static List<AppModule> _topologicalSort(List<AppModule> modules) {
    final Map<Type, AppModule> moduleMap = {
      for (var module in modules) module.runtimeType: module
    };

    final List<AppModule> sorted = [];
    final Set<Type> visited = {};
    final Set<Type> visiting = {};

    void visit(Type moduleType) {
      if (visited.contains(moduleType)) return;
      if (visiting.contains(moduleType)) {
        throw StateError('循環依賴檢測: $moduleType');
      }

      visiting.add(moduleType);

      final module = moduleMap[moduleType];
      if (module != null) {
        // 先初始化依賴的模組
        for (final depType in module.dependencies) {
          if (moduleMap.containsKey(depType)) {
            visit(depType);
          }
        }

        if (!visited.contains(moduleType)) {
          sorted.add(module);
          visited.add(moduleType);
        }
      }

      visiting.remove(moduleType);
    }

    for (final module in modules) {
      visit(module.runtimeType);
    }

    return sorted;
  }

  /// 清理所有模組
  static Future<void> disposeModules() async {
    print('🧹 開始清理模組...');

    // 按相反順序清理
    for (final module in _modules.reversed) {
      print('🗑️ 清理模組: ${module.name}');
      await module.dispose();
    }

    _modules.clear();
    _moduleMap.clear();
    _initialized = false;
    print('✅ 所有模組已清理');
  }
}