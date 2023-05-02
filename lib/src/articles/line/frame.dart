// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/stock.dart';

import 'package:models_weebi/weebi_models.dart';

import 'package:views_weebi/views_line.dart';

// this is specifically for web
// I do not want to include basket here (lazy and cautious)
// so made a dedicated frame for Article (i.e. ArticleWeebi)
// this can be accessed from LinesArticlesViewWIP articles_main_view_wip.dart
// also for web only

class LinesFrameW extends StatelessWidget {
  final BuildContext contextMain;
  final ArticleLines line;

  final TicketsInvoker ticketsInvoker;
  final ClosingStockShopsInvoker closingStockShopsInvoker;
  const LinesFrameW({
    @required this.contextMain,
    @required this.line,
    @required this.ticketsInvoker,
    @required this.closingStockShopsInvoker,
  });

  @override
  Widget build(BuildContext context) {
    if (line.isSingleArticle ?? false) {
      return ArticleSingleGlimpseWidget(
          line, ticketsInvoker, closingStockShopsInvoker);
    } else {
      return LineArticlesGlimpseWidget(
          line, ticketsInvoker, closingStockShopsInvoker);
    }
  }
}
