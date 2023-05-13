// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_store_article.dart';

// Package imports:

import 'package:models_weebi/weebi_models.dart' show ArticleLine;
import 'package:provider/provider.dart';
import 'package:views_weebi/src/routes/articles/create_article_retail.dart';

import 'package:views_weebi/src/routes/articles/frame.dart';
import 'package:views_weebi/src/routes/articles/update_line.dart';
import 'package:views_weebi/styles.dart' show WeebiColors;

import 'package:views_weebi/widgets.dart';

class CreateArticleWithinLineButton extends StatelessWidget {
  final bool isShopLocked;
  final int articleLineId;
  const CreateArticleWithinLineButton(this.articleLineId,
      {this.isShopLocked, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'créer un sous-article',
      tooltip: 'créer un sous-article',
      backgroundColor: Colors.orange[700],
      onPressed: () => Navigator.of(context).pushNamed(
          ArticleRetailCreateRoute.generateRoute('${articleLineId}')),
      child: const Icon(Icons.library_add, color: Colors.white),
    );
  }
}

class EditArticleLineButton extends StatelessWidget {
  final bool isShopLocked;
  final int articleLineId;
  const EditArticleLineButton(this.articleLineId, {this.isShopLocked, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit, color: WeebiColors.orange),
      tooltip: "Editer toute la ligne d'articles",
      onPressed: () {
        Navigator.of(context).pushNamed(
            ArticleLineUpdateRoute.generateRoute('${articleLineId}'));
      },
    );
  }
}

class DeleteArticleLineButton extends StatelessWidget {
  final bool isShopLocked;
  final ArticleLine articleLine;
  const DeleteArticleLineButton(this.articleLine, {this.isShopLocked, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: "Supprimer toute le ligne d'articles",
        icon: const Icon(Icons.delete_forever, color: WeebiColors.orange),
        onPressed: () async {
          final isOkToDelete = await AskDialog.areYouSure(
            'Attention',
            articleLine.isSingleArticle
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
          await articlesStore.deleteForeverLineArticle(articleLine);

          Navigator.of(context).pushNamed(ArticlesLinesAllFrameRoute.routePath);
        });
  }
}
