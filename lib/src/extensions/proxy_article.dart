import 'package:models_weebi/weebi_models.dart';

extension GetProxiesMinQt on Iterable<ProxyArticle> {
  Iterable<ArticleWMinQt> getProxiesMinQt(Iterable<LineOfArticles> lines) {
    final articlesW = <ArticleWMinQt>[];
    for (final line in lines) {
      for (final proxy in this) {
        if (line.id == proxy.proxyLineId) {
          for (final article in line.articles) {
            if (article.id == proxy.proxyArticleId) {
              final aWMinQt = ArticleWMinQt(proxy.minimumUnitPerBasket,
                  lineId: article.lineId,
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
