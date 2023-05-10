// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_store_closing.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router2/rc_router2.dart';

import 'package:views_weebi/views_article.dart';

import 'package:mixins_weebi/stores.dart';

class ArticleDetailRoute extends RcRoute {
  static String routePath = '/lines/:lineId/:articleId';

  static String generateRoute(String lineId, String articleId) =>
      RcRoute.generateRoute(routePath,
          pathParams: {'lineId': lineId, 'articleId': articleId});

  ArticleDetailRoute() : super(path: ArticleDetailRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['lineId'] ?? '';
    final articleId = routeParams.pathParameters['articleId'] ?? '';
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final line = articlesStore.lines
        .firstWhere((l) => l.id == int.tryParse(lineId), orElse: () {
      throw 'no line match $lineId';
    });
    // this is not a article create route case
    final article = line.articles.firstWhere(
        (a) => '${a.lineId}' == lineId && '${a.id}' == articleId, orElse: () {
      throw 'no article match $lineId.$articleId';
    });
    final ticketsStore = Provider.of<TicketsStore>(context, listen: false);
    final closingStore = Provider.of<ClosingsStore>(context, listen: false);

    return Provider.value(
      value: article,
      child: ArticleDetailWidget(article, () => ticketsStore.tickets,
          () => closingStore.closingStockShops),
    );
  }
}
