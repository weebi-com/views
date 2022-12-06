import 'package:models_weebi/base.dart' show ArticleAbstract;
import 'package:models_weebi/weebi_models.dart';

// * this is a joker,
// github fails to fetch latest verison of updated weebi dependencies
// so i'm putting this meanwhile

extension Shoubidou on LineOfArticles<ArticleAbstract> {
  String get getArticleTitle {
    if (isBasket ?? false) {
      if (isSingleArticle) {
        return 'Panier d\'article';
      } else {
        return 'Paniers d\'articles';
      }
    } else {
      if (isSingleArticle) {
        return 'Article';
      } else {
        return 'Articles';
      }
    }
  }
}
