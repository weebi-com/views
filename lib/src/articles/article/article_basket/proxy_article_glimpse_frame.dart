// Flutter imports:
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:models_weebi/weebi_models.dart';
import 'package:provider/provider.dart';
import 'package:mixins_weebi/stores.dart' show ArticlesStore;
import 'package:views_weebi/src/articles/article/article_basket/proxy_glimpse.dart';

class ProxyArticleGlimpseFrameWidget extends StatelessWidget {
  final ProxyArticle proxy;
  const ProxyArticleGlimpseFrameWidget(this.proxy, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final _line =
        articlesStore.lines.firstWhereOrNull((l) => l.id == proxy.proxyLineId);
    final _article = _line.articles.firstWhere(
        (a) => a.lineId == proxy.proxyLineId && a.id == proxy.proxyArticleId);
    return ProxyAGlimpseWidget(article: _article, proxy: proxy);
  }
}
