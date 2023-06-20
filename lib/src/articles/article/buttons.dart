import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_store_article.dart';
import 'package:models_weebi/base.dart';
import 'package:models_weebi/weebi_models.dart';
import 'package:provider/provider.dart';
import 'package:views_weebi/src/routes/articles/update_article_basket.dart';
import 'package:views_weebi/src/routes/articles/update_article_retail.dart';
import 'package:views_weebi/src/widgets/ask_dialog.dart';
import 'package:views_weebi/src/routes/articles/all_frame.dart';
import 'package:views_weebi/src/routes/articles/calibre_detail.dart';
import 'package:views_weebi/src/styles/colors.dart';

class EditArticleButton<A extends ArticleAbstract> extends StatelessWidget {
  final A article;
  const EditArticleButton(this.article, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip:
          article is ArticleRetail ? "Editer l'article" : "Editer le panier",
      icon: const Icon(Icons.edit, color: WeebiColors.grey),
      onPressed: () async {
        if (article is ArticleRetail) {
          Navigator.of(context).pushNamed(
              ArticleRetailUpdateRoute.generateRoute(
                  '${this.article.calibreId}', '${this.article.id}'));
        } else {
          final articlesStore =
              Provider.of<ArticlesStore>(context, listen: false);
          articlesStore.clearAllArticleMinQtInSelected();
          Navigator.of(context).popAndPushNamed(
              ArticleBasketUpdateRoute.generateRoute(
                  '${this.article.calibreId}', '${this.article.id}'));
        }
      },
    );
  }
}

class DeleteArticleButton<A extends ArticleAbstract> extends StatelessWidget {
  final A article;
  const DeleteArticleButton(this.article, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: article is ArticleRetail
          ? "Supprimer l'article"
          : "Supprimer le panier",
      icon: const Icon(Icons.delete, color: WeebiColors.grey),
      onPressed: () async {
        final articlesStore =
            Provider.of<ArticlesStore>(context, listen: false);
        final isOkToDelete = await AskDialog.areYouSure(
            'Attention',
            'effacer l\'article est irréversible. Êtes vous sur de vouloir continuer ?',
            context,
            isDismissible: false);
        if (!isOkToDelete) {
          return;
        }
        final p = articlesStore.calibres
            .firstWhere((element) => element.id == article.productId);
        if (p.articles.length <= 1) {
          await articlesStore.deleteForeverCalibre(p);
          Navigator.of(context)
              .popAndPushNamed(ArticlesCalibresAllFrameRoute.routePath);
        } else {
          await articlesStore.deleteForeverArticle(article);
          Navigator.of(context).popAndPushNamed(
              ArticleCalibreRetailDetailRoute.generateRoute('${p.id}',
                  articleId: '1')); // TODO isShopLocked
        }
      },
    );
  }
}
