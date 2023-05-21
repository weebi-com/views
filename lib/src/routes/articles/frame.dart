// ** not ready yet
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:views_weebi/src/chassis_abstract.dart';
import 'package:views_weebi/src/routes/route_base.dart';
import 'package:views_weebi/views.dart';

class ArticlesCalibresAllFrameRoute<T extends ChassisAbstract>
    extends WeebiRouteBase {
  static String routePath = '/article_calibres';

  ArticlesCalibresAllFrameRoute(
      GlobalKey<NavigatorState> mainNavigator, T child)
      : super(
            child:
                HomeViewChassisBuilder<T>(child, mainNavigator: mainNavigator),
            routePath: ArticlesCalibresAllFrameRoute.routePath);
}
