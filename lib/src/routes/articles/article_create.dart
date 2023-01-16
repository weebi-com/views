// Flutter imports:
import 'package:flutter/material.dart';
import 'package:models_weebi/weebi_models.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router/rc_router.dart';

// Project imports:
import 'package:mixins_weebi/stores.dart' show ArticlesStore;

class ArticleCreateRouteUnfinished extends RcRoute {
  static String routePath = '/lines/:lineId/article_create';

  static String generateRoute(String lineId) =>
      RcRoute.generateRoute(routePath, pathParams: {'lineId': lineId});

  ArticleCreateRouteUnfinished()
      : super(path: ArticleCreateRouteUnfinished.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['lineId'];
    // print('lineId $lineId');
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final line = articlesStore.lines
        .firstWhere((line) => line.id.toString() == lineId, orElse: () {
      throw 'no LineArticle matching line.id $lineId';
    });
    return Provider.value(
      value: line,
      child: ArticleCreateViewFakeFrame(line),
    );
  }
}

class ArticleCreateViewFakeFrame extends StatelessWidget {
  final LineOfArticles line;
  const ArticleCreateViewFakeFrame(this.line, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// TODO implement ArticleWCreateView here