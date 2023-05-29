// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/stock.dart';

// Package imports:

// Project imports:

import 'detail_section_article_retail.dart';
import 'glimpse_a_retail.dart';

class ArticleRetailFrameView extends StatelessWidget {
  final bool isGlimpse;
  final ArticleRetailStockNow articleStock;
  const ArticleRetailFrameView(this.articleStock, this.isGlimpse);

  @override
  Widget build(BuildContext context) {
    return isGlimpse
        ? ArticleRetailGlimpseWidget(
            articleStock.article, articleStock.stockNow)
        : ArticleRetailDetailSection(
            articleStock.article, articleStock.stockNow);
  }
}
