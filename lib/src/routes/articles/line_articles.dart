// ** not ready yet
import 'package:flutter/widgets.dart';
import 'package:views_weebi/src/routes/route_base.dart';

class ArticleLinesRoute extends WeebiRouteBase {
  static String routePath = '/lines';

  ArticleLinesRoute(GlobalKey<NavigatorState> mainNavigator)
      : super(
            child: LinesArticlesViewFakeFrame(mainNavigator),
            routePath: ArticleLinesRoute.routePath);
}

class LinesArticlesViewFakeFrame extends StatelessWidget {
  final GlobalKey<NavigatorState> mainNavigator;
  const LinesArticlesViewFakeFrame(this.mainNavigator, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
//TODO implement LinesArticlesView(mainNavigator: mainNavigator)
    return Container();
  }
}
