// Flutter imports:
import 'package:closing/closing_store.dart';
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_stores/articles.dart';
import 'package:mixins_weebi/mobx_stores/tickets.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router/rc_router.dart';
// TODO ?
// $ dart pub outdated --mode=null-safety
//and then
// $ dart pub upgrade --null-safety
import 'package:views_weebi/views.dart' show LineArticlesDetailWidget;
import 'package:views_weebi/views_line.dart';

// Project imports:

class LineArticlesDetailRoute extends RcRoute {
  static String routePath = '/lines/:id/:articleId/';

  static String generateRoute(String id, {String articleId = '1'}) =>
      RcRoute.generateRoute(routePath,
          pathParams: {'id': id, 'articleId': articleId});

  LineArticlesDetailRoute() : super(path: LineArticlesDetailRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['id'];
    final articleId = routeParams.pathParameters['articleId'];
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final ticketsStore = Provider.of<TicketsStore>(context, listen: false);
    final closingsStore = Provider.of<ClosingsStore>(context, listen: false);
    final line = articlesStore.lines
        .firstWhere((product) => product.id.toString() == lineId);

    // TODO check this is really helpful
    // consider using a map before to filter
    return Provider.value(
      value: line,
      child: LineArticlesDetailWidget(
        line,
        () => ticketsStore.tickets,
        () => closingsStore.closingStockShops,
        initArticle: int.parse(articleId!),
      ),
    );
  }
}
