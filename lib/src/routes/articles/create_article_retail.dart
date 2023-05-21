// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router2/rc_router2.dart';

// Project imports:
import 'package:mixins_weebi/stores.dart' show ArticlesStore;
import 'package:views_weebi/src/articles/article/article_retail/create_a_retail.dart';

class ArticleRetailCreateRoute extends RcRoute {
  static String routePath = '/calibres/:calibreId/article_retail_create';

  static String generateRoute(String calibreId) =>
      RcRoute.generateRoute(routePath, pathParams: {'calibreId': calibreId});

  ArticleRetailCreateRoute() : super(path: ArticleRetailCreateRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final calibreId = routeParams.pathParameters['calibreId'];
    // print('calibreId $calibreId');
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final calibre = articlesStore.calibres.firstWhere(
        (calibre) => calibre.id.toString() == calibreId, orElse: () {
      throw 'no calibreArticle matching calibre.id $calibreId';
    });
    return Provider.value(
      value: calibre,
      child: ArticleCreateView(calibre: calibre),
    );
  }
}
