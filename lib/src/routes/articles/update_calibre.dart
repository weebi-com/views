// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_store_article.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:rc_router2/rc_router2.dart';
import 'package:views_weebi/src/articles/calibre/update_calibre.dart';

class ArticleCalibreUpdateRoute extends RcRoute {
  static String routePath = '/calibre_update/:calibreId';
  // how about products/product_update/:id ?

  static String generateRoute(String calibreId) =>
      RcRoute.generateRoute(routePath, pathParams: {'calibreId': calibreId});

  ArticleCalibreUpdateRoute()
      : super(path: ArticleCalibreUpdateRoute.routePath);

  @override
  Widget build(BuildContext context) {
    final routeParams = Provider.of<RcRouteParameters>(context);
    final calibreId = routeParams.pathParameters['calibreId'];
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final calibre = articlesStore.calibres
        .firstWhere((calibre) => '${calibre.id}' == calibreId, orElse: () {
      throw 'no calibre match $calibreId';
    });
    return Provider.value(
      value: calibre,
      child: ArticleCalibreUpdateView(calibre),
    );
  }
}
