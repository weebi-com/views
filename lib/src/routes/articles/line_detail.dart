// Flutter imports:
import 'package:mixins_weebi/mobx_store_closing.dart';
import 'package:mixins_weebi/stores.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router2/rc_router2.dart';

import 'package:views_weebi/src/articles/line/line_detail.dart';
import 'package:views_weebi/views_line.dart' show LineArticlesDetailWidget;

class ArticleLineRetailDetailRoute extends RcRoute {
  static String routePath = '/lines/:lineId/slide/:articleId';

  static String generateRoute(String lineId,
          {@required String articleId, String isShopLocked = 'false'}) =>
      RcRoute.generateRoute(routePath,
          pathParams: {'lineId': lineId, 'articleId': articleId});

  ArticleLineRetailDetailRoute()
      : super(path: ArticleLineRetailDetailRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['lineId'];
    final articleId = routeParams.pathParameters['articleId'] ?? '';

    final isShopLocked =
        (routeParams.pathParameters['isShopLocked'] ?? '').toLowerCase() ==
            'true';
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);

    final ticketsStore = Provider.of<TicketsStore>(context, listen: false);
    final closingsStore = Provider.of<ClosingsStore>(context);

    if (articlesStore.lines.any((line) => line.id.toString() == lineId) ==
        false) {
      throw 'no line match $lineId';
    }
    final line =
        articlesStore.lines.firstWhere((line) => line.id.toString() == lineId);

    return Provider.value(
      value: line,
      child: LineArticlesDetailWidget(
        line,
        () => ticketsStore.tickets,
        () => closingsStore.closingStockShops,
        isShopLocked: isShopLocked,
        initArticle: int.tryParse(articleId ?? '1') ?? '1',
      ),
    );
  }
}
