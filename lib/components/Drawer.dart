import 'package:flutter/material.dart';

enum SlideDirection {
  fromLeft,
  fromRight,
  fromTop,
  fromBottom,
}

class SlideDrawerConfig {
  final SlideDirection direction;
  final double? width;
  final double? height;
  final Color primaryColor;
  final String title; // ✅ 表頭標題
  final Duration duration;
  final Color barrierColor;
  final bool barrierDismissible;

  const SlideDrawerConfig({
    this.direction = SlideDirection.fromRight,
    this.width,
    this.height,
    required this.primaryColor,
    this.title = '標題', // ✅ 預設標題
    this.duration = const Duration(milliseconds: 300),
    this.barrierColor = Colors.black54,
    this.barrierDismissible = true,
  });
}

void showSlideDrawer({
  required BuildContext context,
  required Widget child, // ✅ 這裡的 child 只是內容區域
  required SlideDrawerConfig config,
  VoidCallback? onClose,
}) {
  late AnimationController controller;
  late OverlayEntry overlayEntry;

  controller = AnimationController(
    duration: config.duration,
    vsync: Navigator.of(context),
  );

  Offset getBeginOffset() {
    switch (config.direction) {
      case SlideDirection.fromLeft:
        return const Offset(-1.0, 0.0);
      case SlideDirection.fromRight:
        return const Offset(1.0, 0.0);
      case SlideDirection.fromTop:
        return const Offset(0.0, -1.0);
      case SlideDirection.fromBottom:
        return const Offset(0.0, 1.0);
    }
  }

  final slideAnimation = Tween<Offset>(
    begin: getBeginOffset(),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: controller,
    curve: Curves.easeOut,
  ));

  void closeDrawer() {
    controller.reverse().then((_) {
      overlayEntry.remove();
      controller.dispose();
      onClose?.call();
    });
  }

  overlayEntry = OverlayEntry(
    builder: (context) => Material(
      color: config.barrierColor,
      child: Stack(
        children: [
          // 背景遮罩
          if (config.barrierDismissible)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: closeDrawer,
              child: Container(),
            ),

          // 抽屜內容（含表頭）
          _buildDrawerPosition(
            context: context,
            config: config,
            slideAnimation: slideAnimation,
            closeDrawer: closeDrawer,
            child: child,
          ),
        ],
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);
  controller.forward();
}

Widget _buildDrawerPosition({
  required BuildContext context,
  required SlideDrawerConfig config,
  required Animation<Offset> slideAnimation,
  required VoidCallback closeDrawer,
  required Widget child,
}) {
  final screenSize = MediaQuery.of(context).size;

  // ✅ 固定的 drawer 結構（表頭 + 內容）
  Widget drawerWithHeader = Material(
    child: Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => Container(
          color: Colors.white,
          child: Column(
            children: [
              // 固定的表頭
              Container(
                color: Colors.white,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: closeDrawer,
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        size: 40,
                        color: config.primaryColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        config.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(child: child),
            ],
          ),
        ),
      ),
    ),
  );

  switch (config.direction) {
    case SlideDirection.fromLeft:
      return Positioned(
        left: 0,
        top: 0,
        bottom: 0,
        width: config.width ?? screenSize.width * 0.75,
        child: SlideTransition(position: slideAnimation, child: drawerWithHeader),
      );

    case SlideDirection.fromRight:
      return Positioned(
        right: 0,
        top: 0,
        bottom: 0,
        width: config.width ?? screenSize.width,
        child: SlideTransition(position: slideAnimation, child: drawerWithHeader),
      );

    case SlideDirection.fromTop:
      return Positioned(
        left: 0,
        right: 0,
        top: 0,
        height: config.height ?? screenSize.height * 0.5,
        child: SlideTransition(position: slideAnimation, child: drawerWithHeader),
      );

    case SlideDirection.fromBottom:
      return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        height: config.height ?? screenSize.height * 0.5,
        child: SlideTransition(position: slideAnimation, child: drawerWithHeader),
      );
  }
}