// lib/components/BottomNav.dart
import 'package:demo/extensions/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/providers/configProvider.dart';

// ✅ 使用服務 provider
import '../modules/dialog_module/services/dialog_service.dart';
import '../modules/notification_module/services/notification_service.dart';
// import '../modules/error_module/models/error_model.dart';
import '../modules/error_module/services/error_service.dart';

class BottomNav extends ConsumerStatefulWidget {
  @override
  ConsumerState<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNav> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> bottomNavItems = [
    {'label': '立即登入', 'icon': Icons.login},
    {'label': '免費試玩', 'icon': Icons.videogame_asset},
    {'label': '首頁', 'icon': Icons.home},
    {'label': '優惠活動', 'icon': Icons.local_offer},
    {'label': '線上客服', 'icon': Icons.support_agent},
  ];

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    _currentIndex = _getIndexFromRoute(currentRoute);

    final dialogService = ref.read(dialogServiceProvider); // 取得服務
    final notificationService = ref.read(notificationServiceProvider); // 取得服務
    final errorService = ref.read(errorServiceProvider); // 取得服務

    return BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor.darken(0.1),
      unselectedItemColor: Colors.black54,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });

        switch (index) {
          case 0: // 登入
            dialogService.showLoginDialog();
            break;
          case 1: // 遊戲
            Navigator.pushNamed(
              context,
              '/slotGameHall',
              arguments: {'id': 11111},
            );
            break;
          case 2: // 首頁
            Navigator.pushNamed(context, '/');
            break;
          case 3: // 客服
            notificationService.pushNotification(
              '系統通知',
              '您有一筆新訂單待處理，請盡快確認。',
            );
            notificationService.showNotificationDialog();
            break;
          case 4: // 客服
            // dialogService.showCustomerServiceDialog();

            // errorService.logError(
            //   type: ErrorType.network,
            //   severity: ErrorSeverity.error,
            //   title: '網路連線失敗',
            //   message: '無法連接到伺服器，請檢查網路設定',
            //   details: 'API: /api/users, Code: TIMEOUT',
            // );

            try {
              throw Exception('測試異常');
            } catch (e, stack) {
              errorService.logException(e, stack);
            }

            errorService.showErrorDialog();

            break;
        }
      },
      items: bottomNavItems.map((item) {
        return BottomNavigationBarItem(
          icon: Icon(item['icon']),
          label: item['label'],
        );
      }).toList(),
    );
  }

  int _getIndexFromRoute(String route) {
    switch (route) {
      case '/':
        return 2;
      case '/slotGameHall':
        return 1;
      default:
        return 0;
    }
  }
}