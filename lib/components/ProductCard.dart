import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:demo/providers/favoriteProvider.dart';

class ProductCard extends StatelessWidget {
  final Item item;
  final bool isShowOverlay;
  final VoidCallback onShowOverlay;
  final VoidCallback onHideOverlay;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const ProductCard({
    Key? key,
    required this.item,
    required this.isShowOverlay,
    required this.onShowOverlay,
    required this.onHideOverlay,
    required this.isFavorite,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget ImageWedget = Image.network(item.imgUrl, fit: BoxFit.cover);
    if(!item.imgUrl.startsWith('http://') && !item.imgUrl.startsWith('https://')) {
      ImageWedget = Image.asset(item.imgUrl, fit: BoxFit.cover);
    }

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ImageWedget,
            ),
            Text(item.name).mt(5),
            GestureDetector(
              onTap: onShowOverlay,
              child: Icon(Icons.more_horiz),
            ),
          ],
        ).px(10),
        if (isShowOverlay)
          GestureDetector(
            onTap: onHideOverlay,
            child: Container(
              height: 150,
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(60, 25),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: onToggleFavorite,
                  child: Text(isFavorite ? '取消最愛' : '加入最愛'),
                ),
              ),
            ),
          ),
      ],
    );
  }
}