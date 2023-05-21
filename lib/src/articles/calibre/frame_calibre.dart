// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/invokers.dart';
import 'package:mixins_weebi/mobx_store_article.dart';
import 'package:mixins_weebi/stock.dart';

import 'package:models_weebi/weebi_models.dart';
import 'package:provider/provider.dart';
import 'package:views_weebi/src/articles/calibre/basket/calibre_glimpse.dart';

import 'package:views_weebi/views_calibre.dart';

class ArticleCalibreFrame extends StatelessWidget {
  const ArticleCalibreFrame({
    Key? key,
    required this.contextMain,
    required this.calibre,
    required this.ticketsInvoker,
    required this.closingStockShopsInvoker,
  }) : super(key: key);

  final BuildContext contextMain;
  final ArticleCalibre calibre;
  final TicketsInvoker ticketsInvoker;
  final ClosingStockShopsInvoker closingStockShopsInvoker;

  @override
  Widget build(BuildContext context) {
    if (calibre.isBasket) {
      final articlesStore = Provider.of<ArticlesStore>(context, listen: false);

      final calibreBasketStockAbstract = StockNowArticleBasket(
        calibre.articles.first as ArticleBasket,
        ticketsInvoker,
        closingStockShopsInvoker,
        articlesStore.calibres.notQuickSpend,
      );
      return LineBasketGlimpseWidget(calibreBasketStockAbstract);
    } else {
      final calibreRetailStock = ArticleCalibreRetailStock(
          articleCalibreRetail: calibre as ArticleCalibre<ArticleRetail>,
          ticketsInvoker: ticketsInvoker,
          closingStockShopsInvoker: closingStockShopsInvoker);
      if (calibre.isSingleArticle) {
        return ArticleRetailSingleCalibreGlimpseWidget(calibreRetailStock);
      } else {
        return ArticlesRetailCalibreGlimpseWidgetSateful(calibreRetailStock);
      }
    }
  }
}
