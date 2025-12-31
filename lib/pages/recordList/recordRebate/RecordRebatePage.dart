import 'dart:async';
import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/RecordQueryButton.dart';
import '../../../components/StickyExpandableTable.dart';
import '../../../layout/DefaultLayout.dart';

import 'package:demo/providers/configProvider.dart';
import 'package:demo/providers/userProvider.dart';

class RecordRebatePage extends ConsumerStatefulWidget {
  const RecordRebatePage({super.key});
  @override
  ConsumerState<RecordRebatePage> createState() => _RecordRebatePageState();
}

class _RecordRebatePageState extends ConsumerState<RecordRebatePage> {
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
              title: '返水紀錄',
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

              extraBuilder: (BuildContext context, ValueNotifier extra) {
                return ValueListenableBuilder(
                    valueListenable: extra,
                    builder: (context, value, child) {
                      return Text('【返水记录会包含已领取过的前一日即时返水额度，若即时返水已经领取过则不会重复派发】', style: TextStyle(color: Colors.red));
                    }
                );
              },
            ),

            StickyExpandableTable(
              headerBackground: primaryColor,
              headerTextStyle: TextStyle(color: Colors.white),
              rowBackground: primaryColor.lighten(0.4),
              gridColor: Colors.white,

              columns: const [
                StickyTableColumn(title: '遊戲類別', flex: 1, align: TextAlign.left),
                StickyTableColumn(title: '發放時間', flex: 1, align: TextAlign.center),
                StickyTableColumn(title: '發放金額', flex: 1, align: TextAlign.center),
              ],
              rows: [
                StickyExpandableRow(
                  cells: const [
                    Text('CQ9/MT - 電子'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-07'),
                          Text('15:29:33'),
                        ]
                    ),
                    Text('0'),
                  ],
                  details: const [
                    DetailItem(title: '活動編號', value: 'CASHACTION288'),
                    DetailItem(title: '有效投注', value: '0.5'),
                    DetailItem(title: '總下注金額', value: '0.5'),
                    DetailItem(title: '下注筆數', value: '1'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('CQ9/MT - 電子'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-07'),
                          Text('15:29:33'),
                        ]
                    ),
                    Text('0'),
                  ],
                  details: const [
                    DetailItem(title: '活動編號', value: 'CASHACTION288'),
                    DetailItem(title: '有效投注', value: '0.5'),
                    DetailItem(title: '總下注金額', value: '0.5'),
                    DetailItem(title: '下注筆數', value: '1'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('CQ9/MT - 電子'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-07'),
                          Text('15:29:33'),
                        ]
                    ),
                    Text('0'),
                  ],
                  details: const [
                    DetailItem(title: '活動編號', value: 'CASHACTION288'),
                    DetailItem(title: '有效投注', value: '0.5'),
                    DetailItem(title: '總下注金額', value: '0.5'),
                    DetailItem(title: '下注筆數', value: '1'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('CQ9/MT - 電子'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-07'),
                          Text('15:29:33'),
                        ]
                    ),
                    Text('0'),
                  ],
                  details: const [
                    DetailItem(title: '活動編號', value: 'CASHACTION288'),
                    DetailItem(title: '有效投注', value: '0.5'),
                    DetailItem(title: '總下注金額', value: '0.5'),
                    DetailItem(title: '下注筆數', value: '1'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('CQ9/MT - 電子'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-07'),
                          Text('15:29:33'),
                        ]
                    ),
                    Text('0'),
                  ],
                  details: const [
                    DetailItem(title: '活動編號', value: 'CASHACTION288'),
                    DetailItem(title: '有效投注', value: '0.5'),
                    DetailItem(title: '總下注金額', value: '0.5'),
                    DetailItem(title: '下注筆數', value: '1'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('CQ9/MT - 電子'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-07'),
                          Text('15:29:33'),
                        ]
                    ),
                    Text('0'),
                  ],
                  details: const [
                    DetailItem(title: '活動編號', value: 'CASHACTION288'),
                    DetailItem(title: '有效投注', value: '0.5'),
                    DetailItem(title: '總下注金額', value: '0.5'),
                    DetailItem(title: '下注筆數', value: '1'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('CQ9/MT - 電子'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-07'),
                          Text('15:29:33'),
                        ]
                    ),
                    Text('0'),
                  ],
                  details: const [
                    DetailItem(title: '活動編號', value: 'CASHACTION288'),
                    DetailItem(title: '有效投注', value: '0.5'),
                    DetailItem(title: '總下注金額', value: '0.5'),
                    DetailItem(title: '下注筆數', value: '1'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('CQ9/MT - 電子'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-07'),
                          Text('15:29:33'),
                        ]
                    ),
                    Text('0'),
                  ],
                  details: const [
                    DetailItem(title: '活動編號', value: 'CASHACTION288'),
                    DetailItem(title: '有效投注', value: '0.5'),
                    DetailItem(title: '總下注金額', value: '0.5'),
                    DetailItem(title: '下注筆數', value: '1'),
                  ],
                ),
              ],
            ).p(20).flex()
          ],
        )
    );
  }
}