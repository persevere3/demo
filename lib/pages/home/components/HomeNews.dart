import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/providers/configProvider.dart';

import 'package:marquee/marquee.dart';

class HomeNews extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeNews> createState() => _HomeNewsState();
}

class _HomeNewsState extends ConsumerState<HomeNews> {
  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    return Row(
        children: <Widget>[
          Text(
              "最新公告",
              style: TextStyle()
                  .textSize(15)
                  .textColor(primaryColor.darken(0.1))
          ).mr(15),
          Expanded(
            child: Container(
              height: 25,
              child: Marquee(
                text: '這是一個簡單的跑馬燈文字，從右往左持續滾動',
                style: TextStyle(fontSize: 15),
                scrollAxis: Axis.horizontal,
                velocity: 40, // 滾動速度
                // crossAxisAlignment: CrossAxisAlignment.start, // 垂直對齊

                // blankSpace: 20,        // 文字間空白距離
                // startPadding: 10,      // 開始內距
                // accelerationDuration: Duration(seconds: 1),
                // accelerationCurve: Curves.linear,
                // decelerationDuration: Duration(milliseconds: 500),
                // decelerationCurve: Curves.easeOut,
              ),
            ),
          ),
        ]
    ).px(15);
  }
}