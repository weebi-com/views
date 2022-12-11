// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:closing/closing_store.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart'
    show ArticleWeebi, LineOfArticles;
import 'package:views_weebi/src/articles/lines/tile_title_glimpse.dart';
import 'package:views_weebi/stock.dart';
import 'package:weebi/src/routes/articles/line_article_detail.dart';
import 'package:weebi/src/stores/tickets.dart';
import 'package:views_weebi/styles.dart' show WeebiColors;

import 'package:weebi/src/views/main_views/articles/article_weebi/frame.dart';

class LineArticlesGlimpseWidget extends LineArticleStockAbstract
    with LineArticleStockNowMixin {
  LineArticlesGlimpseWidget(LineOfArticles line, {Key? key}) : super(line);

  @override
  Widget build(BuildContext context) {
    final ticketsStore = Provider.of<TicketsStore>(context, listen: true);
    final closingsStore = Provider.of<ClosingsStore>(context, listen: false);
    final lineLiveQt = lineStockNow(
        closingsStore.closingStockShops ?? [], ticketsStore.tickets);

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
              ArticleWFrameView(article as ArticleWeebi, true)
          ],
        ),
      ),
    );
  }
}
