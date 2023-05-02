// ** not ready yet
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:views_weebi/src/routes/route_base.dart';
import 'package:views_weebi/views_tutos.dart';

class InfoRoute extends WeebiRouteBase {
  static String routePath = '/info';

  InfoRoute(GlobalKey<NavigatorState> mainNavigator)
      : super(
          child: InfoView(mainNavigator),
          routePath: InfoRoute.routePath,
        );
}
