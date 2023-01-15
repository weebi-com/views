// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:models_base/src/base/article_base.dart';
import 'package:models_weebi/weebi_models.dart';
import 'package:provider/provider.dart';
import 'package:views_weebi/src/articles/lines/glimpse_multiple_articles.dart';
import 'package:views_weebi/src/articles/lines/glimpse_single_article.dart';
import 'package:weebi/src/views/main_views/articles/line/line_basket/glimpse_multiple_articles_b.dart';
import 'package:weebi/src/views/main_views/articles/line/line_basket/glimpse_single_article_b.dart';
import 'package:mixins_weebi/mobx_stores/tickets.dart';
import 'package:views_weebi/views.dart';
import 'package:closing/closing_store.dart';

class LinesFrameW extends StatelessWidget {
  const LinesFrameW({
    super.key,
    required this.contextMain,
    required this.index,
    required this.lines,
  });

  final BuildContext contextMain;
  final int index;
  final List<LineOfArticles<ArticleAbstract>> lines;

  @override
  Widget build(BuildContext context) {
    // TODO check this is really better for perfs and split archi
    // consider mapping there before
    final ticketsStore = Provider.of<TicketsStore>(context, listen: false);
    final closingsStore = Provider.of<ClosingsStore>(context, listen: false);

    if (lines[index].isSingleArticle) {
      return LineSingleArticleGlimpseWidget(
        lines[index],
        () => ticketsStore.tickets,
        () => closingsStore.closingStockShops,
      );
    } else {
      return LineArticlesGlimpseWidget(
        lines[index],
        () => ticketsStore.tickets,
        () => closingsStore.closingStockShops,
      );
    }
  }
}
