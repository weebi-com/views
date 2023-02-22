// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:views_weebi/src/chassis_abstract.dart';

class HomeView<T extends ChassisAbstract> extends StatelessWidget {
  final T child;
  const HomeView(this.child,
      {Key? key, required GlobalKey<NavigatorState> mainNavigator})
      : super(key: key);

  @override
  Widget build(BuildContext context) => child;
}
