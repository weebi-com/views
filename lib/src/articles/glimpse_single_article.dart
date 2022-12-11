// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:closing/closing_store.dart';
import 'package:provider/provider.dart';
import 'package:views_weebi/src/articles/tile_title_glimpse.dart';

// Project imports:
import 'package:views_weebi/stock.dart';
import 'package:models_weebi/weebi_models.dart' show LineOfArticles;
import 'package:weebi/src/routes/articles/article_detail.dart';
import 'package:weebi/src/stores/tickets.dart';
import 'package:views_weebi/styles.dart' show WeebiColors;

class LineSingleArticleGlimpseWidget extends LineArticleStockAbstract
    with LineArticleStockNowMixin {
  LineSingleArticleGlimpseWidget(LineOfArticles line, {Key? key}) : super(line);

  @override
  Widget build(BuildContext context) {
    final ticketsStore = Provider.of<TicketsStore>(context, listen: true);
    final closingsStore = Provider.of<ClosingsStore>(context, listen: false);
    final lineLiveQt = lineStockNow(
        closingsStore.closingStockShops ?? [], ticketsStore.tickets);

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(ArticleDetailRoute.generateRoute(
            '${line.id}', '${line.articles.first.id}'));
      },
      onLongPress: () {
        Navigator.of(context).pushNamed(ArticleDetailRoute.generateRoute(
            '${line.id}', '${line.articles.first.id}'));
      },
      child: ListTile(
          trailing: const Icon(Icons.ac_unit, color: Colors.transparent),
          title: LineArticleTileTitle(line, lineLiveQt, WeebiColors.grey,
              key: Key('#${line.id}'))),
    );
  }
}
