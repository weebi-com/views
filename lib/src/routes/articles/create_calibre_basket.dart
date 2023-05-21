// Flutter imports:
import 'package:views_weebi/src/articles/calibre/basket/calibrate_create_basket.dart';
import 'package:views_weebi/src/routes/route_base.dart';

class ArticleCalibreBasketCreateRoute extends WeebiRouteBase {
  static String routePath = '/articles/line_basket_create';

  ArticleCalibreBasketCreateRoute()
      : super(
            child: const ArticleBasketCalibrateAndCreateView(),
            routePath: ArticleCalibreBasketCreateRoute.routePath);
}
