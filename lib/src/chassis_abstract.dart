import 'package:flutter/material.dart';

abstract class ChassisAbstract extends StatefulWidget {
  static const Key keyAppBarTitle = Key("AppBar");
  final Widget body;
  final int selectedIndex;
  final GlobalKey<NavigatorState> mainNavigatorKey;
  final Widget floatingButton;
  final List<Widget> actions;
  const ChassisAbstract(
      {key,
      @required this.body,
      @required this.selectedIndex,
      @required this.mainNavigatorKey,
      @required this.floatingButton,
      @required this.actions});
}
