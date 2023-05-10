// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_store_article.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router2/rc_router2.dart';
import 'package:views_weebi/src/articles/line/update_line.dart';

class ArticleLineUpdateRoute extends RcRoute {
  static String routePath = '/line_update/:lineId';
  // how about products/product_update/:id ?

  static String generateRoute(String lineId) =>
      RcRoute.generateRoute(routePath, pathParams: {'lineId': lineId});

  ArticleLineUpdateRoute() : super(path: ArticleLineUpdateRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['lineId'];
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final line = articlesStore.lines
        .firstWhere((line) => '${line.id}' == lineId, orElse: () {
      throw 'no line match $lineId';
    });
    return Provider.value(
      value: line,
      child: ArticleLineUpdateView(line),
    );
  }
}
