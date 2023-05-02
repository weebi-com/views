// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_store_closing.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router2/rc_router2.dart';
import 'package:views_weebi/src/ask_are_you_sure.dart';

import 'package:views_weebi/views_article.dart';

import 'package:mixins_weebi/stores.dart';
import 'package:views_weebi/routes.dart';
import 'package:views_weebi/styles.dart';

class ArticleDetailRoute extends RcRoute {
  static String routePath = '/lines/:lineId/:articleId';

  static String generateRoute(String lineId, String articleId) =>
      RcRoute.generateRoute(routePath,
          pathParams: {'lineId': lineId, 'articleId': articleId});

  // temporary hack to avoid mixing components
  // TODO fix this when web is stabilized
  static String generateUpdateRoute(String lineId, String articleId) =>
      RcRoute.generateRoute(ArticleUpdateRouteUnfinished.routePath,
          pathParams: {'lineId': lineId, 'articleId': articleId});

// temporary hack to avoid mixing components
// even more complex for creation...
  static String generateArticleCreateRoute(String lineId) =>
      RcRoute.generateRoute(ArticleCreateRouteUnfinished.routePath,
          pathParams: {'lineId': lineId});

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
    if (articleId.isNotEmpty && int.tryParse(articleId) != null) {
      // this is not a article create route case
      final article = line.articles.firstWhere(
          (a) => '${a.lineId}' == lineId && '${a.id}' == articleId, orElse: () {
        throw 'no article match $lineId.$articleId';
      });
//? consider calling TicketsInvoker & ClosingStockShopsInvoker
      final ticketsStore = Provider.of<TicketsStore>(context, listen: false);
      final closingStore = Provider.of<ClosingsStore>(context, listen: false);

      final fabButton = ((line.isBasket ?? false) == true)
          ? const SizedBox() // ! only one basket per line
          : FloatingActionButton(
              heroTag: 'createArticleSameLine',
              tooltip: 'Créer un article dans la même ligne',
              backgroundColor: WeebiColors.orange,
              onPressed: () => Navigator.of(context)
                  .pushNamed(generateArticleCreateRoute('${line.id}')),
              child: const Icon(Icons.library_add, color: Colors.white),
            );
      final iconButons = [
        IconButton(
          tooltip: "Editer l'article",
          icon: const Icon(Icons.edit, color: WeebiColors.grey),
          onPressed: () async {
            Navigator.of(context).pushNamed(generateUpdateRoute(
                // using this hack instead of below to avoid mixing components
                // ArticleUpdateRoute.generateRoute(
                '${article.productId}',
                '${article.id}'));
          },
        ),
        IconButton(
          tooltip: "Supprimer l'article",
          icon: const Icon(Icons.delete, color: WeebiColors.grey),
          onPressed: () async {
            final articlesStore =
                Provider.of<ArticlesStore>(context, listen: false);
            final isOkToDelete = await AskDialog.areYouSure(
                'Attention',
                'effacer l\'article est irréversible. Êtes vous sur de vouloir continuer ?',
                context,
                barrierDismissible: false);
            if (!isOkToDelete) {
              return;
            }
            final p = articlesStore.lines
                .firstWhere((element) => element.id == article.productId);
            if (p.articles.length <= 1) {
              await articlesStore.deleteForeverLineArticle(p);
              Navigator.of(context)
                  .popAndPushNamed(ArticleLinesFrameRoute.routePath);
            } else {
              await articlesStore.deleteForeverArticle(article);
              Navigator.of(context).popAndPushNamed(
                  ArticleLinesDetailRoute.generateRoute(
                      '${p.id}', 'false', // cannot be locked if here
                      articleId: '1'));
            }
          },
        )
      ];
      return Provider.value(
        value: article,
        child: ArticleDetailWidget(
            article,
            iconButons,
            fabButton,
            () => ticketsStore.tickets,
            () => closingStore.closingStockShops), // todo add isShopLocked here
      );
    } else {
      return Provider.value(
        value: line,
        child: ArticleCreateViewFakeFrame(line),
      );
    }
  }
}
