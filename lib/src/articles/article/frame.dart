// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

// Project imports:
import 'package:models_weebi/weebi_models.dart' show ArticleRetail;
import 'package:mixins_weebi/stock.dart';

import 'articleW_detail_section.dart';
import 'article_glimpse.dart';

class ArticleWFrameView extends ArticleStockStatelessAbstract<ArticleRetail>
    with ArticleStockNowMixin<ArticleRetail> {
  final bool isGlimpse;
  final TicketsInvoker ticketsInvoker;
  final ClosingStockShopsInvoker closingStockShopsInvoker;
  const ArticleWFrameView(
    ArticleRetail article,
    this.isGlimpse,
    this.ticketsInvoker,
    this.closingStockShopsInvoker,
  ) : super(article);

  @override
  Widget build(BuildContext context) {
    final double articleLiveQt =
        articleStockNow(closingStockShopsInvoker.call(), ticketsInvoker.call());

    return isGlimpse
        ? ArticleWGlimpse2Widget(article, articleLiveQt)
        : ArticleWDetailSection(article, articleLiveQt);
  }
}
