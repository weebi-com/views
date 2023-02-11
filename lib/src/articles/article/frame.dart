// Flutter imports:
import 'package:closing/closing_store.dart';
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_stores/tickets.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart' show Article;
import 'package:mixins_weebi/stock.dart';

import 'articleW_detail_section.dart';
import 'article_glimpse.dart';

class ArticleWFrameView extends ArticleStockStatelessAbstract<Article>
    with ArticleStockNowMixin<Article> {
  final bool isGlimpse;
  const ArticleWFrameView(Article article, this.isGlimpse, {super.key})
      : super(article);

  @override
  Widget build(BuildContext context) {
    final ticketsStore = Provider.of<TicketsStore>(context, listen: false);
    final closingsStore = Provider.of<ClosingsStore>(context, listen: false);
    double articleLiveQt = articleStockNow(
        closingsStore.closingStockShops ?? [],
        ticketsStore.tickets); //articleQuantityIn - articleQuantityOut;

    return isGlimpse
        ? ArticleWGlimpse2Widget(article, articleLiveQt)
        : ArticleWDetailSection(article, articleLiveQt);
  }
}
