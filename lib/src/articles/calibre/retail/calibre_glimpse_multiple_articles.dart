// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/stock.dart';

// Package imports:

// Project imports:
import 'package:views_weebi/src/articles/calibre/retail/calibre_tile_title.dart';
import 'package:views_weebi/src/routes/articles/calibre_detail.dart';
import 'package:views_weebi/styles.dart' show WeebiColors;
import 'package:views_weebi/views_article.dart';

class CalibreMultiRetailsGlimpseWidget extends StatefulWidget {
  final CalibreRetailStockNow calibreRetailStock;
  const CalibreMultiRetailsGlimpseWidget(this.calibreRetailStock);

  @override
  CalibreMultiRetailsGlimpseWidgetState createState() =>
      CalibreMultiRetailsGlimpseWidgetState();
}

class CalibreMultiRetailsGlimpseWidgetState
    extends State<CalibreMultiRetailsGlimpseWidget> {
  Color iconColor = WeebiColors.grey;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        if (widget.calibreRetailStock.calibreRetail.isBasket == false) {
          Navigator.of(context).pushNamed(
              ArticleCalibreRetailDetailRoute.generateRoute(
                  '${widget.calibreRetailStock.calibreRetail.id}', // TODO get isShopLocked for real
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
            widget.calibreRetailStock.calibreRetail,
            widget.calibreRetailStock.stockNow,
            iconColor),
        children: <Widget>[
          for (final article
              in widget.calibreRetailStock.calibreRetail.articles)
            ArticleRetailGlimpseWidget(
              article,
              ArticleRetailStockNow(
                article: article,
                ticketsInvoker: widget.calibreRetailStock.ticketsInvoker,
                closingStockShopsInvoker:
                    widget.calibreRetailStock.closingStockShopsInvoker,
              ),
            )
        ],
      ),
    );
  }
}
