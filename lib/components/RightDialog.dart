import 'package:flutter/material.dart';

class RightDialog {
  static Future show(BuildContext context, Widget child) {
    return showGeneralDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        final mediaQuery = MediaQuery.of(context);
        final bottomNavBarHeight = 56;
        final dialogHeight =
        (mediaQuery.size.height -
            mediaQuery.padding.top -
            kToolbarHeight -
            bottomNavBarHeight // 自訂高度
            -
            mediaQuery.padding.bottom);
        final dialogTop = mediaQuery.padding.top + kToolbarHeight;

        return Padding(
          padding: EdgeInsets.only(top: dialogTop),
          child: Align(
            alignment: Alignment.topRight,
            child: Material(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: dialogHeight,
                color: Colors.white,
                child: child,
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1.0, 0), // 從右側外面開始
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}