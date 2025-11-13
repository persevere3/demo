import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import '../../../../components/Carousel.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = [
      'https://picsum.photos/id/1011/800/200',
      'https://picsum.photos/id/1012/800/200',
      'https://picsum.photos/id/1013/800/200',
    ];

    return Carousel(
      carouselItems:
          imageUrls.map((i) {
            return Image.network(i, fit: BoxFit.cover);
          }).toList(),
      rounded: 15,
    ).p(10);
  }
}
