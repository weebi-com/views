import 'package:closing/closing.dart';
import 'package:models_base/utils.dart';
import 'package:models_weebi/weebi_models.dart';
import 'package:views_weebi/stock.dart';

mixin LineArticleStockNowMixin on LineArticleStockAbstract {
  //like productStockRange, but not need to declare fake start/end Dates
  // also better to distinguish analytics from operations
  double lineStockNow(
    Iterable<ClosingStockShop> closingStockShops,
    Iterable<TicketWeebi> tickets,
  ) {
    // this is stock now, not on the time range selected in dashboard
    // including the selected shop in the view OR all shops
    // but no dashboard
    final start = WeebiDates.defaultFirstDate;
    final end = DateTime.now();
    return lineClosingFinalQt(closingStockShops, end: end) +
        lineTkQtIn(tickets, start, end) -
        lineTkQtOut(tickets, start, end);
  }
}
