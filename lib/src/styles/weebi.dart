// Flutter imports:
import 'package:flutter/material.dart';
import 'package:views_weebi/src/styles/colors.dart';

final paddingVerticalLine = const EdgeInsets.symmetric(vertical: 8);

final weebiTheme = ThemeData(
  fontFamily: 'PT_Sans-Narrow',
  appBarTheme: const AppBarTheme(color: WeebiColors.blackAppBar),
  primaryColor: WeebiColors.blackAppBar,
  buttonTheme: ButtonThemeData(
    buttonColor: WeebiColors.buttonColor,
    textTheme: ButtonTextTheme.primary,
  ),
  indicatorColor: WeebiColors.yellowIndicator,
  tabBarTheme: TabBarTheme(
    indicator: BoxDecoration(
      border: Border(
        bottom: const BorderSide(
            color: Colors.teal, width: 8, style: BorderStyle.solid),
      ),
      color: WeebiColors.blackAppBar,
    ),
  ),
);
