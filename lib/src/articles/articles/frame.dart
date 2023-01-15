// Flutter imports:
import 'package:closing/closing_store.dart';
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_stores/tickets.dart';

// Package imports:

// Project imports:
import 'package:models_weebi/weebi_models.dart' show Article, ArticleWeebi;
import 'package:provider/provider.dart';
import 'package:mixins_weebi/stock.dart';
import 'package:views_weebi/views_article.dart';

class ArticleWFrameView extends ArticleStockStatelessAbstract<Article>
    with ArticleStockNowMixin<Article> {
  final bool isGlimpse;
  const ArticleWFrameView(article, this.isGlimpse, {super.key})
      : super(article);

  @override
  Widget build(BuildContext context) {
    final ticketsStore = Provider.of<TicketsStore>(context, listen: false);
    final closingsStore = Provider.of<ClosingsStore>(context, listen: false);
    double articleLiveQt = articleStockNow(
        closingsStore.closingStockShops ?? [], ticketsStore.tickets);
    // final double articleLiveQt = 0.0;

    return isGlimpse
        ? ArticleWGlimpse2Widget(article, articleLiveQt)
        : ArticleWDetailSection(article, articleLiveQt);
  }
}
