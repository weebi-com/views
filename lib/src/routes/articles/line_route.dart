// Flutter imports:
import 'package:closing/closing_store.dart';
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_stores/tickets.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router/rc_router.dart';
import 'package:views_weebi/src/articles/line/line_detail.dart';
// TODO ?
// $ dart pub outdated --mode=null-safety
//and then
// $ dart pub upgrade --null-safety
import 'package:views_weebi/views_line.dart' show LineArticlesDetailWidget;

// Project imports:
import 'package:mixins_weebi/stores.dart' show ArticlesStore;
import 'package:mixins_weebi/stock.dart';

class LineOfArticlesDetailRoute extends RcRoute {
  static String routePath = '/lines/:id/';

  static String generateRoute(String id, String isShopLocked,
          {required String articleId}) =>
      RcRoute.generateRoute(routePath, pathParams: {
        'id': id,
        'articleId': articleId,
        'isShopLocked': isShopLocked
      });

  LineOfArticlesDetailRoute()
      : super(path: LineOfArticlesDetailRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['id'];
    final articleId = routeParams.pathParameters['articleId'];
    final isShopLocked =
        (routeParams.pathParameters['isShopLocked'] ?? '').toLowerCase() ==
            'true';
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    ticketsInvoker() =>
        Provider.of<TicketsStore>(context, listen: false).tickets;
    closingStockShopsInvoker() =>
        Provider.of<ClosingsStore>(context, listen: false).closingStockShops;

    return Provider.value(
      value: articlesStore.lines
          .firstWhere((product) => product.id.toString() == lineId),
      child: LineArticlesDetailWidget(
          articlesStore.lines
              .firstWhere((line) => line.id.toString() == lineId),
          initArticle: int.parse(articleId ?? '1'),
          isShopLocked: isShopLocked,
          ticketsInvoker,
          closingStockShopsInvoker),
    );
  }
}
