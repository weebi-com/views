// Flutter imports:
import 'package:flutter/material.dart';
import 'package:models_weebi/weebi_models.dart';

// Package imports:
import 'package:views_weebi/routes.dart';

// Project imports:
import 'package:mixins_weebi/stock.dart';
import 'package:views_weebi/src/articles/calibre/retail/calibre_tile_title.dart';

import 'package:views_weebi/styles.dart' show WeebiColors;

class CalibreSingleRetailGlimpseWidget<AR extends ArticleRetail>
    extends StatelessWidget {
  final CalibreRetailStockNow<AR> calibreRetStock;
  const CalibreSingleRetailGlimpseWidget(this.calibreRetStock);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(ArticleDetailRoute.generateRoute(
            '${calibreRetStock.calibreRetail.id}',
            '${calibreRetStock.calibreRetail.articles.first.id}'));
      },
      onLongPress: () {
        Navigator.of(context).pushNamed(ArticleDetailRoute.generateRoute(
            '${calibreRetStock.calibreRetail.id}',
            '${calibreRetStock.calibreRetail.articles.first.id}'));
      },
      child: ListTile(
          trailing: const Icon(Icons.ac_unit, color: Colors.transparent),
          title: ArticleRetailCalibreTileTitle(calibreRetStock.calibreRetail,
              calibreRetStock.stockNow, WeebiColors.grey,
              key: Key('#${calibreRetStock.calibreRetail.id}'))),
    );
  }
}
