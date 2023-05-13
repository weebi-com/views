import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:views_weebi/routes.dart' show WeebiRouteBase;
import 'info_view.dart';

class InfoRoute extends WeebiRouteBase {
  static String routePath = '/info';

  InfoRoute(GlobalKey<NavigatorState> mainNavigator)
      : super(
          child: InfoView(mainNavigator),
          routePath: InfoRoute.routePath,
        );
}
