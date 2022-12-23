// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router/rc_router.dart';
import 'package:views_weebi/src/articles/line_detail.dart';
// TODO ?
// $ dart pub outdated --mode=null-safety
//and then
// $ dart pub upgrade --null-safety
import 'package:views_weebi/views.dart' show LineArticlesDetailWidget;

// Project imports:
import 'package:weebi/src/stores/articles.dart';

class LineArticlesDetailRoute extends RcRoute {
  static String routePath = '/lines/:id/:articleId/';

  static String generateRoute(String id, {String articleId = '1'}) =>
      RcRoute.generateRoute(routePath,
          pathParams: {'id': id, 'articleId': articleId});

  LineArticlesDetailRoute() : super(path: LineArticlesDetailRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['id'];
    final articleId = routeParams.pathParameters['articleId'];
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    return Provider.value(
      value: articlesStore.lines.firstWhere(
          (product) => product.id.toString() == lineId,
          orElse: () => null),
      child: LineArticlesDetailWidget(
        articlesStore.lines.firstWhere((line) => line.id.toString() == lineId,
            orElse: () => null),
        initArticle: int.parse(articleId!),
      ),
    );
  }
}
