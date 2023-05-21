// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:views_weebi/src/chassis_abstract.dart';

class HomeViewChassisBuilder<T extends ChassisAbstract>
    extends StatelessWidget {
  final T child;
  const HomeViewChassisBuilder(this.child,
      {Key? key, required GlobalKey<NavigatorState> mainNavigator})
      : super(key: key);

  @override
  Widget build(BuildContext context) => child;
}
