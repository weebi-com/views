import 'package:closing/closing.dart' show ClosingStockShop;
import 'package:closing/closing_extensions.dart' show StockItUpTillYaGetEnough;
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:models_weebi/base.dart';
import 'package:models_weebi/utils.dart' show DateRange;
import 'package:models_weebi/weebi_models.dart' show TicketWeebi;
import 'package:models_weebi/extensions.dart';

abstract class ArticleStockStatelessAbstract<A extends ArticleAbstract>
    extends StatelessWidget {
  final A article;
  const ArticleStockStatelessAbstract(this.article, {Key? key})
      : super(key: key);

  double articleTkQtIn(
    Iterable<TicketWeebi> tickets,
    DateTime start,
    DateTime end,
  ) {
    final articleQuantityIn =
        tickets.stockArticleInput(article, range: DateRange(start, end));
    return articleQuantityIn;
  }

  double articleTkQtOut(
      Iterable<TicketWeebi> tickets, DateTime start, DateTime end) {
    final articleQuantityOut =
        tickets.stockArticleOutput(article, range: DateRange(start, end));
    return articleQuantityOut;
  }

  double articleStockRemaining(Iterable<ClosingStockShop> cStockShops,
      Iterable<TicketWeebi> tickets, DateTime start, DateTime end) {
    return articleClosingFinalQt(cStockShops, end: end) +
        articleTkQtIn(tickets, start, end) -
        articleTkQtOut(tickets, start, end);
  }

  double articleStockDiffOverTimeRange(
    Iterable<ClosingStockShop> cStockShops,
    Iterable<TicketWeebi> tickets,
    DateTime start,
    DateTime end,
  ) {
    return _clStockShopArticleQtInTimeRange(cStockShops, start, end) -
        _clStockShopArticleQtOutTimeRange(cStockShops, start, end) +
        articleTkQtIn(tickets, start, end) -
        articleTkQtOut(tickets, start, end);
  }

  // not used yet
  Observable<double> articleClosingDiffOverTimeRange(
      Iterable<ClosingStockShop> cStockShops, DateTime start, DateTime end) {
    return Observable(
        _clStockShopArticleQtInTimeRange(cStockShops, start, end) -
            _clStockShopArticleQtOutTimeRange(cStockShops, start, end));
  }

  double _clStockShopArticleQtInTimeRange(
      Iterable<ClosingStockShop> closingStockShops,
      DateTime start,
      DateTime end) {
    final articleQuantityIn = closingStockShops
        .stockShopArticleQtInTimeRangeForWeebi(article, DateRange(start, end));
    return articleQuantityIn;
  }

  double _clStockShopArticleQtOutTimeRange(
      Iterable<ClosingStockShop> closingStockShops,
      DateTime start,
      DateTime end) {
    final articleQuantityOut = closingStockShops
        .stockShopArticleQtOutTimeRangeForWeebi(article, DateRange(start, end));
    return articleQuantityOut;
  }

  double articleClosingFinalQt(Iterable<ClosingStockShop> closingStockShops,
      {DateTime? end}) {
    return closingStockShops
        .stockShopArticleFinalQuantityAbsoluteForWeebi(article, end: end);
  }
}
