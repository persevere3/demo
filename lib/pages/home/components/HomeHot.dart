import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/providers/configProvider.dart';
import 'package:demo/providers/favoriteProvider.dart';

import '../../../../components/Carousel.dart';
import 'package:demo/components/ProductCard.dart';

class HomeHot extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeHot> createState() => _HomeHotState();
}

class _HomeHotState extends ConsumerState<HomeHot> {
  bool isShow = true;
  int activeId = 0;
  final List<Item> items = [
   Item(
     id: 1,
     name: '11111',
     imgUrl: 'https://picsum.photos/id/1011/400/200',
   ),
    Item(
      id: 2,
      name: '22222',
      imgUrl: 'https://picsum.photos/id/1012/400/200',
    ),
    Item(
      id: 3,
      name: '33333',
      imgUrl: 'https://picsum.photos/id/1013/400/200',
    ),
    Item(
      id: 4,
      name: '44444',
      imgUrl: 'https://picsum.photos/id/1014/400/200',
    ),
    Item(
      id: 5,
      name: '55555',
      imgUrl: 'https://picsum.photos/id/1015/400/200',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "熱門推薦",
              style: TextStyle()
                  .textSize(15)
                  .textColor(primaryColor.darken(0.1)),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isShow = !isShow; // 切換狀態
                });
              },
              child: AnimatedRotation(
                turns: isShow ? 0.5 : 0.0, // 0.5圈 = 180度
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black54,
                  size: 30,
                ),
              ),
            ),
          ],
        ).mb(5),
        Carousel(
          carouselItems:
              items.map((i) {
                return ProductCard(
                  item: i,
                  isShowOverlay: i.id == activeId,
                  onShowOverlay: () => setState(() => activeId = i.id),
                  onHideOverlay: () => setState(() => activeId = 0),
                  isFavorite: ref
                      .watch(favoriteProvider)
                      .any((favorite) => favorite.id == i.id),
                  onToggleFavorite: () {
                    setState(() {
                      final notifier = ref.read(favoriteProvider.notifier);
                      if (notifier.isFavorited(i)) notifier.remove(i);
                      else notifier.add(i);
                    });
                  },
                  // onToggleFavorite: () => {setState(() => activeId = i['id']),
                );
              }).toList(),
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 3000),
          viewportFraction: 0.33,
        ).visible(isShow),
      ],
    ).px(15).mt(10);
  }
}
