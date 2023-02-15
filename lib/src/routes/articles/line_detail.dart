// Flutter imports:
import 'package:mixins_weebi/mobx_stores/closings.dart';
import 'package:mixins_weebi/stores.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router/rc_router.dart';
import 'package:mixins_weebi/stores.dart';
import 'package:views_weebi/routes.dart';
import 'package:views_weebi/src/dialogs.dart';
import 'package:views_weebi/styles.dart'; // Flutter imports:

import 'package:views_weebi/src/articles/line/line_detail.dart';
import 'package:views_weebi/views_line.dart' show LineArticlesDetailWidget;

class LineOfArticlesDetailRoute extends RcRoute {
  static String routePath = '/lines/:lineId';

  static String generateRoute(String lineId, String isShopLocked,
          {required String articleId}) =>
      RcRoute.generateRoute(routePath, pathParams: {'lineId': lineId});
  static String generateUpdateRoute(String lineId, String isShopLocked,
          {required String articleId}) =>
      RcRoute.generateRoute(LineOfArticleUpdateRouteUnfinished.routePath,
          pathParams: {
            'lineId': lineId,
            'articleId': articleId,
            'isShopLocked': isShopLocked
          });

  static String generateArticleCreateRoute(String lineId) =>
      RcRoute.generateRoute(ArticleCreateRouteUnfinished.routePath,
          pathParams: {'lineId': lineId});

  static String generateArticleBasketCreateRoute(String lineId) =>
      RcRoute.generateRoute(ArticleBasketCreateRouteUnfinished.routePath,
          pathParams: {'lineId': lineId});

  LineOfArticlesDetailRoute()
      : super(path: LineOfArticlesDetailRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['lineId'];
    final articleId = routeParams.pathParameters['articleId'];
    final isShopLocked =
        (routeParams.pathParameters['isShopLocked'] ?? '').toLowerCase() ==
            'true';
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);

    //? consider calling TicketsInvoker & ClosingStockShopsInvoker
    final ticketsStore = Provider.of<TicketsStore>(context, listen: false);

    final closingsStore = Provider.of<ClosingsStore>(context);
    // print('closingsStore $closingsStore');
    // final closingStockShopsInvoker() => closingsStore.closingStockShops;

    final line = articlesStore.lines
        .firstWhere((line) => line.id.toString() == lineId, orElse: () {
      throw 'no line match $lineId';
    });

    final fabButton = isShopLocked
        ? const SizedBox()
        : (line.isBasket ?? false)
            ? FloatingActionButton(
                heroTag: 'créer un panier',
                tooltip: 'créer un panier d\'article',
                backgroundColor: Colors.amber[700],
                onPressed: () => Navigator.of(context)
                    .pushNamed(generateArticleBasketCreateRoute('${line.id}')),
                child: const Icon(Icons.library_add, color: Colors.white),
              )
            : FloatingActionButton(
                heroTag: 'créer un article',
                tooltip: 'créer un article',
                backgroundColor: Colors.orange[700],
                onPressed: () => Navigator.of(context)
                    .pushNamed(generateArticleCreateRoute('${line.id}')),
                child: const Icon(
                  Icons.library_add,
                  color: Colors.white,
                ),
              );

    final iconButtons = [
      IconButton(
        icon: const Icon(Icons.edit, color: WeebiColors.grey),
        tooltip: "Editer toute la ligne d'articles",
        onPressed: () {
          Navigator.of(context).pushNamed(generateUpdateRoute(
              '${line.id}', '$isShopLocked',
              articleId: articleId ?? '1'));
        },
      ),
      // add a dialog warning below
      IconButton(
          tooltip: "Supprimer toute le ligne d'articles",
          icon: const Icon(Icons.delete_forever, color: WeebiColors.grey),
          onPressed: () async {
            final isOkToDelete = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (c) => AskAreYouSure(line.isSingleArticle
                  ? 'Attention effacer un article est irréversible. Êtes vous sur de vouloir continuer ?'
                  : 'Attention effacer une ligne d\'articles est irréversible. Êtes vous sur de vouloir continuer ?'),
            );
            if (!isOkToDelete) {
              return;
            }
            final articlesStore =
                Provider.of<ArticlesStore>(context, listen: false);
            final p = await articlesStore.deleteForeverLineArticle(line);

            Navigator.of(context)
                .pushNamed(ArticleLinesRouteUnfinished.routePath);
          })
    ];
    return Provider.value(
      value: line,
      child: LineArticlesDetailWidget(
        line,
        () => ticketsStore.tickets,
        () => closingsStore.closingStockShops,
        iconButtons,
        fabButton,
        isShopLocked: isShopLocked,
        initArticle: int.parse(articleId ?? '1'),
      ),
    );
  }
}
