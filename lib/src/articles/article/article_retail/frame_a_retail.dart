// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

// Project imports:
import 'package:models_weebi/weebi_models.dart' show ArticleRetail;
import 'package:mixins_weebi/stock.dart';

import 'detail_section_article_retail.dart';
import 'glimpse_a_retail.dart';

class ArticleRetailFrameView
    extends ArticleStockStatelessAbstract<ArticleRetail>
    with ArticleStockNowMixin<ArticleRetail> {
  final bool isGlimpse;
  final TicketsInvoker ticketsInvoker;
  final ClosingStockShopsInvoker closingStockShopsInvoker;
  const ArticleRetailFrameView(
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
        ? ArticleRetailGlimpseWidget(article, articleLiveQt)
        : ArticleRetailDetailSection(article, articleLiveQt);
  }
}
