// Project imports:
import 'package:flutter/material.dart';
import 'package:views_weebi/src/routes/route_base.dart';

class ArticleLineCreateRoute extends WeebiRouteBase {
  static String routePath = '/line_create';

  ArticleLineCreateRoute()
      : super(
            child: const LineArticleCreateViewFakeFrame(),
            routePath: ArticleLineCreateRoute.routePath);
}

class LineArticleCreateViewFakeFrame extends StatelessWidget {
  const LineArticleCreateViewFakeFrame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO here implement LineArticleCreateView()
    return Container();
  }
}
