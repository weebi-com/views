import 'package:flutter/material.dart';
import 'package:rc_router2/rc_router2.dart';

class WeebiRouteBase extends RcRoute {
  final Widget child;

  WeebiRouteBase({@required this.child, @required String routePath})
      : super(path: routePath);

  @override
  Widget build(BuildContext context) => child;

  @override
  Route routeBuilder(RouteSettings routeSettings) {
    return PageRouteBuilder(
      transitionDuration: Duration.zero,
      settings: routeSettings,
      pageBuilder: (c, _, __) {
        return handle(context: c, routeSettings: routeSettings);
      },
    );
  }
}
