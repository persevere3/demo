import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo/extensions/widget.dart';

class Carousel extends StatelessWidget {
  final List<Widget> carouselItems;
  /// 輪播高度
  final double height;
  /// 是否開啟自動播放
  final bool autoPlay;
  /// 自動播放每次切換的停留時間
  final Duration autoPlayInterval;
  /// 自動播放動畫持續時間
  final Duration autoPlayAnimationDuration;
  /// 自動播放動畫曲線，決定滑動效果
  final Curve autoPlayCurve;
  /// 中心頁面是否放大
  final bool enlargeCenterPage;
  /// 顯示圖片寬度占用比例 (0~1)，1 為完整寬度
  final double viewportFraction;
  /// 輪播滾動方向，水平或垂直
  final Axis scrollDirection;

  ///
  final double rounded;

  Carousel({
    required this.carouselItems,

    this.height = 150,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 1000),
    this.autoPlayCurve = Curves.linear,
    this.enlargeCenterPage = false,
    this.viewportFraction = 1,
    this.scrollDirection = Axis.horizontal,

    this.rounded = 0
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          height: height,
          autoPlay: autoPlay,
          autoPlayInterval: autoPlayInterval,
          autoPlayAnimationDuration: autoPlayAnimationDuration,
          autoPlayCurve: autoPlayCurve,
          enlargeCenterPage: enlargeCenterPage,
          viewportFraction: viewportFraction,
          scrollDirection: scrollDirection,
      ),
      items: carouselItems,
    ).rounded(rounded);
  }
}
