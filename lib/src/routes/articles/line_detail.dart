// Flutter imports:
import 'package:mixins_weebi/mobx_store_closing.dart';
import 'package:mixins_weebi/stores.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router2/rc_router2.dart';
import 'package:views_weebi/routes.dart';
import 'package:views_weebi/src/ask_are_you_sure.dart';
import 'package:views_weebi/styles.dart'; // Flutter imports:

import 'package:views_weebi/src/articles/line/line_detail.dart';
import 'package:views_weebi/views_line.dart' show LineArticlesDetailWidget;

class ArticleLinesDetailRoute extends RcRoute {
  static String routePath = '/lines/:lineId/slide/:articleId';

  static String generateRoute(String lineId, String isShopLocked,
          {@required String articleId}) =>
      RcRoute.generateRoute(routePath,
          pathParams: {'lineId': lineId, 'articleId': articleId});

  static String generateUpdateRoute(String lineId, String isShopLocked,
          {@required String articleId}) =>
      RcRoute.generateRoute(LineOfArticleUpdateRouteUnfinished.routePath,
          pathParams: {
            'lineId': lineId,
            'articleId': articleId,
            'isShopLocked': isShopLocked
          });

// temporary hack to avoid mixing components
// even more complex for creation...
  static String generateArticleCreateRoute(String lineId) =>
      RcRoute.generateRoute(ArticleCreateRouteUnfinished.routePath,
          pathParams: {'lineId': lineId});

// temporary hack to avoid mixing components
// even more complex for creation...
  static String generateArticleLineCreateRouteUnfinished() =>
      RcRoute.generateRoute(ArticleLineCreateRouteUnfinished.routePath);

  ArticleLinesDetailRoute() : super(path: ArticleLinesDetailRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['lineId'];
    final articleId = routeParams.pathParameters['articleId'] ?? '';

    final isShopLocked =
        (routeParams.pathParameters['isShopLocked'] ?? '').toLowerCase() ==
            'true';
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);

    //? consider calling TicketsInvoker & ClosingStockShopsInvoker
    final ticketsStore = Provider.of<TicketsStore>(context, listen: false);

    final closingsStore = Provider.of<ClosingsStore>(context);
    // print('closingsStore $closingsStore');
    // final closingStockShopsInvoker() => closingsStore.closingStockShops;

    if (articlesStore.lines.any((line) => line.id.toString() == lineId) ==
        false) {
      throw 'no line match $lineId';
    }
    final line =
        articlesStore.lines.firstWhere((line) => line.id.toString() == lineId);

    final fabButton = isShopLocked
        ? const SizedBox()
        : (line.isBasket ?? false)
            ? const SizedBox()
            : FloatingActionButton(
                heroTag: 'créer un sous-article',
                tooltip: 'créer un sous-article',
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
            final isOkToDelete = await AskDialog.areYouSure(
              'Attention',
              line.isSingleArticle
                  ? 'Attention effacer un article est irréversible. Êtes vous sur de vouloir continuer ?'
                  : 'Attention effacer une ligne d\'articles est irréversible. Êtes vous sur de vouloir continuer ?',
              context,
              barrierDismissible: false,
            );
            if (!isOkToDelete) {
              return;
            }
            final articlesStore =
                Provider.of<ArticlesStore>(context, listen: false);
            await articlesStore.deleteForeverLineArticle(line);

            Navigator.of(context).pushNamed(ArticleLinesFrameRoute.routePath);
          })
    ];
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
          iconButtons,
          fabButton,
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
