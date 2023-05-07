// Flutter imports:
import 'package:mixins_weebi/mobx_store_closing.dart';
import 'package:mixins_weebi/stores.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router2/rc_router2.dart';
import 'package:views_weebi/routes.dart';

import 'package:views_weebi/src/articles/line/line_detail.dart';
import 'package:views_weebi/views_line.dart' show LineArticlesDetailWidget;

class ArticlesLineDetailRoute extends RcRoute {
  static String routePath = '/lines/:lineId/slide/:articleId';

  static String generateRoute(String lineId,
          {@required String articleId, String isShopLocked = 'false'}) =>
      RcRoute.generateRoute(routePath,
          pathParams: {'lineId': lineId, 'articleId': articleId});

  static String generateUpdateRoute(
    String lineId,
    String isShopLocked,
  ) =>
      RcRoute.generateRoute(LineOfArticleUpdateRouteUnfinished.routePath,
          pathParams: {'lineId': lineId, 'isShopLocked': isShopLocked});

// temporary hack to avoid mixing components
// even more complex for creation...
  static String generateCreateArticleWithinLineRoute(String lineId) =>
      RcRoute.generateRoute(ArticleCreateRouteUnfinished.routePath,
          pathParams: {'lineId': lineId});

// temporary hack to avoid mixing components
// even more complex for creation...
  static String generateArticleLineCreateRouteUnfinished() =>
      RcRoute.generateRoute(ArticleLineCreateRouteUnfinished.routePath);

  ArticlesLineDetailRoute() : super(path: ArticlesLineDetailRoute.routePath);

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

    if (articleId.isNotEmpty && int.tryParse(articleId) != null) {
      // this would yield error on deletion
      // print('articleId $articleId');
      // final article = line.articles.firstWhere(
      //     (a) => '${a.lineId}' == lineId && '${a.id}' == articleId, orElse: () {
      //   throw 'no article match $lineId.$articleId';
      // });
      return Provider.value(
        value: line,
        child: LineArticlesDetailWidget(
          line,
          () => ticketsStore.tickets,
          () => closingsStore.closingStockShops,
          isShopLocked: isShopLocked,
          initArticle: int.parse(articleId ?? '1'),
        ),
      );
    } else {
      return Provider.value(
        value: line,
        child: ArticleCreateViewFakeFrame(line),
      );
    }
  }
}
