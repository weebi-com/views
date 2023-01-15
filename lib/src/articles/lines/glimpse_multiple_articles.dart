// Flutter imports:
import 'package:closing/closing_abstraction.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:closing/closing_store.dart';
import 'package:models_weebi/abstractions.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart'
    show Article, ArticleWeebi, LineOfArticles;
import 'package:views_weebi/src/articles/line_route.dart';
import 'package:views_weebi/src/articles/lines/tile_title_glimpse.dart';
import 'package:mixins_weebi/stock.dart';
import 'package:views_weebi/styles.dart' show WeebiColors;
import 'package:views_weebi/views_article.dart';

class LineArticlesGlimpseWidget extends LineArticleStockAbstract
    with LineArticleStockNowMixin {
  LineArticlesGlimpseWidget(
    LineOfArticles line,
    TicketsInvoker ticketsInvoker,
    ClosingStockShopsInvoker closingsInvoker, {
    Key? key,
  }) : super(
          line,
          ticketsInvoker,
          closingsInvoker,
        );

  @override
  Widget build(BuildContext context) {
    final lineLiveQt = lineStockNow;

    return LineArticlesGlimpseWidgetSateful(line, lineLiveQt);
  }
}

class LineArticlesGlimpseWidgetSateful extends StatefulWidget {
  final LineOfArticles line;
  final double lineLiveQt;
  const LineArticlesGlimpseWidgetSateful(this.line, this.lineLiveQt,
      {super.key});

  @override
  LineArticlesGlimpseWidgetSatefulState createState() =>
      LineArticlesGlimpseWidgetSatefulState();
}

class LineArticlesGlimpseWidgetSatefulState
    extends State<LineArticlesGlimpseWidgetSateful> {
  Color? iconColor;
  @override
  void initState() {
    super.initState();
    iconColor = WeebiColors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Appui long pour voir tous les articles de la ligne',
      child: InkWell(
        onLongPress: () {
          Navigator.of(context).pushNamed(
              LineArticlesDetailRoute.generateRoute('${widget.line.id}'));
        },
        child: ExpansionTile(
          onExpansionChanged: (bool expanding) {
            setState(
              () => iconColor =
                  expanding ? WeebiColors.buttonColor : WeebiColors.grey,
            );
          },
          title:
              LineArticleTileTitle(widget.line, widget.lineLiveQt, iconColor!),
          children: <Widget>[
            for (final article in widget.line.articles)
              ArticleWFrameView(article as Article, true)
          ],
        ),
      ),
    );
  }
}
