import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo/extensions/widget.dart';

class Carousel extends StatelessWidget {
  final List<String> imgList;
  final double aspectRatio;
  final double borderRadius;
  final Duration autoPlayInterval;
  final void Function(int index)? onTap;

  const Carousel({
    super.key,
    required this.imgList,
    // this.aspectRatio = 828 / 280,
    this.aspectRatio = 1 / 1,
    this.borderRadius = 12.0,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          viewportFraction: 1.0,
          autoPlay: true
      ),
      items: imgList.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Image.network(
              i,
              fit: BoxFit.cover,
            ).aspectRatio(100 / 1);
          },
        );
      }).toList(),
    );
  }
}
