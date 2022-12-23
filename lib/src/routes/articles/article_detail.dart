// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_stores/articles.dart';
import 'package:models_weebi/weebi_models.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router/rc_router.dart';
import 'package:views_weebi/src/articles/line/line_detail.dart';
import 'package:views_weebi/views_article.dart';

typedef ActionsArticleWidget = List<Widget> Function(
    BuildContext context, bool isShopLocked, Article article);

class DeferAction {
  final ActionsArticleWidget actionsArticleWidget;
  DeferAction(this.actionsArticleWidget);
}

class ArticleDetailRoute extends RcRoute {
  static String routePath = '/lines/:lineId/:articleId';

  static String generateRoute(String lineId, String articleId) =>
      RcRoute.generateRoute(routePath,
          pathParams: {'lineId': lineId, 'articleId': articleId});

  ArticleDetailRoute() : super(path: ArticleDetailRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['lineId'] ?? '';
    final articleId = routeParams.pathParameters['articleId'];
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final line = articlesStore.lines
        .firstWhere((l) => l?.id == int.tryParse(lineId), orElse: null);
    return Provider.value(
      value: line.articles
          .firstWhere((a) => '${a?.id}' == articleId, orElse: null),
      child: ArticleDetailWidget(line.articles
          .firstWhere((a) => '${a?.id}' == articleId, orElse: null)),
    );
  }
}
