// Flutter imports:
import 'package:flutter/material.dart';
import 'package:views_weebi/src/styles/colors.dart';

const paddingVerticalLine = EdgeInsets.symmetric(vertical: 8);

final weebiTheme = ThemeData(
  fontFamily: 'PT_Sans-Narrow',
  inputDecorationTheme: InputDecorationTheme(
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: WeebiColors.red),
    ),
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: WeebiColors.buttonColor)),
  ),
  appBarTheme: const AppBarTheme(color: WeebiColors.blackAppBar),
  primaryColor: WeebiColors.blackAppBar,
  buttonTheme: const ButtonThemeData(
    buttonColor: WeebiColors.buttonColor,
    textTheme: ButtonTextTheme.primary,
  ),
  indicatorColor: WeebiColors.yellowIndicator,
  tabBarTheme: const TabBarTheme(
    indicator: BoxDecoration(
      border: Border(
        bottom:
            BorderSide(color: Colors.teal, width: 8, style: BorderStyle.solid),
      ),
      color: WeebiColors.blackAppBar,
    ),
  ),
);
