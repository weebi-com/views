// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_store_closing.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router2/rc_router2.dart';

import 'package:views_weebi/views_article.dart';

import 'package:mixins_weebi/stores.dart';

class ArticleDetailRoute extends RcRoute {
  static String routePath = '/articles/lines/:calibreId/:articleId';

  static String generateRoute(String calibreId, String articleId) =>
      RcRoute.generateRoute(routePath,
          pathParams: {'calibreId': calibreId, 'articleId': articleId});

  ArticleDetailRoute() : super(path: ArticleDetailRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final calibreId = routeParams.pathParameters['calibreId'] ?? '';
    final articleId = routeParams.pathParameters['articleId'] ?? '';
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final calibre = articlesStore.calibres
        .firstWhere((l) => l.id == int.tryParse(calibreId), orElse: () {
      throw 'no calibre match $calibreId';
    });
    // this is not a article create route case
    final article = calibre.articles.firstWhere(
        (a) => '${a.calibreId}' == calibreId && '${a.id}' == articleId,
        orElse: () {
      throw 'no article match $calibreId.$articleId';
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
