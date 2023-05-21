// Flutter imports:
import 'package:mixins_weebi/mobx_store_closing.dart';
import 'package:mixins_weebi/stores.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router2/rc_router2.dart';

import 'package:views_weebi/src/articles/calibre/detail_calibre.dart';
import 'package:views_weebi/views_calibre.dart'
    show CalibreArticlesDetailWidget;

class ArticleCalibreRetailDetailRoute extends RcRoute {
  static String routePath = '/calibres/:calibreId/slide/:articleId';

  static String generateRoute(String calibreId,
          {required String articleId, String isShopLocked = 'false'}) =>
      RcRoute.generateRoute(routePath,
          pathParams: {'calibreId': calibreId, 'articleId': articleId});

  ArticleCalibreRetailDetailRoute()
      : super(path: ArticleCalibreRetailDetailRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final calibreId = routeParams.pathParameters['calibreId'];
    final articleId = routeParams.pathParameters['articleId'] ?? '1';

    final isShopLocked =
        (routeParams.pathParameters['isShopLocked'] ?? '').toLowerCase() ==
            'true';
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);

    final ticketsStore = Provider.of<TicketsStore>(context, listen: false);
    final closingsStore = Provider.of<ClosingsStore>(context);

    if (articlesStore.calibres.any((c) => c.id.toString() == calibreId) ==
        false) {
      throw 'no calibre match $calibreId';
    }
    final calibre = articlesStore.calibres
        .firstWhere((calibre) => calibre.id.toString() == calibreId);

    return Provider.value(
      value: calibre,
      child: CalibreArticlesDetailWidget(
        calibre,
        () => ticketsStore.tickets,
        () => closingsStore.closingStockShops,
        isShopLocked: isShopLocked,
        initArticle: int.parse(articleId),
      ),
    );
  }
}
