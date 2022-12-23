import 'package:flutter/material.dart';
import 'package:mixins_weebi/stores.dart';
import 'package:models_weebi/weebi_models.dart';
import 'package:provider/provider.dart';
import 'package:views_weebi/routes.dart';
import 'package:views_weebi/src/dialogs.dart';
import 'package:views_weebi/styles.dart';

List<Widget> actionsLineWidget(
    BuildContext context, bool isShopLocked, LineOfArticles line) {
  return <Widget>[
    if (isShopLocked == false)
      IconButton(
        icon: const Icon(Icons.edit, color: WeebiColors.grey),
        tooltip: "Editer toute la ligne d'articles",
        onPressed: () {
          if (isShopLocked == true) {
            showDialogWeebiNotOk('Permission requise', context);
            return;
          } else {
            Navigator.of(context)
                .pushNamed(LineArticleUpdateRoute.generateRoute('${line.id}'));
          }
        },
      ),
    // add a dialog warning below
    if (isShopLocked == false)
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

            Navigator.of(context).pushNamed(ArticleLinesRoute.routePath);
          }),
  ];
}
