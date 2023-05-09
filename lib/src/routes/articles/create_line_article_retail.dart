import 'package:views_weebi/src/articles/line/line_create_retail.dart';
import 'package:views_weebi/src/routes/route_base.dart';

class ArticleLineRetailCreateRoute extends WeebiRouteBase {
  static String routePath = '/article_line_retail_create';

  ArticleLineRetailCreateRoute()
      : super(
            child: const ArticleLineRetailCreateView(),
            routePath: ArticleLineRetailCreateRoute.routePath);
}
