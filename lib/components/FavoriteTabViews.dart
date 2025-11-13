import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/providers/favoriteProvider.dart';

import 'package:demo/components/ProductCard.dart';

class FavoriteTabViews extends ConsumerStatefulWidget {
  @override
  ConsumerState<FavoriteTabViews> createState() => _FavoriteTabViewsState();
}

class _FavoriteTabViewsState extends ConsumerState<FavoriteTabViews> {
  int activeId = 0;

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoriteProvider);
    return Column(
      children: [
        favorites.length > 0
            ? Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 4 / 5,
                shrinkWrap: true,
                children:
                    favorites.map((i) {
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
                            final notifier = ref.read(
                              favoriteProvider.notifier,
                            );
                            if (notifier.isFavorited(i))
                              notifier.remove(i);
                            else
                              notifier.add(i);
                          });
                        },
                      );
                    }).toList(),
              ).alignTopLeft().p(10),
            )
            : Expanded(
              child:
                  Text(
                    '尚未加入遊戲',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ).center(),
            ),
      ],
    );
  }
}
