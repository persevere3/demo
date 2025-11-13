import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/providers/configProvider.dart';

class Product {
  final int id;
  final String name;
  final String imageUrl;

  Product({required this.id, required this.name, required this.imageUrl});
}

class Category {
  final int id;
  final String name;
  final String imageUrl;
  final List<Product> products;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.products,
  });
}

class HomeProduct extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeProduct> createState() => _HomeProductState();
}

class _HomeProductState extends ConsumerState<HomeProduct> {
  final categories = [
    Category(
      id: 1,
      name: '熱門排行',
      imageUrl: 'https://picsum.photos/id/1011/400/200',
      products: [
        Product(
          id: 101,
          name: '101',
          imageUrl: 'https://picsum.photos/id/1011/400/200',
        ),
        Product(
          id: 102,
          name: '102',
          imageUrl: 'https://picsum.photos/id/1011/400/200',
        ),
        Product(
          id: 103,
          name: '103',
          imageUrl: 'https://picsum.photos/id/1011/400/200',
        ),
        Product(
          id: 104,
          name: '104',
          imageUrl: 'https://picsum.photos/id/1011/400/200',
        ),
        Product(
          id: 105,
          name: '105',
          imageUrl: 'https://picsum.photos/id/1011/400/200',
        ),
        Product(
          id: 106,
          name: '106',
          imageUrl: 'https://picsum.photos/id/1011/400/200',
        ),
        Product(
          id: 107,
          name: '107',
          imageUrl: 'https://picsum.photos/id/1011/400/200',
        ),
        Product(
          id: 108,
          name: '108',
          imageUrl: 'https://picsum.photos/id/1011/400/200',
        ),
        Product(
          id: 109,
          name: '109',
          imageUrl: 'https://picsum.photos/id/1011/400/200',
        ),
        Product(
          id: 110,
          name: '110',
          imageUrl: 'https://picsum.photos/id/1011/400/200',
        ),
        Product(
          id: 111,
          name: '111',
          imageUrl: 'https://picsum.photos/id/1011/400/200',
        ),
        Product(
          id: 112,
          name: '112',
          imageUrl: 'https://picsum.photos/id/1011/400/200',
        ),
        Product(
          id: 113,
          name: '113',
          imageUrl: 'https://picsum.photos/id/1011/400/200',
        ),
        Product(
          id: 114,
          name: '114',
          imageUrl: 'https://picsum.photos/id/1011/400/200',
        ),
      ],
    ),
    Category(
      id: 2,
      name: '棋牌大廳',
      imageUrl: 'https://picsum.photos/id/1012/400/200',
      products: [
        Product(
          id: 201,
          name: '201',
          imageUrl: 'https://picsum.photos/id/1012/400/200',
        ),
        Product(
          id: 202,
          name: '202',
          imageUrl: 'https://picsum.photos/id/1012/400/200',
        ),
        Product(
          id: 203,
          name: '203',
          imageUrl: 'https://picsum.photos/id/1012/400/200',
        ),
        Product(
          id: 204,
          name: '204',
          imageUrl: 'https://picsum.photos/id/1012/400/200',
        ),
        Product(
          id: 205,
          name: '205',
          imageUrl: 'https://picsum.photos/id/1012/400/200',
        ),
        Product(
          id: 206,
          name: '206',
          imageUrl: 'https://picsum.photos/id/1012/400/200',
        ),
      ],
    ),
    Category(
      id: 3,
      name: '捕魚遊戲',
      imageUrl: 'https://picsum.photos/id/1013/400/200',
      products: [
        Product(
          id: 301,
          name: '301',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 302,
          name: '302',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 303,
          name: '303',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 304,
          name: '304',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 305,
          name: '305',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 306,
          name: '306',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 307,
          name: '307',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 308,
          name: '308',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 309,
          name: '309',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 310,
          name: '310',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 311,
          name: '311',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 312,
          name: '312',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
      ],
    ),
    Category(
      id: 4,
      name: '熱門排行',
      imageUrl: 'https://picsum.photos/id/1011/400/200',
      products: [
        Product(
          id: 101,
          name: '101',
          imageUrl: 'https://picsum.photos/id/1011/400/200',
        ),
        Product(
          id: 102,
          name: '102',
          imageUrl: 'https://picsum.photos/id/1011/400/200',
        ),
      ],
    ),
    Category(
      id: 5,
      name: '棋牌大廳',
      imageUrl: 'https://picsum.photos/id/1012/400/200',
      products: [
        Product(
          id: 201,
          name: '201',
          imageUrl: 'https://picsum.photos/id/1012/400/200',
        ),
        Product(
          id: 202,
          name: '202',
          imageUrl: 'https://picsum.photos/id/1012/400/200',
        ),
        Product(
          id: 203,
          name: '203',
          imageUrl: 'https://picsum.photos/id/1012/400/200',
        ),
        Product(
          id: 204,
          name: '204',
          imageUrl: 'https://picsum.photos/id/1012/400/200',
        ),
        Product(
          id: 205,
          name: '205',
          imageUrl: 'https://picsum.photos/id/1012/400/200',
        ),
        Product(
          id: 206,
          name: '206',
          imageUrl: 'https://picsum.photos/id/1012/400/200',
        ),
      ],
    ),
    Category(
      id: 6,
      name: '捕魚遊戲',
      imageUrl: 'https://picsum.photos/id/1013/400/200',
      products: [
        Product(
          id: 301,
          name: '301',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 302,
          name: '302',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 303,
          name: '303',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 304,
          name: '304',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 305,
          name: '305',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 306,
          name: '306',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 307,
          name: '307',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 308,
          name: '308',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 309,
          name: '309',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 310,
          name: '310',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 311,
          name: '311',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
        Product(
          id: 312,
          name: '312',
          imageUrl: 'https://picsum.photos/id/1013/400/200',
        ),
      ],
    ),
  ];
  int activeId = 1;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    return Expanded(
      child: Row(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children:
                  categories.map((i) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          activeId = i.id;
                        });
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Image.network(i.imageUrl, fit: BoxFit.cover),
                          ).wh(50, 50),
                          Text(
                            i.name,
                            style: TextStyle(
                              color:
                                  i.id == activeId
                                      ? primaryColor.darken(0.1)
                                      : Colors.black,
                            ),
                          ),
                        ],
                      ).mb(10),
                    );
                  }).toList(),
            ).px(10),
          ).py(5).bg((Colors.black12).lighten(0.1)).mr(10),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 3/4,
              shrinkWrap: true,
              children:
                  categories
                      .firstWhere(
                        (category) => category.id == activeId,
                        orElse: () => categories.first,
                      )
                      .products
                      .map((product) {
                        return Column(
                          children: [
                            Container(
                              color: (Colors.black12).lighten(0.1),
                              child: Image.network(
                                product.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ).p(8),
                            ).rounded(10).flex(),

                            Text(product.name),
                          ],
                        );
                      })
                      .toList(),
            ).alignTopLeft().py(10),
          ),
        ],
      ).px(15).mt(10),
    );
  }
}
