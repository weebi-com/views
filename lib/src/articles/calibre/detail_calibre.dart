// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/invokers.dart';
import 'package:mixins_weebi/mobx_store_article.dart';
import 'package:models_weebi/common.dart';
import 'package:models_weebi/utils.dart';

// Package imports:

import 'package:models_weebi/weebi_models.dart'
    show ArticleBasket, ArticleCalibre;
import 'package:provider/provider.dart';
import 'package:views_weebi/src/articles/article/article_basket/glimpse_a_basket.dart';
import 'package:views_weebi/src/articles/calibre/buttons_calibre.dart';
import 'package:views_weebi/src/articles/article/article_retail/article_cards_slidable.dart';

import 'package:views_weebi/src/routes/articles/all_frame.dart';
import 'package:views_weebi/views_article.dart';
import 'package:views_weebi/styles.dart' show WeebiColors, WeebiTextStyles;
import 'package:mixins_weebi/stock.dart';

import 'package:views_weebi/widgets.dart';

Gradient getLineGradient(ArticleCalibre calibre) {
  if (calibre.status) {
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

class CalibreArticlesDetailWidget extends StatelessWidget {
  final int initArticle;
  final bool isShopLocked;
  final ArticleCalibre calibre;
  final TicketsInvoker ticketsInvoker;
  final ClosingStockShopsInvoker closingStockShopsInvoker;

  CalibreArticlesDetailWidget(
    this.calibre,
    this.ticketsInvoker,
    this.closingStockShopsInvoker, {
    this.isShopLocked = false,
    this.initArticle = 1,
    key,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();

    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);

    return Scaffold(
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 31),
            child: Align(
                alignment: Alignment.bottomRight,
                child: isShopLocked || (calibre.isBasket)
                    ? const SizedBox()
                    : CreateArticleWithinExistingCaliberButton(calibre.id)),
          )
        ],
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: WeebiColors.grey),
          onPressed: () => Navigator.of(context)
              .pushNamed(ArticlesCalibresAllFrameRoute.routePath),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        title: Row(
          children: [
            Text('#${calibre.id}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
                overflow: TextOverflow.ellipsis),
            if (calibre.isBasket == false)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Tooltip(
                    message: 'stock disponible',
                    child: Text(
                        numFormat.format(CalibreRetailStockNow(
                                calibreRetail:
                                    ArticleCalibre.fromMapArticleRetail(
                                        calibre.toMap()),
                                ticketsInvoker: ticketsInvoker,
                                closingStockShopsInvoker:
                                    closingStockShopsInvoker)
                            .stockNow),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            const Icon(Icons.warehouse, color: Colors.black),
          ],
        ),
        actions: isShopLocked
            ? []
            : [
                EditArticleCalibreButton(calibre.id),
                DeleteArticleCalibreButton(
                  calibre,
                  ArticlesCalibresAllFrameRoute.routePath,
                )
              ],
      ),
      body: Container(
        decoration: const BoxDecoration(
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
              if (calibre.isBasket) ...[
                for (final article in calibre.articles)
                  ArticleBasketGlimpseWidStateFul(
                    ArticleBasketRealizablekNow(
                        article: article as ArticleBasket,
                        ticketsInvoker: ticketsInvoker,
                        closingStockShopsInvoker: closingStockShopsInvoker,
                        calibresNoQuickspend:
                            articlesStore.calibres.notQuickSpend),
                  ),
              ] else if (calibre.stockUnit != StockUnit.unit)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(Icons.filter_frames),
                      ),
                      const Text("Unité"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SelectableText(
                          calibre.stockUnit.stockUnitText,
                          style: WeebiTextStyles.blackAndBold,
                        ),
                      ),
                    ],
                  ),
                ),
              if (calibre.status == false)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FieldValueWidget(
                    const Icon(Icons.pause),
                    const Text("Articles désactivés le "),
                    SelectableText(
                      "${calibre.statusUpdateDate}",
                      style: WeebiTextStyles.blackAndBold,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              SlidableCardsV2(calibre, ticketsInvoker, closingStockShopsInvoker,
                  articleId: initArticle)
            ],
          ),
        ),
      ),
    );
  }
}
