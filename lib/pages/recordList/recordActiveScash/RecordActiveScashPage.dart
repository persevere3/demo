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
  String? type;        // 活動类型

  TransactionQueryExtra({
    this.type,
  });

  TransactionQueryExtra copyWith({
    String? type,
  }) {
    return TransactionQueryExtra(
        type: type ?? this.type,
    );
  }
}

class RecordActiveScashPage extends ConsumerStatefulWidget {
  const RecordActiveScashPage({super.key});
  @override
  ConsumerState<RecordActiveScashPage> createState() => _RecordActiveScashPageState();
}

class _RecordActiveScashPageState extends ConsumerState<RecordActiveScashPage> {
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
              title: '活動金流',
              leadingIcon: Icons.account_balance,
              primaryColor: primaryColor,

              onQuery: (q) {
                debugPrint('================');
                debugPrint('start: ${q.start}');
                debugPrint('end: ${q.end}');
                debugPrint('活動類型: ${q.extra?.type}');
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
                            const Text('活動類型：'),
                            DropdownButton<String>(
                              value: value?.type,
                              hint: const Text('全部'),
                              items: const [
                                DropdownMenuItem(value: '全部', child: Text('全部')),
                                DropdownMenuItem(value: '輪盤活動', child: Text('輪盤活動')),
                                DropdownMenuItem(value: '得意紅包', child: Text('得意紅包')),
                                DropdownMenuItem(value: '每日簽到', child: Text('每日簽到')),
                              ],
                              onChanged: (v) {
                                extra.value = (value ?? TransactionQueryExtra()).copyWith(type: v);
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
                StickyTableColumn(title: '活動類型', flex: 1, align: TextAlign.center),
                StickyTableColumn(title: '派發時間', flex: 1, align: TextAlign.center),
                StickyTableColumn(title: '派發金額', flex: 1, align: TextAlign.center),
                StickyTableColumn(title: '流水倍數', flex: 1, align: TextAlign.center),
                StickyTableColumn(title: '備註', flex: 1, align: TextAlign.center),
              ],
              rows: [],
            ).p(20).flex()
          ],
        )
    );
  }
}