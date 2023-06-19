// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/invokers.dart';
import 'package:mixins_weebi/mobx_store_article.dart';
import 'package:mixins_weebi/stock.dart';

import 'package:models_weebi/weebi_models.dart';
import 'package:provider/provider.dart';
import 'package:views_weebi/src/articles/calibre/basket/calibre_glimpse.dart';

import 'package:views_weebi/views_calibre.dart';

class ArticleCalibreGlimpse extends StatelessWidget {
  const ArticleCalibreGlimpse({
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
    //calibre.articles.first is ArticleBasket
    if (calibre.isBasket) {
      final articlesStore = Provider.of<ArticlesStore>(context, listen: false);

      final calibreBasketStockAbstract = ArticleBasketRealizablekNow(
        article: calibre.articles.first as ArticleBasket,
        ticketsInvoker: ticketsInvoker,
        closingStockShopsInvoker: closingStockShopsInvoker,
        calibresNoQuickspend: articlesStore.calibres.notQuickSpend,
      );
      return CalibreBasketGlimpseWidget(calibreBasketStockAbstract);
    } else {
      // *
      // might need to cast
      // final ArticleCalibre<ArticleRetail> calibreRetail =
      //     ArticleCalibre.fromMapArticleRetail(calibre.toMap());
      final calibreRetailStock = CalibreRetailStockNow(
          calibreRetail: calibre as ArticleCalibre<ArticleRetail>,
          ticketsInvoker: ticketsInvoker,
          closingStockShopsInvoker: closingStockShopsInvoker);
      if (calibre.isSingleArticle) {
        return CalibreSingleRetailGlimpseWidget(calibreRetailStock);
      } else {
        return CalibreMultiRetailsGlimpseWidget(calibreRetailStock);
      }
    }
  }
}
