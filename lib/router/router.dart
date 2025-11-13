import 'package:flutter/material.dart';

import '../pages/home/HomePage.dart';
import '../pages/slotGameHall/SlotGameHallPage.dart';
import '../pages/user/UserPage.dart';
import '../pages/promotion/PromotionPage.dart';
import '../pages/customerService/CustomerServicePage.dart';
import '../pages/accountManagement/AccountManagementPage.dart';

class AppRouter {
  static final routes = <String, WidgetBuilder>{
    '/': (context) => HomePage(),
  };

  // 攔截
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // 可根據路由名稱或參數自定義攔截操作
    switch (settings.name) {
      case '/slotGameHall':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => SlotGameHallPage(id: args?['id']),
          settings: settings,
        );
      case '/user':
        return MaterialPageRoute(
          builder: (context) => UserPage(),
          settings: settings,
        );
      case '/promotion':
        return MaterialPageRoute(
          builder: (context) => PromotionPage(),
          settings: settings,
        );
      case '/customerService':
        return MaterialPageRoute(
          builder: (context) => CustomerServicePage(),
          settings: settings,
        );
      case '/accountManagement':
        return MaterialPageRoute(
          builder: (context) => AccountManagementPage(),
          settings: settings,
        );
      default:
        return null;
    }
  }
}