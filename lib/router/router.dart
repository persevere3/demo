import 'package:flutter/material.dart';

import '../pages/home/HomePage.dart';
import '../pages/slotGameHall/SlotGameHallPage.dart';
import '../pages/user/UserPage.dart';
import '../pages/promotion/PromotionPage.dart';
import '../pages/customerService/CustomerServicePage.dart';
import '../pages/accountManagement/AccountManagementPage.dart';

import '../pages/recordList/RecordListPage.dart';
import '../pages/recordList/recordRebateNow/RecordRebateNowPage.dart';
import '../pages/recordList/recordDeposit/RecordDepositPage.dart';
import '../pages/recordList/recordBets/RecordBetsPage.dart';
import '../pages/recordList/recordRebate/RecordRebatePage.dart';
import '../pages/recordList/recordTransfer/RecordTransferPage.dart';
import '../pages/recordList/recordPromotion/RecordPromotionPage.dart';
import '../pages/recordList/recordActiveScash/RecordActiveScashPage.dart';

import '../pages/pocketTransfer/PocketTransferPage.dart';

import '../pages/personalMessage/PersonalMessagePage.dart';

import '../pages/deposit/DepositPage.dart';

import '../pages/withdrawal/WithdrawalPage.dart';

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

      case '/recordList':
        return MaterialPageRoute(
          builder: (context) => RecordListPage(),
          settings: settings,
        );
      case '/recordRebateNow':
        return MaterialPageRoute(
          builder: (context) => RecordRebateNowPage(),
          settings: settings,
        );
      case '/recordDeposit':
        return MaterialPageRoute(
          builder: (context) => RecordDepositPage(),
          settings: settings,
        );
      case '/recordBets':
        return MaterialPageRoute(
          builder: (context) => RecordBetsPage(),
          settings: settings,
        );
      case '/recordRebate':
        return MaterialPageRoute(
          builder: (context) => RecordRebatePage(),
          settings: settings,
        );
      case '/recordTransfer':
        return MaterialPageRoute(
          builder: (context) => RecordTransferPage(),
          settings: settings,
        );
      case '/recordPromotion':
        return MaterialPageRoute(
          builder: (context) => RecordPromotionPage(),
          settings: settings,
        );
      case '/recordActiveScash':
        return MaterialPageRoute(
          builder: (context) => RecordActiveScashPage(),
          settings: settings,
        );

      case '/pocketTransfer':
        return MaterialPageRoute(
          builder: (context) => PocketTransferPage(),
          settings: settings,
        );

      case '/personalMessage':
        return MaterialPageRoute(
          builder: (context) => PersonalMessagePage(),
          settings: settings,
        );

      case '/deposit':
        return MaterialPageRoute(
          builder: (context) => DepositPage(),
          settings: settings,
        );
      case '/withdrawal':
        return MaterialPageRoute(
          builder: (context) => WithdrawalPage(),
          settings: settings,
        );
      default:
        return null;
    }
  }
}