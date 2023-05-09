// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router2/rc_router2.dart';

// Project imports:
import 'package:mixins_weebi/stores.dart' show ArticlesStore;
import 'package:views_weebi/src/articles/article/article_retail/retail_create.dart';

class ArticleRetailCreateRoute extends RcRoute {
  static String routePath = '/lines/:lineId/article_retail_create';

  static String generateRoute(String lineId) =>
      RcRoute.generateRoute(routePath, pathParams: {'lineId': lineId});

  ArticleRetailCreateRoute() : super(path: ArticleRetailCreateRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['lineId'];
    // print('lineId $lineId');
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final line = articlesStore.lines
        .firstWhere((line) => line.id.toString() == lineId, orElse: () {
      throw 'no LineArticle matching line.id $lineId';
    });
    return Provider.value(
      value: line,
      child: ArticleCreateView(line: line),
    );
  }
}
