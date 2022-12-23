// Flutter imports:
import 'package:flutter/material.dart';
import 'package:models_weebi/weebi_models.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router/rc_router.dart';

// Project imports:
import 'package:mixins_weebi/stores.dart' show ArticlesStore;
import 'package:views_weebi/views_article.dart';

class ArticleBasketCreateRoute extends RcRoute {
  static String routePath = '/lines/:id/article_basket_create';

  static String generateRoute(String id) =>
      RcRoute.generateRoute(routePath, pathParams: {'id': id});

  ArticleBasketCreateRoute() : super(path: ArticleBasketCreateRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final lineId = routeParams.pathParameters['id'];
    // print('lineId $lineId');
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    return Provider.value(
      value: articlesStore.lines
          .firstWhere((line) => line.id.toString() == lineId, orElse: null),
      child: ArticleBasketCreateViewFakeFrame(
        articlesStore.lines
            .firstWhere((line) => line.id.toString() == lineId, orElse: null),
      ),
    );
  }
}

class ArticleBasketCreateViewFakeFrame extends StatelessWidget {
  final LineOfArticles line;
  const ArticleBasketCreateViewFakeFrame(this.line, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO implement ArticleBasketCreateView here
    return Container();
  }
}
