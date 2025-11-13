import 'package:flutter/material.dart';

/// 導航服務 - 提供全局導航功能
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// 獲取當前 Context
  static BuildContext? get currentContext => navigatorKey.currentContext;

  /// 頁面跳轉
  static Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed<T>(routeName, arguments: arguments);
  }

  /// 返回上一頁
  static void pop<T>([T? result]) {
    if (navigatorKey.currentState?.canPop() == true) {
      navigatorKey.currentState!.pop<T>(result);
    }
  }

  /// 替換當前頁面
  static Future<T?> pushReplacementNamed<T, TO>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed<T, TO>(routeName, arguments: arguments);
  }
}