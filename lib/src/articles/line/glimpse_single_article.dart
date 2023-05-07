// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:views_weebi/routes.dart';

// Project imports:
import 'package:mixins_weebi/stock.dart';
import 'package:models_weebi/weebi_models.dart' show ArticleLine;
import 'package:views_weebi/src/articles/line/tile_title_glimpse.dart';

import 'package:views_weebi/styles.dart' show WeebiColors;

class LineArticleSingleGlimpseWidget extends LineArticleStockAbstract
    with LineArticleStockNowMixin {
  LineArticleSingleGlimpseWidget(
    ArticleLine line,
    TicketsInvoker ticketsInvoker,
    ClosingStockShopsInvoker closingsInvoker, {
    key,
  }) : super(
          line,
          ticketsInvoker,
          closingsInvoker,
        );

  @override
  Widget build(BuildContext context) {
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
          title: LineArticleTileTitle(line, lineStockNow, WeebiColors.grey,
              key: Key('#${line.id}'))),
    );
  }
}
