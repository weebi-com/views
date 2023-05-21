// Flutter imports:
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:models_weebi/weebi_models.dart';
import 'package:provider/provider.dart';
import 'package:mixins_weebi/stores.dart' show ArticlesStore;
import 'package:views_weebi/src/articles/article/article_basket/proxy_glimpse.dart';

class ProxyArticleGlimpseFrameWidget extends StatelessWidget {
  final ProxyArticle proxy;
  const ProxyArticleGlimpseFrameWidget(this.proxy, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final _calibre = articlesStore.calibres
        .firstWhereOrNull((l) => l.id == proxy.proxyCalibreId);
    if (_calibre == null) {
      print('_calibre not found for proxy.proxyLineId ${proxy.proxyCalibreId}');
    }
    if (_calibre?.articles == null) {
      print(
          '_calibre?.articles empty for proxy.proxyLineId ${proxy.proxyCalibreId}');
    }
    final _article = _calibre?.articles.firstWhere((a) =>
        a.calibreId == proxy.proxyCalibreId && a.id == proxy.proxyArticleId);
    if (_article == null) {
      print(
          '_article not found for proxy.proxyLineId ${proxy.proxyCalibreId} && proxy.proxyArticleId ${proxy.proxyArticleId}');
    }
    return ProxyAGlimpseWidget(
        article: _article as ArticleRetail, proxy: proxy);
  }
}
