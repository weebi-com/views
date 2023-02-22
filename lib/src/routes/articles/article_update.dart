// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_stores/articles.dart';
import 'package:models_weebi/weebi_models.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router/rc_router.dart';

class ArticleUpdateRouteUnfinished extends RcRoute {
  static String routePath = '/article_update/:lineId/:articleId';

  static String generateRoute(String lineId, String articleId) =>
      RcRoute.generateRoute(routePath,
          pathParams: {'lineId': lineId, 'articleId': articleId});

  ArticleUpdateRouteUnfinished()
      : super(path: ArticleUpdateRouteUnfinished.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['lineId'] ?? '';
    final articleId = routeParams.pathParameters['articleId'] ?? '';
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final line = articlesStore.lines
        .firstWhere((p) => p.id.toString() == lineId, orElse: () {
      throw 'no line match $lineId';
    });
    final article = line.articles.firstWhere(
        (a) => '${a.lineId}' == lineId && '${a.id}' == articleId, orElse: () {
      throw 'no line match $lineId';
    });
    final isBasket = line.isBasket ?? false;
    if (isBasket) {
      articlesStore.clearAllArticleMinQtInSelected();
    }
    return Provider.value(
      value: article,
      child: isBasket
          ? ArticleBasketUpdateViewFakeFrame(article as ArticleBasket)
          : ArticleUpdateViewFakeFrame(article as Article),
    );
  }
}

class ArticleUpdateViewFakeFrame extends StatelessWidget {
  final Article article;
  const ArticleUpdateViewFakeFrame(this.article, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO implement ArticleWUpdateView(article:article) here
    print('implement ArticleWUpdateView(article:article) here');
    return Container();
  }
}

class ArticleBasketUpdateViewFakeFrame extends StatelessWidget {
  final ArticleBasket articleBasket;
  const ArticleBasketUpdateViewFakeFrame(this.articleBasket, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO implement ArticleBasketUpdateView() here
    print('implement ArticleBasketUpdateView() here');
    return Container();
  }
}
