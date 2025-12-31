import 'dart:async';
import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/RecordQueryButton.dart';
import '../../../components/StickyExpandableTable.dart';
import '../../../layout/DefaultLayout.dart';

import 'package:demo/providers/configProvider.dart';
import 'package:demo/providers/userProvider.dart';


class RecordRebateNowPage extends ConsumerStatefulWidget {
  const RecordRebateNowPage({super.key});
  @override
  ConsumerState<RecordRebateNowPage> createState() => _RecordRebateNowPageState();
}

class _RecordRebateNowPageState extends ConsumerState<RecordRebateNowPage> {
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
              title: '即時返水',
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
                      return Container(
                        height: 200,
                        child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('会员即时返水注意事项:').mb(5),
                                Text('1. 产品游戏时间区分，如日期选择1/1则表示:'),
                                Text('   美东时间:1/1 12:00～1/2 12:00(UTC+8)', style: TextStyle(color: Colors.red)),
                                Text('   北京时间:1/1 00:00～1/2 00:00(UTC+8)', style: TextStyle(color: Colors.red)),
                                Text('   英伦时间:1/1 08:00～1/2 08:00(UTC+8)', style: TextStyle(color: Colors.red)).mb(5),
                                Text('2. 建议完成投注10分钟后再提交返水。').mb(5),
                                Text('3. 00:00～12:00下注北京时间游戏或08:00～12:00下注英伦时间游戏，请于12:00后再提交返水 ; 若下注美东时间游戏，请于12点前提交返水。').mb(5),
                                Text('4. 若每日提交返水后至游戏对应时间(如美东隔日12点)结束前还有进行游戏，则需配合网站当日返水时间获得返水。')
                              ],
                            )
                        )
                      );
                    }
                ).mt(10);
              },

              extraButtonBuilder: (BuildContext context) {
                return FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    print('提交');
                  },
                  child: const Text('提交'),
                ).ml(5);
              },
            ),

            StickyExpandableTable(
              headerBackground: primaryColor,
              headerTextStyle: TextStyle(color: Colors.white),
              rowBackground: primaryColor.lighten(0.4),
              gridColor: Colors.white,


              columns: const [
                StickyTableColumn(title: '遊戲名稱', flex: 1, align: TextAlign.center),
                StickyTableColumn(title: '返水日期', flex: 1, align: TextAlign.center),
                StickyTableColumn(title: '返水金額', flex: 1, align: TextAlign.center),
              ],
              rows: [

              ],
            ).p(20).flex()
          ],
        )
    );
  }
}