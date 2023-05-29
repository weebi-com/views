import 'package:views_weebi/src/articles/calibre/retail/calibrate_create_retail.dart';
import 'package:views_weebi/src/routes/route_base.dart';

class ArticleRetailCalibrationAndCreationRoute extends WeebiRouteBase {
  static String routePath = '/articles/article_retail_calibration_creation';

  ArticleRetailCalibrationAndCreationRoute()
      : super(
            child: const ArticleRetailCalibrateAndCreateView(),
            routePath: ArticleRetailCalibrationAndCreationRoute.routePath);
}
