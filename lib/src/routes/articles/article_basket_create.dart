// Flutter imports:
import 'package:flutter/material.dart';
import 'package:models_weebi/weebi_models.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router2/rc_router2.dart';

// Project imports:
import 'package:mixins_weebi/stores.dart' show ArticlesStore;

class ArticleBasketCreateRouteUnfinished extends RcRoute {
  static String routePath = '/lines/:lineId/article_basket_create';

  static String generateRoute(String lineId) =>
      RcRoute.generateRoute(routePath, pathParams: {'lineId': lineId});

  ArticleBasketCreateRouteUnfinished()
      : super(path: ArticleBasketCreateRouteUnfinished.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['lineId'];
    // print('lineId $lineId');
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    return Provider.value(
      value: articlesStore.lines.firstWhere(
          (line) => line.id.toString() == lineId,
          orElse: () => throw ""),
      child: ArticleBasketCreateViewFakeFrame(
        articlesStore.lines.firstWhere((line) => line.id.toString() == lineId,
            orElse: () => throw ""),
      ),
    );
  }
}

class ArticleBasketCreateViewFakeFrame extends StatelessWidget {
  final ArticleLines line;
  const ArticleBasketCreateViewFakeFrame(this.line, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO implement ArticleBasketCreateView here
    return Container();
  }
}
