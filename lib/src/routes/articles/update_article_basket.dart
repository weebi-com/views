// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_store_article.dart';
import 'package:models_weebi/weebi_models.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router2/rc_router2.dart';
import 'package:views_weebi/src/articles/article/article_basket/update_basket.dart';
import 'package:views_weebi/src/extensions/proxy_article.dart';

class ArticleBasketUpdateRoute extends RcRoute {
  static String routePath = '/article_basket_update/:calibreId/:articleId';

  static String generateRoute(String calibreId, String articleId) =>
      RcRoute.generateRoute(routePath,
          pathParams: {'calibreId': calibreId, 'articleId': articleId});

  ArticleBasketUpdateRoute() : super(path: ArticleBasketUpdateRoute.routePath);

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
      throw 'no calibre match $calibreId';
    });

    final articlesMinQtWeebi = <ArticleWMinQt>[];

    final calibres =
        articlesStore.calibres.where((element) => element.isBasket == false);
    articlesMinQtWeebi
        .addAll((article as ArticleBasket).proxies.getProxiesMinQt(calibres));
    for (final a in articlesMinQtWeebi) {
      articlesStore.addArticleWInSelected(a);
    }
    return Provider.value(
      value: article,
      child: ArticleBasketUpdateView(article),
    );
  }
}
