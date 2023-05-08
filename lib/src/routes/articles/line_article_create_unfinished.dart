import 'package:views_weebi/src/articles/line/create.dart';
import 'package:views_weebi/src/routes/route_base.dart';

class ArticleLineCreateRoute extends WeebiRouteBase {
  static String routePath = '/line_create';

  ArticleLineCreateRoute()
      : super(
            child: const ArticleLineCreateView(),
            routePath: ArticleLineCreateRoute.routePath);
}
