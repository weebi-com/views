// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_store_article.dart';
import 'package:models_weebi/weebi_models.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router2/rc_router2.dart';

class LineOfArticleUpdateRouteUnfinished extends RcRoute {
  static String routePath = '/line_update/:lineId';
  // how about products/product_update/:id ?

  static String generateRoute(String lineId) =>
      RcRoute.generateRoute(routePath, pathParams: {'lineId': lineId});

  LineOfArticleUpdateRouteUnfinished()
      : super(path: LineOfArticleUpdateRouteUnfinished.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['lineId'];
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final line = articlesStore.lines
        .firstWhere((line) => '${line.id}' == lineId, orElse: () {
      throw 'no line match $lineId';
    });
    return Provider.value(
      value: line,
      child: LineOfArticleUpdateViewFakeFrame(line),
    );
  }
}

class LineOfArticleUpdateViewFakeFrame extends StatelessWidget {
  final ArticleLines line;
  const LineOfArticleUpdateViewFakeFrame(this.line, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO here implement LineOfAUpdateView(line: line)
    return Container();
  }
}
