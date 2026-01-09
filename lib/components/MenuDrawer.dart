import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/providers/configProvider.dart';

class MenuDrawer extends ConsumerWidget {
  final List<Map<String, dynamic>> drawerItems = [
    {'title': '會員中心', 'icon': Icons.login, 'routerName': '/user'},
    {'title': '優惠活動', 'icon': Icons.card_giftcard, 'routerName': '/promotion'},
    {'title': '線上客服', 'icon': Icons.contact_support, 'routerName': '/customerService'},
    {'title': '帳戶管理', 'icon': Icons.manage_accounts, 'routerName': '/accountManagement'},
    {'title': '帳戶紀錄', 'icon': Icons.list_alt_rounded, 'routerName': '/recordList'},
    {'title': '我的錢包', 'icon': Icons.account_balance_wallet, 'routerName': '/pocketTransfer'},
    {'title': '個人信息', 'icon': Icons.message, 'routerName': '/personalMessage'},
    {'title': '快速充值', 'icon': Icons.account_balance, 'routerName': '/deposit'},

    {'title': '搜尋', 'icon': Icons.home},
    {'title': '網站APP下載', 'icon': Icons.settings},
    {'title': '快速充值', 'icon': Icons.info},
    {'title': '免息借', 'icon': Icons.logout},
    {'title': '交易帳號', 'icon': Icons.home},
    {'title': '及時返水', 'icon': Icons.settings},
    {'title': '電子升級', 'icon': Icons.info},
    {'title': '真人升級', 'icon': Icons.logout},
    {'title': '代理加盟', 'icon': Icons.home},
    {'title': '幸運大轉盤', 'icon': Icons.settings},
    {'title': '幸運盲盒', 'icon': Icons.info},
    {'title': '砸金蛋', 'icon': Icons.logout},
    {'title': '爭霸賽', 'icon': Icons.home},
    {'title': '得意紅包', 'icon': Icons.settings},
    {'title': '優惠活動', 'icon': Icons.info}
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    final mediaQuery = MediaQuery.of(context);
    final bottomNavBarHeight = 56;
    final drawerHeight =
    (mediaQuery.size.height -
        mediaQuery.padding.top -
        kToolbarHeight -
        bottomNavBarHeight - // 自訂高度
        mediaQuery.padding.bottom);
    final drawerTop = mediaQuery.padding.top + kToolbarHeight;

    return Drawer(
        backgroundColor: primaryColor.lighten(0.05),
      child: ListView(
        children: drawerItems.map((item) {
          return Column(children: [
            ListTile(
              leading: Icon(item["icon"], color: Colors.white),
              title: Text(item["title"], style: TextStyle(color: Colors.white)),
              onTap: () {
                // 點擊處理
                Navigator.pushNamed(
                  context,
                  item["routerName"],
                );
              },
            ),
            Divider(height: 1, color: Colors.white).px(15)
          ]);
        }).toList(),
      ).pb(30),
    ).h(drawerHeight);
  }
}