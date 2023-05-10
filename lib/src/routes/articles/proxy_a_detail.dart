// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_store_closing.dart';
import 'package:models_weebi/weebi_models.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router2/rc_router2.dart';
import 'package:views_weebi/views_article.dart';

import 'package:mixins_weebi/stores.dart';
import 'package:views_weebi/routes.dart';
import 'package:views_weebi/src/articles/article/article_detail.dart';

class ProxyADetailRoute extends RcRoute {
  static String routePath = '/articles/:lineId/:articleId/:proxyId';

  // temporary hack to avoid mixing components
  // TODO fix this when web is stabilized
  static String generateUpdateRoute(String lineId, String articleId) =>
      RcRoute.generateRoute(ArticleRetailUpdateRoute.routePath,
          pathParams: {'lineId': lineId, 'articleId': articleId});

  static String generateRoute(
          String lineId, String articleId, String proxyId) =>
      RcRoute.generateRoute(routePath, pathParams: {
        'lineId': lineId,
        'articleId': articleId,
        'proxyId': proxyId
      });

  ProxyADetailRoute() : super(path: ProxyADetailRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['lineId'];
    final articleId = routeParams.pathParameters['articleId'];
    final proxyId = routeParams.pathParameters['proxyId'];
    print('lineId ${lineId}');
    print('articleId ${articleId}');
    print('proxyId ${proxyId}');

    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);

    final ticketsStore = Provider.of<TicketsStore>(context, listen: false);
    final closingsStore = Provider.of<ClosingsStore>(context, listen: false);

    final line = articlesStore.lines
        .firstWhere((line) => '${line.id}' == lineId, orElse: () {
      throw 'proxy no lines match for $lineId';
    });
    final ArticleBasket article =
        line.articles.firstWhere((a) => '${a.id}' == articleId, orElse: () {
      throw 'proxy no article match $lineId.$articleId';
    }) as ArticleBasket;

    final ProxyArticle proxy = article.proxies.firstWhere(
        (p) =>
            p.lineId.toString() == lineId &&
            p.articleId.toString() == articleId &&
            p.id.toString() == proxyId, orElse: () {
      throw 'no proxy match $lineId.$articleId.$proxyId';
    });

    final lineProxy =
        articlesStore.lines.firstWhere((line) => line.id == proxy.proxyLineId);
    final articleProxy = lineProxy.articles.firstWhere((article) =>
        article.lineId == proxy.proxyLineId &&
        article.id == proxy.proxyArticleId);

    return Provider.value(
      value: articleProxy,
      child: ArticleDetailWidget(
        articleProxy,
        () => ticketsStore.tickets,
        () => closingsStore.closingStockShops,
      ),
    );
  }
}
