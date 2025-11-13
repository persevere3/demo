import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../layout/DefaultLayout.dart';

import 'package:demo/providers/configProvider.dart';
import 'package:demo/providers/favoriteProvider.dart';

class SlotGameHallPage extends ConsumerWidget {
  final int? id;

  SlotGameHallPage({super.key, this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      // title 可選，不傳則使用 config.appName
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: '搜索',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // 執行搜索邏輯
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ).p(10).h(70),
          GestureDetector(
            onTap: () {
              print('點擊了電子遊戲公告');
              // 處理點擊事件
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              color: Colors.grey[300],
              child: Text(
                '電子遊戲公告',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 50,
                  color: Color.fromRGBO(255, 212, 94, 1.0),
                ),
                Row(children: [
                  Image.asset('assets/images/img-new-game.png').h(50).mr(5),
                  TopGameCard(
                      color1: '#fddc68'.toColor(),
                      color2: '#ff9011'.toColor(),
                      imgPath: 'assets/images/new.png',
                      imgName: '海怪傳說'
                  ),
                  TopGameCard(
                      color1: '#fddc68'.toColor(),
                      color2: '#ff9011'.toColor(),
                      imgPath: 'assets/images/new.png',
                      imgName: '海怪傳說'
                  ),
                  TopGameCard(
                      color1: '#fddc68'.toColor(),
                      color2: '#ff9011'.toColor(),
                      imgPath: 'assets/images/new.png',
                      imgName: '海怪傳說'
                  ),
                ])
              ],
            )
          ).my(10),
          Container(
              width: double.infinity,
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 50,
                    color: '#ffd2d2'.toColor()
                  ),
                  Row(children: [
                    Image.asset('assets/images/img-recommend.png').h(50).mr(5),

                    TopGameCard(
                        color1: '#ff8591'.toColor(),
                        color2: '#e52f41'.toColor(),
                        imgPath: 'assets/images/recommend.png',
                        imgName: '麻將胡了'
                    ),
                    TopGameCard(
                        color1: '#ff8591'.toColor(),
                        color2: '#e52f41'.toColor(),
                        imgPath: 'assets/images/recommend.png',
                        imgName: '麻將胡了'
                    ),
                    TopGameCard(
                        color1: '#ff8591'.toColor(),
                        color2: '#e52f41'.toColor(),
                        imgPath: 'assets/images/recommend.png',
                        imgName: '麻將胡了'
                    ),
                  ])
                ],
              )
          ).mb(10),
          Tabs().flex(),
        ],
      ),
    );
  }
}

class TopGameCard extends StatelessWidget {
  final Color color1;
  final Color color2;
  final String imgPath;
  final String imgName;

  const TopGameCard({
    Key? key,
    required this.color1,
    required this.color2,
    required this.imgPath,
    required this.imgName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Image.asset(imgPath),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black,
              child: Text(
                imgName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      )
    );
  }
}

class Tabs extends ConsumerStatefulWidget {
  const Tabs({super.key});

  @override
  ConsumerState<Tabs> createState() => _TabsState();
}
class _TabsState extends ConsumerState<Tabs> {
  int activeId = 0;
  final List<String> categories = ['全部', '老虎機', '棋牌', '捕魚'];
  final Map<String, List<Item>> games = {
    '全部': [
      Item(
        id: 6,
        name: 'Sudoku',
        imgUrl: 'assets/images/new.png',
      ),
      Item(
        id: 7,
        name: 'Valley',
        imgUrl: 'assets/images/new.png',
      ),
      Item(
        id: 8,
        name: 'Sekiro',
        imgUrl: 'assets/images/new.png',
      ),
      Item(
        id: 9,
        name: 'Devil',
        imgUrl: 'assets/images/new.png',
      ),
      Item(
        id: 10,
        name: '海怪傳說',
        imgUrl: 'assets/images/new.png',
      ),
      Item(
        id: 11,
        name: '麻將胡了',
        imgUrl: 'assets/images/new.png',
      ),
    ],
    '老虎機': [
      Item(
        id: 6,
        name: 'Sudoku',
        imgUrl: 'assets/images/new.png',
      ),
      Item(
        id: 7,
        name: 'Valley',
        imgUrl: 'assets/images/new.png',
      ),
    ],
    '棋牌': [
      Item(
        id: 8,
        name: 'Sekiro',
        imgUrl: 'assets/images/new.png',
      ),
      Item(
        id: 9,
        name: 'Devil',
        imgUrl: 'assets/images/new.png',
      ),
    ],
    '捕魚': [
      Item(
        id: 10,
        name: '海怪傳說',
        imgUrl: 'assets/images/new.png',
      ),
      Item(
        id: 11,
        name: '麻將胡了',
        imgUrl: 'assets/images/new.png',
      ),
    ]
  };

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Column(
        children: [
          TabBar(
            tabs: categories.map((e) => Tab(text: e)).toList(),
            isScrollable: true,
          ),
          TabBarView(
            children: categories.map((category) =>
              // 可切換 ListView 或 GridView
              GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 每行顯示4個
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 0.75
                ),
                children: games[category]!
                  .map((game) =>  BottomGameCard(
                    imgPath: game.imgUrl ?? '',
                    imgName: game.name ?? '',

                    isShowOverlay: game.id == activeId,
                    onShowOverlay: () => setState(() => activeId = game.id),
                    onHideOverlay: () => setState(() => activeId = 0),
                    isFavorite: ref
                        .watch(favoriteProvider)
                        .any((favorite) => favorite.id == game.id),
                    onToggleFavorite: () {
                      setState(() {
                        final notifier = ref.read(favoriteProvider.notifier);
                        if (notifier.isFavorited(game)) notifier.remove(game);
                        else notifier.add(game);
                      });
                    },
                  ),
                ).toList(),
              ).p(15),
            ).toList(),
          ).flex(),
        ],
      ),
    );
  }
}

class BottomGameCard extends ConsumerWidget {
  final String imgPath;
  final String imgName;

  final bool isShowOverlay;
  final VoidCallback onShowOverlay;
  final VoidCallback onHideOverlay;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const BottomGameCard({
    Key? key,
    required this.imgPath,
    required this.imgName,

    required this.isShowOverlay,
    required this.onShowOverlay,
    required this.onHideOverlay,
    required this.isFavorite,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: primaryColor,  // 底線顏色
                        width: 5.0,  // 底線粗細
                      ),
                    ),
                  ),
                  child: Image.asset(imgPath, fit: BoxFit.cover),
                )
              ),
              GestureDetector(
                onTap: onShowOverlay,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      imgName,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                      size: 18,
                    )
                  ],
                ).py(3).px(5),
              ),
            ],
          ),

          if (isShowOverlay)
            GestureDetector(
              onTap: onHideOverlay,
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                      minimumSize: Size.zero,
                    ),
                    onPressed: onToggleFavorite,
                    child: Text(
                      isFavorite ? '取消最愛' : '加入最愛',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      )
                    ),
                  ),
                ),
              ),
            ),
        ],
      )
    );
  }
}





