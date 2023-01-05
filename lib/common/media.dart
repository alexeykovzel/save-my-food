import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum SvgCorner { topLeft, topRight, bottomRight, bottomLeft }

extension CornerBuilder on SvgCorner {
  String get _path {
    switch (this) {
      case SvgCorner.topLeft:
        return 'assets/images/corners/corner-1.svg';
      case SvgCorner.topRight:
        return 'assets/images/corners/corner-2.svg';
      case SvgCorner.bottomRight:
        return 'assets/images/corners/corner-4.svg';
      case SvgCorner.bottomLeft:
        return 'assets/images/corners/corner-3.svg';
    }
  }

  Widget get() {
    return SvgPicture.asset(_path);
  }
}
