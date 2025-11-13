import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../layout/DefaultLayout.dart';

import 'package:demo/providers/configProvider.dart';

class CustomerServicePage extends ConsumerStatefulWidget {
  const CustomerServicePage({super.key});

  @override
  ConsumerState createState() => _CustomerServicePageState();
}

class _CustomerServicePageState extends ConsumerState<CustomerServicePage> {

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> itemList = [
      {
        "ItemName": "客服手機",
        "ItemUrl": ""
      },
      {
        "ItemName": "客服手機2",
        "ItemUrl": ""
      },
      {
        "ItemName": "客服手機3",
        "ItemUrl": ""
      },
      {
        "ItemName": "客服手機4",
        "ItemUrl": ""
      },
      {
        "ItemName": "客服手機5",
        "ItemUrl": ""
      },
      {
        "ItemName": "客服手機6",
        "ItemUrl": ""
      },
      {
        "ItemName": "客服手機7",
        "ItemUrl": ""
      },
      {
        "ItemName": "搶紅包",
        "ItemUrl": ""
      },
      {
        "ItemName": "客服二維碼",
        "ItemUrl": ""
      },
      {
        "ItemName": "客服鏈接11",
        "ItemUrl": ""
      },
      {
        "ItemName": "客服二維碼2",
        "ItemUrl": ""
      },
      {
        "ItemName": "客服鏈接111",
        "ItemUrl": ""
      },
      {
        "ItemName": "忙和",
        "ItemUrl": ""
      },
      {
        "ItemName": "彩金派發",
        "ItemUrl": ""
      },
      {
        "ItemName": "客服鏈街15",
        "ItemUrl": ""
      },
      {
        "ItemName": "得意紅包",
        "ItemUrl": ""
      },
      {
        "ItemName": "集卡紅包",
        "ItemUrl": ""
      },
    ];

    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return DefaultLayout(
      // title 可選，不傳則使用 config.appName
        title: '線上客服',
        child: ListView.builder(
          itemCount: itemList.length,
          itemBuilder: (context, index) {
            return ElevatedButton(
                onPressed: () {
                  setState(() {

                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: '#ffffff'.toColor()
                ),
                child: Text(itemList[index]['ItemName'], style: TextStyle(
                 fontSize: 18
                ))
            ).mb(_height * 0.02);
          },
        ).px(_width * 0.15).py(_height * 0.03).bg('#dadada'.toColor()).w(double.infinity),
    );
  }
}
