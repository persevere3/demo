import 'dart:async';
import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/RecordQueryButton.dart';
import '../../../components/StickyExpandableTable.dart';
import '../../../layout/DefaultLayout.dart';

import 'package:demo/providers/configProvider.dart';
import 'package:demo/providers/userProvider.dart';

// class Item extends StatelessWidget {
//   final String name;
//   final IconData icon;
//   final String routerName;
//
//   const Item({
//     required this.name,
//     required this.icon,
//     required this.routerName,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {},
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: Color(0xFFE8F0FE),
//             ),
//             child: Icon(icon, size: 28, color: Colors.blue).mb(6),
//           ),
//           Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
//         ],
//       ),
//     ).flex(1);
//   }
// }

// 定义查询参数类
class TransactionQueryExtra {
  String? type;        // 交易类型
  String? method;      // 交易方式
  String? status;      // 交易状态

  TransactionQueryExtra({
    this.type,
    this.method,
    this.status,
  });

  TransactionQueryExtra copyWith({
    String? type,
    String? method,
    String? status,
  }) {
    return TransactionQueryExtra(
      type: type ?? this.type,
      method: method ?? this.method,
      status: status ?? this.status
    );
  }
}

class RecordDepositPage extends ConsumerStatefulWidget {
  const RecordDepositPage({super.key});
  @override
  ConsumerState<RecordDepositPage> createState() => _RecordDepositPageState();
}

