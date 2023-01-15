// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/stock/abstracts/line_stock_abstract.dart';
import 'package:models_base/src/base/article_base.dart';
import 'package:models_weebi/weebi_models.dart';

import 'package:views_weebi/views_line.dart';

// this is specifically for web
// I do not want to include basket here (lazy and cautious)
// so made a dedicated frame for Article (i.e. ArticleWeebi)
// this can be accessed from LinesArticlesViewWIP articles_main_view_wip.dart
// also for web only

class LinesFrameW extends StatelessWidget {
  const LinesFrameW({
    super.key,
    required this.contextMain,
    required this.index,
    required this.lines,
    required this.ticketsInvoker,
    required this.closingStockShopsInvoker,
  });

  final BuildContext contextMain;
  final int index;
  final List<LineOfArticles<ArticleAbstract>> lines;

  final TicketsInvoker ticketsInvoker;
  final ClosingStockShopsInvoker closingStockShopsInvoker;

  @override
  Widget build(BuildContext context) {
    if (lines[index].isSingleArticle) {
      return LineSingleArticleGlimpseWidget(
          lines[index], ticketsInvoker, closingStockShopsInvoker);
    } else {
      return LineArticlesGlimpseWidget(
          lines[index], ticketsInvoker, closingStockShopsInvoker);
    }
  }
}
