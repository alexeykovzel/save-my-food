import 'package:flutter/material.dart';

enum HexColor { red, pink, lightPink, green, yellow, gray }

extension HexColorValues on HexColor {
  get() => Color(value());

  value() {
    switch (this) {
      case HexColor.red:
        return 0xFFCA2F2F;
      case HexColor.pink:
        return 0xFFFF6C6C;
      case HexColor.lightPink:
        return 0xFFFFADAD;
      case HexColor.green:
        return 0xFF7EE44D;
      case HexColor.yellow:
        return 0xFFE5DD16;
      case HexColor.gray:
        return 0xFFC0C0C0;
    }
  }
}

ThemeData buildTheme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Inter',
    primaryColor: HexColor.pink.get(),
    textTheme: const TextTheme(
      bodyText2: TextStyle(fontSize: 16),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.light,

      // colors of primary widgets
      primary: HexColor.pink.get(),
      secondary: HexColor.pink.get(),
      background: HexColor.pink.get(),
      surface: HexColor.pink.get(),
      error: HexColor.pink.get(),

      // colors of secondary widgets
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.white,
      onSurface: Colors.white,
      onError: Colors.white,
    ),
  );
}
