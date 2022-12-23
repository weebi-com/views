// Dart imports:

// Flutter imports:
import 'package:closing/closing_abstraction.dart';
import 'package:flutter/material.dart';
import 'package:mixins_weebi/stock/abstracts/line_stock_abstract.dart';
import 'package:models_base/src/base/article_base.dart';
import 'package:models_weebi/abstractions.dart';
import 'package:models_weebi/weebi_models.dart';
import 'package:views_weebi/src/articles/line/glimpse_multiple_articles.dart';
import 'package:views_weebi/src/articles/line/glimpse_single_article.dart';

import 'package:views_weebi/views_line.dart';

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
