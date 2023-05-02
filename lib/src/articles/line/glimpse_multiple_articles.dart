// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

// Project imports:
import 'package:models_weebi/weebi_models.dart' show ArticleRetail, ArticleLine;
import 'package:views_weebi/src/articles/line/tile_title_glimpse.dart';
import 'package:views_weebi/src/routes/articles/line_detail.dart';
import 'package:mixins_weebi/stock.dart';
import 'package:views_weebi/styles.dart' show WeebiColors;
import 'package:views_weebi/views_article.dart';

class LineArticlesGlimpseWidget extends LineArticleStockAbstract
    with LineArticleStockNowMixin {
  LineArticlesGlimpseWidget(
    ArticleLine line,
    TicketsInvoker ticketsInvoker,
    ClosingStockShopsInvoker closingStockShopsInvoker, {
    key,
  }) : super(
          line,
          ticketsInvoker,
          closingStockShopsInvoker,
        );

  @override
  Widget build(BuildContext context) {
    return LineArticlesGlimpseWidgetSateful(
        line, lineStockNow, ticketsInvoker, closingStockShopsInvoker);
  }
}

class LineArticlesGlimpseWidgetSateful extends StatefulWidget {
  final ArticleLine line;
  final double lineStockNow;
  final TicketsInvoker ticketsInvoker;
  final ClosingStockShopsInvoker closingStockShopsInvoker;
  const LineArticlesGlimpseWidgetSateful(
    this.line,
    this.lineStockNow,
    this.ticketsInvoker,
    this.closingStockShopsInvoker,
  );

  @override
  LineArticlesGlimpseWidgetSatefulState createState() =>
      LineArticlesGlimpseWidgetSatefulState();
}

class LineArticlesGlimpseWidgetSatefulState
    extends State<LineArticlesGlimpseWidgetSateful> {
  Color iconColor;
  @override
  void initState() {
    super.initState();
    iconColor = WeebiColors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.line.isBasket == false
          ? 'Appui long pour voir tous les articles de la ligne'
          : '',
      child: InkWell(
        onLongPress: () {
          if (widget.line.isBasket == false) {
            Navigator.of(context).pushNamed(ArticlesLineDetailRoute.generateRoute(
                '${widget.line.id}', 'false', // TODO get isShopLocked for real
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
          title:
              LineArticleTileTitle(widget.line, widget.lineStockNow, iconColor),
          children: <Widget>[
            for (final article in widget.line.articles)
              ArticleWFrameView(
                article as ArticleRetail,
                true,
                widget.ticketsInvoker,
                widget.closingStockShopsInvoker,
              )
          ],
        ),
      ),
    );
  }
}
