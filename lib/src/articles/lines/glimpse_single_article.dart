// Flutter imports:
import 'package:closing/closing_abstraction.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:closing/closing_store.dart';
import 'package:models_weebi/abstractions.dart';
import 'package:provider/provider.dart';
import 'package:views_weebi/src/articles/lines/tile_title_glimpse.dart';

// Project imports:
import 'package:mixins_weebi/stock.dart';
import 'package:models_weebi/weebi_models.dart' show LineOfArticles;
import 'package:weebi/src/routes/articles/article_detail.dart';
import 'package:weebi/src/stores/tickets.dart';
import 'package:views_weebi/styles.dart' show WeebiColors;

class LineSingleArticleGlimpseWidget extends LineArticleStockAbstract
    with LineArticleStockNowMixin {
  LineSingleArticleGlimpseWidget(
      LineOfArticles line,
      MobxTicketsStoreCreator mobxTicketsStoreCreator,
      MobxClosingStoreCreator mobxClosingStoreCreator,
      {super.key})
      : super(
          line,
          mobxTicketsStoreCreator,
          mobxClosingStoreCreator,
        );

  @override
  Widget build(BuildContext context) {
    final lineLiveQt = lineStockNow;

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
