import 'package:flutter/material.dart';
import 'package:mixins_weebi/stores.dart';
import 'package:models_weebi/base.dart';
import 'package:provider/provider.dart';
import 'package:views_weebi/routes.dart';
import 'package:views_weebi/src/dialogs.dart';
import 'package:views_weebi/styles.dart';

List<Widget> actionsArticleWidget<A extends ArticleAbstract>(
  BuildContext context,
  bool isShopLocked,
  A article,
) {
  return <Widget>[
    if (!isShopLocked)
      IconButton(
        tooltip: "Editer l'article",
        icon: const Icon(Icons.edit, color: WeebiColors.grey),
        onPressed: () async {
          if (isShopLocked == true) {
            return showDialogWeebi('Permission requise', context);
          } else {
            Navigator.of(context).pushNamed(ArticleUpdateRoute.generateRoute(
                '${article.productId}', '${article.id}'));
          }
        },
      ),
    if (!isShopLocked)
      IconButton(
        tooltip: "Supprimer l'article",
        icon: const Icon(Icons.delete, color: WeebiColors.grey),
        onPressed: () async {
          final articlesStore =
              Provider.of<ArticlesStore>(context, listen: false);
          final isOkToDelete = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (c) => const AskAreYouSure(
                'Attention effacer l\'article est irréversible. Êtes vous sur de vouloir continuer ?'),
          );

          if (!isOkToDelete) {
            return;
          }
          final p = articlesStore.lines
              .firstWhere((element) => element.id == article.productId);
          if (p.articles.length <= 1) {
            await articlesStore.deleteForeverLineArticle(p);
            Navigator.of(context).popAndPushNamed(ArticleLinesRoute.routePath);
          } else {
            await articlesStore.deleteForeverArticle(article);
            Navigator.of(context).popAndPushNamed(
                LineOfArticlesDetailRoute.generateRoute(
                    '${p.id}', '$isShopLocked',
                    articleId: '1'));
          }
        },
      )
  ];
}

// Flutter imports:

