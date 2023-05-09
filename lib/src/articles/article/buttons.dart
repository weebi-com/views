import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_store_article.dart';
import 'package:models_weebi/base.dart';
import 'package:models_weebi/weebi_models.dart';
import 'package:provider/provider.dart';
import 'package:views_weebi/src/routes/articles/update_article_basket.dart';
import 'package:views_weebi/src/routes/articles/update_article_retail.dart';
import 'package:views_weebi/src/widgets/ask_are_you_sure.dart';
import 'package:views_weebi/src/routes/articles/article_detail.dart';
import 'package:views_weebi/src/routes/articles/frame.dart';
import 'package:views_weebi/src/routes/articles/line_detail.dart';
import 'package:views_weebi/src/styles/colors.dart';

class EditArticleButton<A extends ArticleAbstract> extends StatelessWidget {
  final A article;
  const EditArticleButton(this.article, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Editer l'article",
      icon: const Icon(Icons.edit, color: WeebiColors.grey),
      onPressed: () async {
        if (article is ArticleRetail) {
          Navigator.of(context).pushNamed(
              ArticleRetailUpdateRoute.generateRoute(
                  '${this.article.lineId}', '${this.article.id}'));
        } else {
          Navigator.of(context).pushNamed(
              ArticleBasketUpdateRoute.generateRoute(
                  '${this.article.lineId}', '${this.article.id}'));
        }
      },
    );
  }
}

class DeleteArticleButton<A extends ArticleAbstract> extends StatelessWidget {
  final A article;
  const DeleteArticleButton(this.article, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
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
              .popAndPushNamed(ArticlesLinesAllFrameRoute.routePath);
        } else {
          await articlesStore.deleteForeverArticle(article);
          Navigator.of(context).popAndPushNamed(
              ArticleLineRetailDetailRoute.generateRoute('${p.id}',
                  articleId: '1')); // TODO isShopLocked
        }
      },
    );
  }
}
