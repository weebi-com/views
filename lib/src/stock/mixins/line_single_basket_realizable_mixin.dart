import 'package:closing/closing.dart';
import 'package:closing/extensions/closing_stock_shops.dart';
import 'package:models_weebi/utils.dart';

import 'package:models_weebi/weebi_models.dart';
import 'package:models_weebi/extensions.dart';
import 'package:views_weebi/stock.dart';

mixin LineSingleArticleBasketRealizableNow on LineArticleStockAbstract {
  int basketsRealizableNow(Iterable<BasketWrapper> thoseGoddamWrappers) {
    final wrapRealizableBasketsTo = <int>[];
    for (final w in thoseGoddamWrappers) {
      final thatWrapRealizableBasket =
          (w.stockRemaining / w.minimumUnitPerBasket)
              .floor(); // round to lowest int
      wrapRealizableBasketsTo.add(thatWrapRealizableBasket);
    }
    wrapRealizableBasketsTo.sort();
    return wrapRealizableBasketsTo.first;
  }

  Iterable<BasketWrapper> articleBasketWrapThem(
    Iterable<ClosingStockShop> closingStockShops,
    Iterable<TicketWeebi> tickets,
    Iterable<LineOfArticles> lines,
    DateTime start, // useless
    DateTime end,
  ) {
    if (line.articles.first is ArticleBasket) {
      final articlesAndMinimQt = lines.articleBasketWrapThemExt(
          (line.articles.first as ArticleBasket), start, end);
      // find the level of article stock remaining
      // divide it by the minimum qt in basket
      final articlesAndRemainingStock = <BasketWrapper>[];
      for (final wrapper in articlesAndMinimQt) {
        final stockRemaining = articleStockRemaining(
            closingStockShops, tickets, start, end,
            wrappedArticle: wrapper.article);
        final articleAndRemainingStock =
            wrapper.copyWith(stockRemaining: stockRemaining);
        articlesAndRemainingStock.add(articleAndRemainingStock);
      }
      return articlesAndRemainingStock;
    } else {
      throw 'not articleBasket';
    }
  }

  double articleStockRemaining(Iterable<ClosingStockShop> closingsStockShops,
      Iterable<TicketWeebi> tickets, DateTime start, DateTime end,
      {required ArticleWeebi wrappedArticle}) {
    return _articleClosingFinalQt(closingsStockShops, wrappedArticle,
            end: end) +
        _articleTkQtIn(tickets, wrappedArticle, start, end) -
        _articleTkQtOut(tickets, wrappedArticle, start, end);
  }

  double _articleClosingFinalQt(
      Iterable<ClosingStockShop> closingStockShops, ArticleWeebi wrappedArticle,
      {DateTime? end}) {
// stockShopArticleFinalQuantityAbsoluteForWeebi
// stockShopArticleQtOutTimeRangeForWeebi
    return closingStockShops.stockShopArticleFinalQuantityAbsoluteForWeebi(
        wrappedArticle,
        end: end);
  }

  double _articleTkQtIn(
    Iterable<TicketWeebi> tickets,
    ArticleWeebi wrappedArticle,
    DateTime start,
    DateTime end,
  ) {
    final articleQuantityIn =
        tickets.stockArticleInput(wrappedArticle, range: DateRange(start, end));
    return articleQuantityIn;
  }

  double _articleTkQtOut(
    Iterable<TicketWeebi> tickets,
    ArticleWeebi wrappedArticle,
    DateTime start,
    DateTime end,
  ) {
    final articleQuantityOut = tickets.stockArticleOutput(wrappedArticle,
        range: DateRange(start, end));
    return articleQuantityOut;
  }
}
