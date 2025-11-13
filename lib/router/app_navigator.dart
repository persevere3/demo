import 'package:flutter/material.dart';
import '../router/router.dart';

/// 應用導航器 - 處理主要的路由導航
class AppNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/',
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}