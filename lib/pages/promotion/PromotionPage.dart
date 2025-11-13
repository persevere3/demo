import 'dart:async';
import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../layout/DefaultLayout.dart';

import 'package:demo/providers/configProvider.dart';
import 'package:demo/providers/userProvider.dart';

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

class PromotionPage extends ConsumerStatefulWidget {
  const PromotionPage({super.key});
  @override
  ConsumerState<PromotionPage> createState() => _PromotionPageState();
}

class _PromotionPageState extends ConsumerState<PromotionPage> {
  List<Map<String, dynamic>> categoryList = [
    {
      "CatalogName": "全部",
      "PromotionList": [
        "5aebd4b524c8724a480fcf27",
        "5af3cbad54020f437c80701c",
        "61b079a4c95437213435302e"
      ],
      "CatalogId": "69041da3decb8e3244eee81b"
    },
    {
      "CatalogName": "优惠活动",
      "PromotionList": [
        "5aebd4b524c8724a480fcf27",
        "5af3cbad54020f437c80701c",
        "61b079a4c95437213435302e"
      ],
      "CatalogId": "5af4f0fe54020f437c807025"
    },
    {
      "CatalogName": "优惠2",
      "PromotionList": [
        "5aebd4b524c8724a480fcf27"
      ],
      "CatalogId": "5af6856654020f437c80702d"
    }
  ];
  int activeCategoryIndex = 0;
  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    return DefaultLayout(
      // title 可選，不傳則使用 config.appName
      title: '優惠活動',
      child: Row(
          children: [
            ListView.builder(
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        activeCategoryIndex = index;
                        _expandedIndex = -1;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: index == activeCategoryIndex ? primaryColor : Colors.white,
                      foregroundColor: index == activeCategoryIndex ? Colors.white : primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                    ),
                    child: Text(categoryList[index]['CatalogName'])
                );
              },
            ).w(120).px(10).py(20),
            ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10),
              itemCount: categoryList[activeCategoryIndex]['PromotionList'].length,
              itemBuilder: (context, index) {
                print('_expandedIndex: $_expandedIndex index: $index =========');
                final isExpanded = _expandedIndex == index;
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_expandedIndex == index) {
                            _expandedIndex = -1;
                          } else {
                            _expandedIndex = index;
                            print(index);
                            print(_expandedIndex);
                          }
                        });
                      },
                      child: Image.network('https://picsum.photos/300/150?random=${categoryList[activeCategoryIndex]['PromotionList'][index]}', fit: BoxFit.cover),
                    ),
                    AnimatedSize(
                      duration: Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      child: Container(
                        width: double.infinity,
                        child: isExpanded
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('關閉圖片 $index'))
                                          );
                                        },
                                        child: const Text('關閉'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('註冊圖片 $index'))
                                          );
                                        },
                                        child: const Text('註冊'),
                                      ),
                                    ]
                                ).py(5)
                              ],
                            )
                          : SizedBox.shrink(), // 收合時顯示空 Widget
                      ),
                    ),
                  ],
                ).mb(5);
              },
            ).flex(),
          ]
      ).bg('c5c5c5'.toColor())
    );
  }
}




