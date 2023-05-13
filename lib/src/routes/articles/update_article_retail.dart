// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_store_article.dart';
import 'package:models_weebi/weebi_models.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router2/rc_router2.dart';
import 'package:views_weebi/src/articles/article/article_retail/update_a_retail.dart';

class ArticleRetailUpdateRoute extends RcRoute {
  static String routePath = '/article_retail_update/:lineId/:articleId';

  static String generateRoute(String lineId, String articleId) =>
      RcRoute.generateRoute(routePath,
          pathParams: {'lineId': lineId, 'articleId': articleId});

  ArticleRetailUpdateRoute() : super(path: ArticleRetailUpdateRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['lineId'] ?? '';
    final articleId = routeParams.pathParameters['articleId'] ?? '';
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final line = articlesStore.lines
        .firstWhere((p) => p.id.toString() == lineId, orElse: () {
      throw 'no line match $lineId';
    });
    final article = line.articles.firstWhere(
        (a) => '${a.lineId}' == lineId && '${a.id}' == articleId, orElse: () {
      throw 'no line match $lineId';
    });

    return Provider.value(
      value: article,
      // child: isBasket
      //     ? ArticleBasketUpdateViewFakeFrame(article as ArticleBasket)
      //     :
      child: ArticleUpdateView(article as ArticleRetail),
    );
  }
}