class _RecordDepositPageState extends ConsumerState<RecordDepositPage> {
  bool isShowSearchDialog = false;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    return DefaultLayout(
      // title 可選，不傳則使用 config.appName
        title: '存取款紀錄',
        child: Column(
          children: [
            RecordQueryButton<TransactionQueryExtra>(
              title: '存取款紀錄',
              leadingIcon: Icons.account_balance,
              primaryColor: primaryColor,

              onQuery: (q) {
                debugPrint('================');
                debugPrint('start: ${q.start}');
                debugPrint('end: ${q.end}');
                debugPrint('交易类型: ${q.extra?.type}');
                debugPrint('交易方式: ${q.extra?.method}');
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
                          const Text('交易類型：'),
                          DropdownButton<String>(
                            value: value?.type,
                            hint: const Text('全部'),
                            items: const [
                              DropdownMenuItem(value: '存款', child: Text('存款')),
                              DropdownMenuItem(value: '提款', child: Text('提款')),
                            ],
                            onChanged: (v) {
                              extra.value = (value ?? TransactionQueryExtra()).copyWith(type: v);
                            },
                          ),
                        ]),
                        Row(children: [
                          const Text('交易方式：'),
                          DropdownButton<String>(
                            value: value?.method,
                            hint: const Text('全部'),
                            items: const [
                              DropdownMenuItem(value: '線上', child: Text('線上')),
                              DropdownMenuItem(value: '線下', child: Text('線下')),
                            ],
                            onChanged: (v) {
                              extra.value = (value ?? TransactionQueryExtra()).copyWith(method: v);
                            },
                          ),
                        ]),
                        Row(children: [
                          const Text('交易狀態：'),
                          DropdownButton<String>(
                            value: value?.status,
                            hint: const Text('全部'),
                            items: const [
                              DropdownMenuItem(value: '交易終止', child: Text('交易終止')),
                              DropdownMenuItem(value: '交易處理中', child: Text('交易處理中')),
                              DropdownMenuItem(value: '審核中', child: Text('審核中')),
                              DropdownMenuItem(value: '交易成功', child: Text('交易成功')),
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
                StickyTableColumn(title: '事項', flex: 1, align: TextAlign.left),
                StickyTableColumn(title: '交易時間', flex: 2, align: TextAlign.center),
                StickyTableColumn(title: '提交金額', flex: 1, align: TextAlign.center),
                StickyTableColumn(title: '交易狀態', flex: 1, align: TextAlign.center),
              ],
              rows: [
                StickyExpandableRow(
                  cells: const [
                    Text('存款'),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('2025-12-20'),
                        Text('19:11:37'),
                      ]
                    ),
                    Text('1'),
                    Text('交易終止', style: TextStyle(color: Colors.red)),
                  ],
                  details: const [
                    DetailItem(title: '原始金額', value: '429.96'),
                    DetailItem(title: '目前金額', value: '429.96'),
                    DetailItem(title: '存款優惠', value: '0'),
                    DetailItem(title: '行政費用', value: '0'),
                    DetailItem(title: '手續費', value: '0'),
                    DetailItem(title: '到帳金額', value: '0'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('存款'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-20'),
                          Text('19:11:37'),
                        ]
                    ),
                    Text('1'),
                    Text('交易終止', style: TextStyle(color: Colors.red)),
                  ],
                  details: const [
                    DetailItem(title: '原始金額', value: '429.96'),
                    DetailItem(title: '目前金額', value: '429.96'),
                    DetailItem(title: '存款優惠', value: '0'),
                    DetailItem(title: '行政費用', value: '0'),
                    DetailItem(title: '手續費', value: '0'),
                    DetailItem(title: '到帳金額', value: '0'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('存款'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-20'),
                          Text('19:11:37'),
                        ]
                    ),
                    Text('1'),
                    Text('交易終止', style: TextStyle(color: Colors.red)),
                  ],
                  details: const [
                    DetailItem(title: '原始金額', value: '429.96'),
                    DetailItem(title: '目前金額', value: '429.96'),
                    DetailItem(title: '存款優惠', value: '0'),
                    DetailItem(title: '行政費用', value: '0'),
                    DetailItem(title: '手續費', value: '0'),
                    DetailItem(title: '到帳金額', value: '0'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('存款'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-20'),
                          Text('19:11:37'),
                        ]
                    ),
                    Text('1'),
                    Text('交易終止', style: TextStyle(color: Colors.red)),
                  ],
                  details: const [
                    DetailItem(title: '原始金額', value: '429.96'),
                    DetailItem(title: '目前金額', value: '429.96'),
                    DetailItem(title: '存款優惠', value: '0'),
                    DetailItem(title: '行政費用', value: '0'),
                    DetailItem(title: '手續費', value: '0'),
                    DetailItem(title: '到帳金額', value: '0'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('存款'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-20'),
                          Text('19:11:37'),
                        ]
                    ),
                    Text('1'),
                    Text('交易終止', style: TextStyle(color: Colors.red)),
                  ],
                  details: const [
                    DetailItem(title: '原始金額', value: '429.96'),
                    DetailItem(title: '目前金額', value: '429.96'),
                    DetailItem(title: '存款優惠', value: '0'),
                    DetailItem(title: '行政費用', value: '0'),
                    DetailItem(title: '手續費', value: '0'),
                    DetailItem(title: '到帳金額', value: '0'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('存款'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-20'),
                          Text('19:11:37'),
                        ]
                    ),
                    Text('1'),
                    Text('交易終止', style: TextStyle(color: Colors.red)),
                  ],
                  details: const [
                    DetailItem(title: '原始金額', value: '429.96'),
                    DetailItem(title: '目前金額', value: '429.96'),
                    DetailItem(title: '存款優惠', value: '0'),
                    DetailItem(title: '行政費用', value: '0'),
                    DetailItem(title: '手續費', value: '0'),
                    DetailItem(title: '到帳金額', value: '0'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('存款'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-20'),
                          Text('19:11:37'),
                        ]
                    ),
                    Text('1'),
                    Text('交易終止', style: TextStyle(color: Colors.red)),
                  ],
                  details: const [
                    DetailItem(title: '原始金額', value: '429.96'),
                    DetailItem(title: '目前金額', value: '429.96'),
                    DetailItem(title: '存款優惠', value: '0'),
                    DetailItem(title: '行政費用', value: '0'),
                    DetailItem(title: '手續費', value: '0'),
                    DetailItem(title: '到帳金額', value: '0'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('存款'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-20'),
                          Text('19:11:37'),
                        ]
                    ),
                    Text('1'),
                    Text('交易終止', style: TextStyle(color: Colors.red)),
                  ],
                  details: const [
                    DetailItem(title: '原始金額', value: '429.96'),
                    DetailItem(title: '目前金額', value: '429.96'),
                    DetailItem(title: '存款優惠', value: '0'),
                    DetailItem(title: '行政費用', value: '0'),
                    DetailItem(title: '手續費', value: '0'),
                    DetailItem(title: '到帳金額', value: '0'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('存款'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-20'),
                          Text('19:11:37'),
                        ]
                    ),
                    Text('1'),
                    Text('交易終止', style: TextStyle(color: Colors.red)),
                  ],
                  details: const [
                    DetailItem(title: '原始金額', value: '429.96'),
                    DetailItem(title: '目前金額', value: '429.96'),
                    DetailItem(title: '存款優惠', value: '0'),
                    DetailItem(title: '行政費用', value: '0'),
                    DetailItem(title: '手續費', value: '0'),
                    DetailItem(title: '到帳金額', value: '0'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('存款'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-20'),
                          Text('19:11:37'),
                        ]
                    ),
                    Text('1'),
                    Text('交易終止', style: TextStyle(color: Colors.red)),
                  ],
                  details: const [
                    DetailItem(title: '原始金額', value: '429.96'),
                    DetailItem(title: '目前金額', value: '429.96'),
                    DetailItem(title: '存款優惠', value: '0'),
                    DetailItem(title: '行政費用', value: '0'),
                    DetailItem(title: '手續費', value: '0'),
                    DetailItem(title: '到帳金額', value: '0'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('存款'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-20'),
                          Text('19:11:37'),
                        ]
                    ),
                    Text('1'),
                    Text('交易終止', style: TextStyle(color: Colors.red)),
                  ],
                  details: const [
                    DetailItem(title: '原始金額', value: '429.96'),
                    DetailItem(title: '目前金額', value: '429.96'),
                    DetailItem(title: '存款優惠', value: '0'),
                    DetailItem(title: '行政費用', value: '0'),
                    DetailItem(title: '手續費', value: '0'),
                    DetailItem(title: '到帳金額', value: '0'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('存款'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-20'),
                          Text('19:11:37'),
                        ]
                    ),
                    Text('1'),
                    Text('交易終止', style: TextStyle(color: Colors.red)),
                  ],
                  details: const [
                    DetailItem(title: '原始金額', value: '429.96'),
                    DetailItem(title: '目前金額', value: '429.96'),
                    DetailItem(title: '存款優惠', value: '0'),
                    DetailItem(title: '行政費用', value: '0'),
                    DetailItem(title: '手續費', value: '0'),
                    DetailItem(title: '到帳金額', value: '0'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('存款'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-20'),
                          Text('19:11:37'),
                        ]
                    ),
                    Text('1'),
                    Text('交易終止', style: TextStyle(color: Colors.red)),
                  ],
                  details: const [
                    DetailItem(title: '原始金額', value: '429.96'),
                    DetailItem(title: '目前金額', value: '429.96'),
                    DetailItem(title: '存款優惠', value: '0'),
                    DetailItem(title: '行政費用', value: '0'),
                    DetailItem(title: '手續費', value: '0'),
                    DetailItem(title: '到帳金額', value: '0'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('存款'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-20'),
                          Text('19:11:37'),
                        ]
                    ),
                    Text('1'),
                    Text('交易終止', style: TextStyle(color: Colors.red)),
                  ],
                  details: const [
                    DetailItem(title: '原始金額', value: '429.96'),
                    DetailItem(title: '目前金額', value: '429.96'),
                    DetailItem(title: '存款優惠', value: '0'),
                    DetailItem(title: '行政費用', value: '0'),
                    DetailItem(title: '手續費', value: '0'),
                    DetailItem(title: '到帳金額', value: '0'),
                  ],
                ),
                StickyExpandableRow(
                  cells: const [
                    Text('存款'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2025-12-20'),
                          Text('19:11:37'),
                        ]
                    ),
                    Text('1'),
                    Text('交易終止', style: TextStyle(color: Colors.red)),
                  ],
                  details: const [
                    DetailItem(title: '原始金額', value: '429.96'),
                    DetailItem(title: '目前金額', value: '429.96'),
                    DetailItem(title: '存款優惠', value: '0'),
                    DetailItem(title: '行政費用', value: '0'),
                    DetailItem(title: '手續費', value: '0'),
                    DetailItem(title: '到帳金額', value: '0'),
                  ],
                ),
              ],
            ).p(20).flex()
          ],
        )
    );
  }
}