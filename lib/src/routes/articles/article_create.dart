// Flutter imports:
import 'package:flutter/material.dart';
import 'package:models_weebi/weebi_models.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router/rc_router.dart';

// Project imports:
import 'package:mixins_weebi/stores.dart' show ArticlesStore;

class ArticleCreateRoute extends RcRoute {
  static String routePath = '/lines/:id/article_create';

  static String generateRoute(String id) =>
      RcRoute.generateRoute(routePath, pathParams: {'id': id});

  ArticleCreateRoute() : super(path: ArticleCreateRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['id'];
    // print('lineId $lineId');
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final article = articlesStore.lines
        .firstWhere((line) => line.id.toString() == lineId, orElse: () {
      throw 'no LineArticle matching line.id $lineId';
    });
    return Provider.value(
      value: article,
      child: ArticleCreateViewFakeFrame(article),
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