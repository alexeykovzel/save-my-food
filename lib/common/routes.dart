import 'package:flutter/material.dart';

class Routes {
  static pushBottomUp(BuildContext context, Widget widget) {
    slidePush(context, widget, const Offset(0, 1));
  }

  static pushRightLeft(BuildContext context, Widget widget) {
    slidePush(context, widget, const Offset(1, 0));
  }

  static slidePush(BuildContext context, Widget widget, Offset offset) {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Animatable<Offset> tween = Tween(begin: offset, end: Offset.zero)
            .chain(CurveTween(curve: Curves.ease));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ));
  }
}
