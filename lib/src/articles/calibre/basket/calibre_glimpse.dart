// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// Project imports:
import 'package:mixins_weebi/stock.dart';

import 'package:views_weebi/routes.dart';
// import 'package:mixins_weebi/invokers.dart';
import 'package:views_weebi/src/articles/calibre/basket/calibre_tile_title.dart';
import 'package:views_weebi/styles.dart' show WeebiColors;

class CalibreBasketGlimpseWidget extends StatelessWidget {
  final ArticleBasketRealizablekNow calibreBasketStock;
  const CalibreBasketGlimpseWidget(this.calibreBasketStock);

  @override
  Widget build(BuildContext context) {
    calibreBasketStock.stockRealizablesBasketsNow;

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(ArticleDetailRoute.generateRoute(
            '${calibreBasketStock.article.calibreId}',
            '${calibreBasketStock.article.id}'));
      },
      child: ListTile(
        trailing:
            const Icon(Icons.ac_unit, color: Colors.transparent), // on purpose
        title: LineSingleArticleBasketTileTitle(
          calibreBasketStock.article,
          calibreBasketStock.stockRealizablesBasketsNow,
          WeebiColors.grey,
          key: Key('${calibreBasketStock.article.calibreId}'),
        ),
      ),
    );
  }
}
