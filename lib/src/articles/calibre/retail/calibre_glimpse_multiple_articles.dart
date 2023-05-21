// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_store_article.dart';
import 'package:mixins_weebi/stock.dart';
import 'package:provider/provider.dart';

// Package imports:

// Project imports:
import 'package:views_weebi/src/articles/calibre/retail/calibre_tile_title.dart';
import 'package:views_weebi/src/routes/articles/calibre_detail.dart';
import 'package:views_weebi/styles.dart' show WeebiColors;
import 'package:views_weebi/views_article.dart';

class ArticlesRetailCalibreGlimpseWidgetSateful extends StatefulWidget {
  final ArticleCalibreRetailStock calibreRetailStock;
  const ArticlesRetailCalibreGlimpseWidgetSateful(this.calibreRetailStock);

  @override
  ArticlesRetailCalibreGlimpseWidgetSatefulState createState() =>
      ArticlesRetailCalibreGlimpseWidgetSatefulState();
}

class ArticlesRetailCalibreGlimpseWidgetSatefulState
    extends State<ArticlesRetailCalibreGlimpseWidgetSateful> {
  Color iconColor = WeebiColors.grey;

  @override
  Widget build(BuildContext context) {
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    return InkWell(
      onLongPress: () {
        if (widget.calibreRetailStock.articleCalibreRetail.isBasket == false) {
          Navigator.of(context).pushNamed(
              ArticleCalibreRetailDetailRoute.generateRoute(
                  '${widget.calibreRetailStock.articleCalibreRetail.id}', // TODO get isShopLocked for real
                  articleId:
                      '1')); // this.ticketsInvoker, this.closingStockShopsInvoker,
        }
      },
      child: ExpansionTile(
        onExpansionChanged: (bool expanding) {
          setState(
            () => iconColor =
                expanding ? WeebiColors.buttonColor : WeebiColors.grey,
          );
        },
        title: ArticleRetailCalibreTileTitle(
            widget.calibreRetailStock.articleCalibreRetail,
            widget.calibreRetailStock.stockNow,
            iconColor),
        children: <Widget>[
          for (final article
              in widget.calibreRetailStock.articleCalibreRetail.articles)
            ArticleRetailFrameView(
                StockNowArticleRetail(
                    article,
                    widget.calibreRetailStock.ticketsInvoker,
                    widget.calibreRetailStock.closingStockShopsInvoker,
                    articlesStore.calibres.notQuickSpend),
                true)
        ],
      ),
    );
  }
}
