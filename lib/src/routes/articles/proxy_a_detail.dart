// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/stores.dart';
import 'package:models_weebi/weebi_models.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router/rc_router.dart';
import 'package:views_weebi/src/articles/article/article_detail.dart';

class ProxyADetailRoute extends RcRoute {
  static String routePath = '/products/:productId/:articleId/:lotId';

  static String generateRoute(
          String productId, String articleId, String lotId) =>
      RcRoute.generateRoute(routePath, pathParams: {
        'productId': productId,
        'articleId': articleId,
        'lotId': lotId
      });
  ProxyADetailRoute() : super(path: ProxyADetailRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['productId'];
    final articleId = routeParams.pathParameters['articleId'];
    final lotId = routeParams.pathParameters['lotId'];
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final line = articlesStore.lines
        .firstWhere((p) => p.id.toString() == lineId, orElse: () {
      throw 'no lines match for $lineId';
    });
    final ArticleBasket article = line.articles
        .firstWhere((a) => a.id.toString() == articleId, orElse: () {
      throw 'no article match $lineId.$articleId';
    }) as ArticleBasket;

    final ProxyArticle proxy = article.proxies.firstWhere(
        (p) =>
            p.lineId.toString() == lineId &&
            p.articleId.toString() == articleId &&
            p.id.toString() == lotId, orElse: () {
      throw 'no proxy match $lineId.$articleId.$lotId';
    });

    return Provider.value(
      value: proxy,
      child: ArticleDetailWidget(article),
    );
  }
}
