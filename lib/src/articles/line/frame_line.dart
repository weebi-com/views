// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/stock.dart';

import 'package:models_weebi/weebi_models.dart';
import 'package:views_weebi/src/articles/line/line_basket/glimpse_line_basket.dart';

import 'package:views_weebi/views_line.dart';

class ArticleLineFrame extends StatelessWidget {
  const ArticleLineFrame({
    Key key,
    @required this.contextMain,
    @required this.line,
    @required this.ticketsInvoker,
    @required this.closingStockShopsInvoker,
  }) : super(key: key);

  final BuildContext contextMain;
  final ArticleLine line;
  final TicketsInvoker ticketsInvoker;
  final ClosingStockShopsInvoker closingStockShopsInvoker;

  @override
  Widget build(BuildContext context) {
    if (line.isBasket ?? false) {
      // if basket then one basket only !
      // whole purpose of using line is to aggregated stock levels with different conditioning
      // since there is no stock coherence it would make no sense !
      // use categories instead when they are eventually available
      return LineSingleABasketGlimpseWidget(
          line, ticketsInvoker, closingStockShopsInvoker);
    } else {
      if (line.isSingleArticle ?? false) {
        return LineArticleSingleGlimpseWidget(
            line, ticketsInvoker, closingStockShopsInvoker);
      } else {
        return LineArticlesGlimpseWidget(
            line, ticketsInvoker, closingStockShopsInvoker);
      }
    }
  }
}
