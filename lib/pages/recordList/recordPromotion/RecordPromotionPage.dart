import 'dart:async';
import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/RecordQueryButton.dart';
import '../../../components/StickyExpandableTable.dart';
import '../../../layout/DefaultLayout.dart';

import 'package:demo/providers/configProvider.dart';
import 'package:demo/providers/userProvider.dart';

class RecordPromotionPage extends ConsumerStatefulWidget {
  const RecordPromotionPage({super.key});
  @override
  ConsumerState<RecordPromotionPage> createState() => _RecordPromotionPageState();
}

class _RecordPromotionPageState extends ConsumerState<RecordPromotionPage> {
  bool isShowSearchDialog = false;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    return DefaultLayout(
      // title 可選，不傳則使用 config.appName
        title: '帳戶紀錄',
        child: Column(
          children: [
            RecordQueryButton(
              title: '我的存款優惠',
              leadingIcon: Icons.account_balance,
              primaryColor: primaryColor,

              onQuery: (q) {
                debugPrint('================');
                debugPrint('start: ${q.start}');
                debugPrint('end: ${q.end}');
                debugPrint('================');

                // 调用 API
                // _fetchRecords(q);
              },
            ),

            StickyExpandableTable(
              headerBackground: primaryColor,
              headerTextStyle: TextStyle(color: Colors.white),
              rowBackground: primaryColor.lighten(0.4),
              gridColor: Colors.white,

              columns: const [
                StickyTableColumn(title: '交易碼', flex: 1, align: TextAlign.center),
                StickyTableColumn(title: '參加時間', flex: 1, align: TextAlign.center),
                StickyTableColumn(title: '入款金額', flex: 1, align: TextAlign.center),
              ],
              rows: []
            ).p(20).flex()
          ],
        )
    );
  }
}