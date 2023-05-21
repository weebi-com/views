// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_store_article.dart';
import 'package:models_weebi/weebi_models.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router2/rc_router2.dart';
import 'package:views_weebi/src/articles/article/article_retail/update_a_retail.dart';

class ArticleRetailUpdateRoute extends RcRoute {
  static String routePath = '/article_retail_update/:calibreId/:articleId';

  static String generateRoute(String calibreId, String articleId) =>
      RcRoute.generateRoute(routePath,
          pathParams: {'calibreId': calibreId, 'articleId': articleId});

  ArticleRetailUpdateRoute() : super(path: ArticleRetailUpdateRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final calibreId = routeParams.pathParameters['calibreId'] ?? '';
    final articleId = routeParams.pathParameters['articleId'] ?? '';
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final calibre = articlesStore.calibres
        .firstWhere((p) => p.id.toString() == calibreId, orElse: () {
      throw 'no calibre match $calibreId';
    });
    final article = calibre.articles.firstWhere(
        (a) => '${a.calibreId}' == calibreId && '${a.id}' == articleId,
        orElse: () {
      throw 'no article retail match $calibreId && $articleId';
    });

    return Provider.value(
      value: article,
      child: ArticleUpdateView(article as ArticleRetail),
    );
  }
}
