// Flutter imports:
import 'package:closing/closing_abstraction.dart';
import 'package:closing/closing_store.dart';
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_stores/articles.dart';
import 'package:models_weebi/abstractions.dart';
import 'package:models_weebi/common.dart';
import 'package:models_weebi/utils.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:mixins_weebi/stock.dart';

import 'package:models_weebi/weebi_models.dart'
    show ArticleBasket, EnvironmentWeebi, LineOfArticles, ShopWeebi;
import 'package:views_weebi/views_article.dart';
import 'package:weebi/src/providers/top_provider.dart';
import 'package:views_weebi/routes.dart';
import 'package:weebi/src/stores/shop.dart';
import 'package:views_weebi/styles.dart' show WeebiColors;
import 'package:views_weebi/styles.dart' show WeebiTextStyles;
import 'package:weebi/src/views/main_views/articles/article_basket/article_basket_create.dart';
import 'package:weebi/src/views/main_views/articles/article_basket/article_basket_glimpse.dart';

import 'package:weebi/src/widgets/dialogs/ask_are_you_sure_bis.dart';

import 'package:views_weebi/widgets.dart';

Gradient getLineGradient(LineOfArticles line) {
  if (line.status) {
    return const LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment(0.0, 0.9),
      colors: [Color.fromRGBO(245, 245, 245, 1), Colors.black],
      tileMode: TileMode.clamp,
    );
  } else {
    return const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment(0.0, 0.9),
        colors: [Color.fromRGBO(230, 81, 0, 1), Colors.black],
        tileMode: TileMode.clamp);
  }
}

class LineArticlesDetailWidget extends LineArticleStockAbstract
    with LineArticleStockNowMixin {
  final int initArticle;
  LineArticlesDetailWidget(
    LineOfArticles line,
    TicketsInvoker ticketsInvoker,
    ClosingStockShopsInvoker closingsInvoker, {
    this.initArticle = 1,
  }) : super(
          line,
          ticketsInvoker,
          closingsInvoker,
        );

  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();

    final shopStore = Provider.of<ShopStore>(context, listen: false);
    final thisShop = shopStore.shop.first;
    final lineLiveQt = lineStockNow;

    return Scaffold(
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 31),
            child: Align(
              alignment: Alignment.bottomRight,
              child: thisShop.isLocked
                  ? const SizedBox()
                  : (line.isBasket ?? false)
                      ? FloatingActionButton(
                          heroTag: 'créer un panier',
                          tooltip: 'créer un panier d\'article',
                          child: const Icon(Icons.library_add,
                              color: Colors.white),
                          backgroundColor: Colors.amber[700],
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ArticleBasketCreateView(line),
                            ),
                          ),
                        )
                      : FloatingActionButton(
                          heroTag: 'créer un article',
                          tooltip: 'créer un article',
                          backgroundColor: Colors.orange[700],
                          onPressed: () => Navigator.of(context).pushNamed(
                              ArticleCreateRoute.generateRoute('${line.id}')),
                          child: const Icon(
                            Icons.library_add,
                            color: Colors.white,
                          ),
                        ),
            ),
          )
        ],
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: WeebiColors.grey),
          onPressed: () =>
              Navigator.of(context).pushNamed(ArticleLinesRoute.routePath),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        title: Row(
          children: [
            Text('#${line.id}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
                overflow: TextOverflow.ellipsis),
            if (line.isBasket == false)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${numFormat.format(lineLiveQt)}',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
            const Icon(Icons.warehouse, color: Colors.black),
          ],
        ),
        actions: actionsWidget(context, thisShop),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment(0.0, 1),
              colors: [Color(0xFF20272B), Colors.white],
              tileMode: TileMode.clamp),
        ),
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              // * for now no basket here, keep it simple
              // if (line.isBasket) ...[
              //   if (line.isSingleArticle)
              //     LineSingleABasketGlimpseWidget(line)
              //   else
              //     LineABasketGlimpseWidgetStateful(line)
              // ] else ...[
              //   if (line.isSingleArticle)
              //     LineSingleArticleGlimpseWidget(line)
              //   else
              //     LineArticlesGlimpseWidget(line)
              // ],

              if (!(line.isBasket ?? false)) ...[
                if (line.stockUnit != StockUnit.unit)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FieldValueWidget(
                      const Icon(Icons.style),
                      const Text("Unité"),
                      SelectableText(
                        "${line.stockUnit.stockUnitText}",
                        style: WeebiTextStyles.blackAndBold,
                      ),
                    ),
                  ),
                if (line.status == false)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FieldValueWidget(
                      const Icon(Icons.pause),
                      const Text("Articles désactivés le "),
                      SelectableText(
                        "${line.statusUpdateDate ?? ''}",
                        style: WeebiTextStyles.blackAndBold,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                SlidableCardsV2(
                  line,
                  articleId: initArticle,
                )
              ] else ...[
                for (final article in line.articles)
                  ArticleBasketGlimpseWidget(line, article as ArticleBasket)
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> actionsWidget(BuildContext context, ShopWeebi thisShop) {
    return <Widget>[
      if (thisShop.isLocked == false)
        IconButton(
          icon: const Icon(Icons.edit, color: WeebiColors.grey),
          tooltip: "Editer toute la ligne d'articles",
          onPressed: () {
            if (thisShop.isLocked == true) {
              showDialogWeebiNotOk('Permission requise', context);
              return;
            } else {
              Navigator.of(context).pushNamed(
                  LineArticleUpdateRoute.generateRoute('${line.id}'));
            }
          },
        ),
      // add a dialog warning below
      if (context.read<TopProvider>().environment != EnvironmentWeebi.ldb ||
          thisShop.isLocked == false)
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
}
