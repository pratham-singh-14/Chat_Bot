import 'package:flutter/material.dart';

class FontSizes{
  static const extraSmall= 14.0;
  static const small = 16.0;
  static const standard= 18.0;
  static const large = 20.0;
  static const extraLarge = 24.0;
  static const doubleExtraLarge=26.0;
}

ThemeData lightMode=ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Colors.blue,
    secondary: Colors.white,
  ),
    textTheme: TextTheme(
        titleLarge: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black)

    )
);
ThemeData darkMode=ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.black,
    primary: Colors.blue,
    secondary: Colors.white,
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white),
  )

);