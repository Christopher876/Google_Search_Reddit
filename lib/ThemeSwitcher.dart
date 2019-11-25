import 'dart:ui';

import 'package:flutter/material.dart';

//Use different themes in the app selected by user
class ThemeSwitcher{
  Color backgroundTheme = Colors.white;
  Color cardTheme = Colors.white;

  /// Construct a color from a hex code string, of the format #RRGGBB.
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
  
}