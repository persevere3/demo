import 'dart:async';
import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/RecordQueryButton.dart';
import '../../../components/StickyExpandableTable.dart';
import '../../../layout/DefaultLayout.dart';

import 'package:demo/providers/configProvider.dart';

// 定义查询参数类
class TransactionQueryExtra {
  String? type;        // 錢包类型
  String? status;      // 交易状态

  TransactionQueryExtra({
    this.type,
    this.status,
  });

  TransactionQueryExtra copyWith({
    String? type,
    String? status,
  }) {
    return TransactionQueryExtra(
        type: type ?? this.type,
        status: status ?? this.status
    );
  }
}

class RecordTransferPage extends ConsumerStatefulWidget {
  const RecordTransferPage({super.key});
  @override
  ConsumerState<RecordTransferPage> createState() => _RecordTransferPageState();
}

class _RecordTransferPageState extends ConsumerState<RecordTransferPage> {
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
              title: '轉帳紀錄',
              leadingIcon: Icons.account_balance,
              primaryColor: primaryColor,

              onQuery: (q) {
                debugPrint('================');
                debugPrint('start: ${q.start}');
                debugPrint('end: ${q.end}');
                debugPrint('錢包类型: ${q.extra?.type}');
                debugPrint('交易状态: ${q.extra?.status}');
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
                            const Text('錢包類型：'),
                            DropdownButton<String>(
                              value: value?.type,
                              hint: const Text('全部'),
                              items: const [
                                DropdownMenuItem(value: '全部', child: Text('全部')),
                                DropdownMenuItem(value: 'BB娛樂城', child: Text('BB娛樂城')),
                                DropdownMenuItem(value: 'PG電子', child: Text('PG電子')),
                              ],
                              onChanged: (v) {
                                extra.value = (value ?? TransactionQueryExtra()).copyWith(type: v);
                              },
                            ),
                          ]),
                          Row(children: [
                            const Text('交易狀態：'),
                            DropdownButton<String>(
                              value: value?.status,
                              hint: const Text('全部'),
                              items: const [
                                DropdownMenuItem(value: '全部', child: Text('全部')),
                                DropdownMenuItem(value: '成功', child: Text('成功')),
                                DropdownMenuItem(value: '失敗', child: Text('失敗')),
                                DropdownMenuItem(value: '處理中', child: Text('處理中')),
                              ],
                              onChanged: (v) {
                                extra.value = (value ?? TransactionQueryExtra()).copyWith(status: v);
                              },
                            ),
                          ]),
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
                StickyTableColumn(title: '交易碼', flex: 1, align: TextAlign.left),
                StickyTableColumn(title: '交易時間', flex: 1, align: TextAlign.center),
                StickyTableColumn(title: '轉帳金額', flex: 1, align: TextAlign.center),
                StickyTableColumn(title: '交易狀態', flex: 1, align: TextAlign.center),
              ],
              rows: [
                StickyExpandableRow(
                  cells: const [
                    Text('283476241'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-29'),
                          Text('11:07:47'),
                        ]
                    ),
                    Text('41'),
                    Text('成功', style: TextStyle(color: Colors.green)),
                  ],
                  details: const [
                    DetailItem(title: '轉出錢包', value: 'PG電子'),
                    DetailItem(title: '轉入錢包', value: '我的錢包'),
                    DetailItem(title: '編號', value: '283476241'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('283476241'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-29'),
                          Text('11:07:47'),
                        ]
                    ),
                    Text('41'),
                    Text('成功', style: TextStyle(color: Colors.green)),
                  ],
                  details: const [
                    DetailItem(title: '轉出錢包', value: 'PG電子'),
                    DetailItem(title: '轉入錢包', value: '我的錢包'),
                    DetailItem(title: '編號', value: '283476241'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('283476241'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-29'),
                          Text('11:07:47'),
                        ]
                    ),
                    Text('41'),
                    Text('成功', style: TextStyle(color: Colors.green)),
                  ],
                  details: const [
                    DetailItem(title: '轉出錢包', value: 'PG電子'),
                    DetailItem(title: '轉入錢包', value: '我的錢包'),
                    DetailItem(title: '編號', value: '283476241'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('283476241'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-29'),
                          Text('11:07:47'),
                        ]
                    ),
                    Text('41'),
                    Text('成功', style: TextStyle(color: Colors.green)),
                  ],
                  details: const [
                    DetailItem(title: '轉出錢包', value: 'PG電子'),
                    DetailItem(title: '轉入錢包', value: '我的錢包'),
                    DetailItem(title: '編號', value: '283476241'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('283476241'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-29'),
                          Text('11:07:47'),
                        ]
                    ),
                    Text('41'),
                    Text('成功', style: TextStyle(color: Colors.green)),
                  ],
                  details: const [
                    DetailItem(title: '轉出錢包', value: 'PG電子'),
                    DetailItem(title: '轉入錢包', value: '我的錢包'),
                    DetailItem(title: '編號', value: '283476241'),
                  ],
                ),

              ],
            ).p(20).flex()
          ],
        )
    );
  }
}