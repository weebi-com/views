// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:mixins_weebi/mobx_store_closing.dart';
import 'package:models_weebi/utils.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:mixins_weebi/stock.dart';
import 'package:models_weebi/weebi_models.dart' show ArticleLine;

import 'package:views_weebi/routes.dart';
import 'package:mixins_weebi/stores.dart' show ArticlesStore, TicketsStore;
import 'package:views_weebi/src/articles/line/line_basket/tile_title_line_basket.dart';
import 'package:views_weebi/styles.dart' show WeebiColors;

class LineSingleABasketGlimpseWidget extends LineArticleStockAbstract
    with LineSingleArticleBasketRealizableNow {
  LineSingleABasketGlimpseWidget(
      ArticleLine line,
      TicketsInvoker ticketsInvoker,
      ClosingStockShopsInvoker closingStockShopsInvoker,
      {Key key})
      : super(line, ticketsInvoker, closingStockShopsInvoker);

  @override
  Widget build(BuildContext context) {
    final ticketsStore = Provider.of<TicketsStore>(context, listen: true);
    final closingsStore = Provider.of<ClosingsStore>(context, listen: false);
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final doTheGroove = articleBasketWrapThem(
        closingsStore.closingStockShops ?? [],
        ticketsStore.tickets,
        articlesStore.lines,
        WeebiDates.defaultFirstDate,
        DateTime.now());
    int realizableBaskets = basketsRealizableNow(doTheGroove);

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(ArticleDetailRoute.generateRoute(
            '${line.id}', '${line.articles.first.id}'));
      },
      child: ListTile(
        trailing:
            const Icon(Icons.ac_unit, color: Colors.transparent), // on purpose
        title: LineSingleArticleBasketTileTitle(
          line,
          realizableBaskets,
          WeebiColors.grey,
          key: Key('${line.id}'),
        ),
      ),
    );
  }
}
