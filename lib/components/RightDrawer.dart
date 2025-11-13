import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/providers/configProvider.dart';

import './FavoriteTabViews.dart';

class RightDrawer extends ConsumerStatefulWidget {
  final List<Tab> tabs;
  final List<Widget> tabViews;
  final double drawerWidth;
  final double drawerHeight;

  RightDrawer({
    Key? key,
    List<Tab>? tabs,
    List<Widget>? tabViews,
    this.drawerWidth = 300,
    this.drawerHeight = 500,
  }) : tabs = tabs ?? [Tab(text: '更多'), Tab(text: '我的最愛'), Tab(text: '瀏覽足跡')],
       tabViews =
           tabViews ??
           [
             Center(child: Text('更多更多更多...')),
             Center(child: FavoriteTabViews()),
             Center(child: Text('瀏覽足跡瀏覽足跡瀏覽足跡...')),
           ],
       super(key: key);

  @override
  ConsumerState<RightDrawer> createState() => _RightDrawerState();
}

class _RightDrawerState extends ConsumerState<RightDrawer>
    with SingleTickerProviderStateMixin {
  bool isDrawerOpen = false;
  bool isShowFloatButton = true;
  late TabController _tabController;

  int activeIndex = 0;

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      isShowFloatButton = !isShowFloatButton;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    final mediaQuery = MediaQuery.of(context);
    final bottomNavBarHeight = 56;
    final maskHeight =
        (mediaQuery.size.height -
            mediaQuery.padding.top -
            kToolbarHeight -
            bottomNavBarHeight // 自訂高度
            -
            mediaQuery.padding.bottom);
    final maskTop = mediaQuery.padding.top;
    final floatButtonTop =
        (mediaQuery.size.height -
            mediaQuery.padding.top -
            kToolbarHeight -
            bottomNavBarHeight // 自訂高度
            -
            mediaQuery.padding.bottom -
            40) / 2;
    return Stack(
      children: [
        // 抽屜主體
        AnimatedPositioned(
          width: mediaQuery.size.width,
          height: maskHeight,
          right: isDrawerOpen ? 0 : -mediaQuery.size.width,
          top: maskTop,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,

          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned(
                  width: mediaQuery.size.width,
                  height: maskHeight,
                  top: maskTop,
                  right: 0,
                  child: Container(color: Colors.black45),
                ),
                Positioned(
                  width: widget.drawerWidth,
                  height: widget.drawerHeight,
                  top: 100,
                  right: 0,

                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: toggleDrawer,
                              ).bg(primaryColor.lighten(0.1)),
                            ).my(20),
                            ...widget.tabs.asMap().entries.map((entry) {
                              int index = entry.key;
                              Tab tab = entry.value;
                              return ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    _tabController.animateTo(index);
                                    setState(() {
                                      activeIndex = index;
                                    });
                                  },
                                  child: Container(
                                    height: 110,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children:
                                            tab.text!
                                                .split('')
                                                .map(
                                                  (char) => Text(
                                                    char,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          index == activeIndex
                                                              ? Colors.white
                                                              : primaryColor
                                                                  .darken(0.1),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                    ),
                                  ),
                                ).bg(
                                  index == activeIndex
                                      ? primaryColor
                                      : Colors.white,
                                ),
                              ).mb(5);
                            }).toList(),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            border: Border(
                              left: BorderSide(
                                width: 10.0,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          child: TabBarView(
                            controller: _tabController,
                            children: widget.tabViews,
                          ).bg(Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 浮動按鈕
        Positioned(
          top: floatButtonTop,
          right: 0,
          child: IgnorePointer(
            ignoring: !isShowFloatButton,
            child: Opacity(
              opacity: isShowFloatButton ? 1 : 0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                child: InkWell(
                  onTap: toggleDrawer,
                  child: Icon(Icons.arrow_back_ios).ml(10),
                ).square(45).bg(primaryColor.lighten(0.1)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
