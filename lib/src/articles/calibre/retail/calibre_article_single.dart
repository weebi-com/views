// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:views_weebi/routes.dart';

// Project imports:
import 'package:mixins_weebi/stock.dart';
import 'package:views_weebi/src/articles/calibre/retail/calibre_tile_title.dart';

import 'package:views_weebi/styles.dart' show WeebiColors;

class ArticleRetailSingleCalibreGlimpseWidget extends StatelessWidget {
  final ArticleCalibreRetailStock calibreRetStock;
  const ArticleRetailSingleCalibreGlimpseWidget(this.calibreRetStock);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(ArticleDetailRoute.generateRoute(
            '${calibreRetStock.articleCalibreRetail.id}',
            '${calibreRetStock.articleCalibreRetail.articles.first.id}'));
      },
      onLongPress: () {
        Navigator.of(context).pushNamed(ArticleDetailRoute.generateRoute(
            '${calibreRetStock.articleCalibreRetail.id}',
            '${calibreRetStock.articleCalibreRetail.articles.first.id}'));
      },
      child: ListTile(
          trailing: const Icon(Icons.ac_unit, color: Colors.transparent),
          title: ArticleRetailCalibreTileTitle(
              calibreRetStock.articleCalibreRetail,
              calibreRetStock.stockNow,
              WeebiColors.grey,
              key: Key('#${calibreRetStock.articleCalibreRetail.id}'))),
    );
  }
}
