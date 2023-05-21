import 'package:models_weebi/weebi_models.dart';

extension GetProxiesMinQt on Iterable<ProxyArticle> {
  Iterable<ArticleWMinQt> getProxiesMinQt(Iterable<ArticleCalibre> calibres) {
    final articlesW = <ArticleWMinQt>[];
    for (final calibre in calibres) {
      for (final proxy in this) {
        if (calibre.id == proxy.proxyCalibreId) {
          for (final article in calibre.articles) {
            if (article.id == proxy.proxyArticleId) {
              final aWMinQt = ArticleWMinQt(proxy.minimumUnitPerBasket,
                  calibreId: article.calibreId,
                  id: article.id,
                  weight: article.weight,
                  fullName: article.fullName,
                  creationDate: article.creationDate,
                  updateDate: article.updateDate);
              articlesW.add(aWMinQt);
            }
          }
        }
      }
    }
    return articlesW;
  }
}
