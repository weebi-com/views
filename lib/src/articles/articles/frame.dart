// Flutter imports:
import 'package:closing/closing_store.dart';
import 'package:flutter/material.dart';

// Package imports:

// Project imports:
import 'package:models_weebi/weebi_models.dart' show ArticleWeebi;
// import 'package:provider/provider.dart';
// import 'package:weebi/src/stores/tickets.dart';
import 'package:weebi/src/views/main_views/articles/article_weebi/articleW_detail_section.dart';
import 'package:views_weebi/stock.dart';
import 'package:weebi/src/views/main_views/articles/article_weebi/article_glimpse.dart';

class ArticleWFrameView extends ArticleStockStatelessAbstract<ArticleWeebi>
    with ArticleStockNowMixin<ArticleWeebi> {
  final bool isGlimpse;
  const ArticleWFrameView(article, this.isGlimpse, {super.key})
      : super(article);

  @override
  Widget build(BuildContext context) {
    final ticketsStore = Provider.of<TicketsStore>(context, listen: false);
    final closingsStore = Provider.of<ClosingsStore>(context, listen: false);
    double articleLiveQt = articleStockNow(
        closingsStore.closingStockShops ?? [], ticketsStore.tickets);
    final double articleLiveQt = 0.0;

    return isGlimpse
        ? ArticleWGlimpse2Widget(article, articleLiveQt)
        : ArticleWDetailSection(article, articleLiveQt);
  }
}
