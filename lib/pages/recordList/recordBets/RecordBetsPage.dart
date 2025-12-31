import 'dart:async';
import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/RecordQueryButton.dart';
import '../../../components/StickyExpandableTable.dart';
import '../../../layout/DefaultLayout.dart';

import 'package:demo/providers/configProvider.dart';
import 'package:demo/providers/userProvider.dart';

// 定义查询参数类
class TransactionQueryExtra {
  String? gameType;     // 遊戲类型
  String? productType;  // 產品類型
  String? status;       // 派彩狀況

  TransactionQueryExtra({
    this.gameType,
    this.productType,
    this.status,
  });

  TransactionQueryExtra copyWith({
    String? gameType,
    String? productType,
    String? status,
  }) {
    return TransactionQueryExtra(
        gameType: gameType ?? this.gameType,
        productType: productType ?? this.productType,
        status: status ?? this.status
    );
  }
}

class RecordBetsPage extends ConsumerStatefulWidget {
  const RecordBetsPage({super.key});
  @override
  ConsumerState<RecordBetsPage> createState() => _RecordBetsPageState();
}

class _RecordBetsPageState extends ConsumerState<RecordBetsPage> {
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
            RecordQueryButton<TransactionQueryExtra>(
              title: '下注紀錄',
              leadingIcon: Icons.account_balance,
              primaryColor: primaryColor,

              onQuery: (q) {
                debugPrint('================');
                debugPrint('start: ${q.start}');
                debugPrint('end: ${q.end}');
                debugPrint('遊戲类型: ${q.extra?.gameType}');
                debugPrint('產品方式: ${q.extra?.productType}');
                debugPrint('派彩状态: ${q.extra?.status}');
                debugPrint('================');

                // 调用 API
                // _fetchRecords(q);
              },

              extraBuilder: (BuildContext context, ValueNotifier<TransactionQueryExtra?> extra) {
                return ValueListenableBuilder<TransactionQueryExtra?>(
                    valueListenable: extra,
                    builder: (context, value, child) {
                      return Column(
                        children: [
                          Row(children: [
                            const Text('遊戲類型：'),
                            DropdownButton<String>(
                              value: value?.gameType,
                              hint: const Text('全部'),
                              items: const [
                                DropdownMenuItem(value: '全部', child: Text('全部')),
                                DropdownMenuItem(value: 'BB娛樂城', child: Text('BB娛樂城')),
                                DropdownMenuItem(value: 'PG電子', child: Text('PG電子')),
                              ],
                              onChanged: (v) {
                                extra.value = (value ?? TransactionQueryExtra()).copyWith(gameType: v);
                              },
                            ),
                          ]),
                          Row(children: [
                            const Text('產品類型：'),
                            DropdownButton<String>(
                              value: value?.productType,
                              hint: const Text('全部'),
                              items: const [
                                DropdownMenuItem(value: '全部', child: Text('全部')),
                                DropdownMenuItem(value: '真人', child: Text('真人')),
                                DropdownMenuItem(value: '電子', child: Text('電子')),
                              ],
                              onChanged: (v) {
                                extra.value = (value ?? TransactionQueryExtra()).copyWith(productType: v);
                              },
                            ),
                          ]),
                          Row(children: [
                            const Text('派彩狀況：'),
                            DropdownButton<String>(
                              value: value?.status,
                              hint: const Text('全部'),
                              items: const [
                                DropdownMenuItem(value: '全部', child: Text('全部')),
                                DropdownMenuItem(value: '已派彩', child: Text('已派彩')),
                              ],
                              onChanged: (v) {
                                extra.value = (value ?? TransactionQueryExtra()).copyWith(status: v);
                              },
                            ),
                          ])
                        ],
                      );
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
                StickyTableColumn(title: '類別', flex: 1, align: TextAlign.center),
                StickyTableColumn(title: '下注筆數', flex: 1, align: TextAlign.center),
                StickyTableColumn(title: '總注額', flex: 1, align: TextAlign.center),
                StickyTableColumn(title: '派彩', flex: 1, align: TextAlign.center),
                StickyTableColumn(title: '未計算量', flex: 1, align: TextAlign.center),
                StickyTableColumn(title: '有效投注', flex: 1, align: TextAlign.center),
              ],
              rows: [

              ],
            ).p(20).flex()
          ],
        )
    );
  }
}