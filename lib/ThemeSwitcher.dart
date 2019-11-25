import 'dart:ui';

import 'package:flutter/material.dart';

class CustomColors{
  Color darkGrey;
  CustomColors(){
    darkGrey = ThemeSwitcher.hexToColor("#2d2d2d");
  }
}

//Use different themes in the app selected by user
class ThemeSwitcher{
  Color backgroundTheme = Colors.white;
  Color cardTheme = Colors.white;
  Color drawerHeaderTheme = Colors.blue;

  /// Construct a color from a hex code string, of the format #RRGGBB.
  static Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
  
}