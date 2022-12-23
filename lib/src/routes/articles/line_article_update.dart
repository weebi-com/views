// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_stores/articles.dart';
import 'package:models_weebi/weebi_models.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router/rc_router.dart';

class LineArticleUpdateRoute extends RcRoute {
  static String routePath = '/line_update/:id';
  // how about products/product_update/:id ?

  static String generateRoute(String id) =>
      RcRoute.generateRoute(routePath, pathParams: {'id': id});

  LineArticleUpdateRoute() : super(path: LineArticleUpdateRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['id'];
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final line = articlesStore.lines
        .firstWhere((line) => '${line.id}' == lineId, orElse: null);
    return Provider.value(
      value: line,
      child: LineOfArticleUpdateViewFakeFrame(line),
    );
  }
}

class LineOfArticleUpdateViewFakeFrame extends StatelessWidget {
  final LineOfArticles line;
  const LineOfArticleUpdateViewFakeFrame(this.line, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO here implement LineOfAUpdateView(line: line)
    return Container();
  }
}
