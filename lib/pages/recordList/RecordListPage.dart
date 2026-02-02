import 'dart:async';
import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../layout/DefaultLayout.dart';

import 'package:demo/providers/configProvider.dart';

import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';

class Item extends StatelessWidget {
  final String name;
  final IconData icon;
  final String routerName;

  const Item({
    required this.name,
    required this.icon,
    required this.routerName,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE8F0FE),
            ),
            child: Icon(icon, size: 28, color: Colors.blue).mb(6),
          ),
          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    ).flex(1);
  }
}

class RecordListPage extends ConsumerStatefulWidget {
  const RecordListPage({super.key});
  @override
  ConsumerState<RecordListPage> createState() => _RecordListPageState();
}

class _RecordListPageState extends ConsumerState<RecordListPage> {
  List<Map<String, dynamic>> recordList = [
    {
      "RecordName": "即時返水",
      "RecordIcon": Icons.card_giftcard,
      "RecordRouteName": "/recordRebateNow"
    },
    {
      "RecordName": "下注紀錄",
      "RecordIcon": Icons.money,
      "RecordRouteName": "/recordBets"
    },
    {
      "RecordName": "返水紀錄",
      "RecordIcon": Icons.card_giftcard,
      "RecordRouteName": "/recordRebate"
    },
    {
      "RecordName": "存取款紀錄",
      "RecordIcon": Icons.money,
      "RecordRouteName": "/recordDeposit"
    },
    {
      "RecordName": "轉帳紀錄",
      "RecordIcon": Icons.money,
      "RecordRouteName": "/recordTransfer"
    },
    {
      "RecordName": "我的存款優惠",
      "RecordIcon": Icons.money,
      "RecordRouteName": "/recordPromotion"
    },
    {
      "RecordName": "活動金流",
      "RecordIcon": Icons.card_giftcard,
      "RecordRouteName": "/recordActiveScash"
    },
  ];

  double rem(double v, {double rootFontSizePx = 16}) => v * rootFontSizePx;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    final r = BorderRadius.circular(12);

    return DefaultLayout(
      // title 可選，不傳則使用 config.appName
      title: '帳戶紀錄',
      child: ListView.builder(
        itemCount: recordList.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: r,
            child: InnerShadow(
              shadows: [
                Shadow(
                  color: const Color.fromRGBO(4, 0, 0, 0.35),
                  offset: Offset(0, rem(0.05333)),      // inset 0 .05333rem
                  blurRadius: rem(0.10667),             // blur .10667rem
                ),
              ],
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      recordList[index]['RecordRouteName'],
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80))
                  ),
                  child: Row(
                    children: [
                      Icon(
                          recordList[index]['RecordIcon'] ?? Icons.support_agent,
                          size: 40
                      ).mr(10),
                      Text(
                          recordList[index]['RecordName'],
                          style: TextStyle(fontSize: 16)
                      )
                    ],
                  ).ml(110)
              ).h(80).mb(20)
            ),
          );
        },
      ).px(50).py(30).bg('cfcfcf'.toColor())
    );
  }
}




