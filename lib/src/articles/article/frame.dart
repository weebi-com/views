// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

// Project imports:
import 'package:models_weebi/weebi_models.dart' show Article;
import 'package:mixins_weebi/stock.dart';

import 'articleW_detail_section.dart';
import 'article_glimpse.dart';

class ArticleWFrameView extends ArticleStockStatelessAbstract<Article>
    with ArticleStockNowMixin<Article> {
  final bool isGlimpse;
  final TicketsInvoker ticketsInvoker;
  final ClosingStockShopsInvoker closingStockShopsInvoker;
  const ArticleWFrameView(Article article, this.isGlimpse, this.ticketsInvoker,
      this.closingStockShopsInvoker,
      {super.key})
      : super(article);

  @override
  Widget build(BuildContext context) {
    final double articleLiveQt =
        articleStockNow(closingStockShopsInvoker.call(), ticketsInvoker.call());

    return isGlimpse
        ? ArticleWGlimpse2Widget(article, articleLiveQt)
        : ArticleWDetailSection(article, articleLiveQt);
  }
}
