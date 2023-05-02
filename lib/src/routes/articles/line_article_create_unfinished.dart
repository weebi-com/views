// Project imports:
import 'package:flutter/material.dart';
import 'package:views_weebi/src/routes/route_base.dart';

class ArticleLineCreateRouteUnfinished extends WeebiRouteBase {
  static String routePath = '/line_create';

  ArticleLineCreateRouteUnfinished()
      : super(
            child: const LineArticleCreateViewFakeFrame(),
            routePath: ArticleLineCreateRouteUnfinished.routePath);
}

class LineArticleCreateViewFakeFrame extends StatelessWidget {
  const LineArticleCreateViewFakeFrame({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO here implement LineArticleCreateView()
    return Scaffold(
      appBar: AppBar(
        title: Text('en cours'),
      ),
    );
  }
}
