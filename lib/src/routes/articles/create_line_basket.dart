// Flutter imports:
import 'package:views_weebi/src/articles/line/line_basket/create_line_basket.dart';
import 'package:views_weebi/src/routes/route_base.dart';

class ArticleLineBasketCreateRoute extends WeebiRouteBase {
  static String routePath = '/articles/line_basket_create';

  ArticleLineBasketCreateRoute()
      : super(
            child: const ArticleLineBasketCreateView(),
            routePath: ArticleLineBasketCreateRoute.routePath);
}
