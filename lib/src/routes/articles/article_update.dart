// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_stores/articles.dart';
import 'package:models_weebi/weebi_models.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router/rc_router.dart';

class ArticleUpdateRoute extends RcRoute {
  static String routePath = '/article_update/:lineId/:articleId';

  static String generateRoute(String lineId, String articleId) =>
      RcRoute.generateRoute(routePath,
          pathParams: {'lineId': lineId, 'articleId': articleId});

  ArticleUpdateRoute() : super(path: ArticleUpdateRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['lineId'];
    final articleId = routeParams.pathParameters['articleId'];
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final line = articlesStore.lines
        .firstWhere((p) => p.id?.toString() == lineId, orElse: null);
    final isBasket = line.isBasket ?? false;
    if (isBasket) {
      articlesStore.clearAllArticleMinQtInSelected();
    }
    return Provider.value(
      value: line.articles
          .firstWhere((a) => a.id?.toString() == articleId, orElse: null),
      child: isBasket
          ? ArticleBasketUpdateViewFakeFrame(line.articles.firstWhere(
              (a) => a.id?.toString() == articleId,
              orElse: null) as ArticleBasket)
          : ArticleUpdateViewFakeFrame(
              line.articles.firstWhere((a) => a.id?.toString() == articleId,
                  orElse: null) as Article,
            ),
    );
  }
}

class ArticleUpdateViewFakeFrame extends StatelessWidget {
  final Article article;
  const ArticleUpdateViewFakeFrame(this.article, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO implement ArticleWUpdateView(article:article) here
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
    return Container();
  }
}
