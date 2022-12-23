// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart' show Article;
import 'package:views_weebi/src/routes/articles/line_route.dart';
import 'package:models_base/utils.dart';
import 'package:views_weebi/styles.dart' show WeebiColors;

class ArticleWGlimpse2Widget extends StatelessWidget {
  final Article article;
  final double articleLiveQt;
  const ArticleWGlimpse2Widget(this.article, this.articleLiveQt, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(LineOfArticlesDetailRoute.generateRoute(
            '${article.lineId}', 'false', // TODO isShopLocked
            articleId: '${article.id}'));
        //Navigator.of(context).pushNamed(ArticleDetailRoute.generateRoute(
        //    '${article.productId}', '${article.id}'));
      },
      leading: CircleAvatar(backgroundColor: Colors.transparent),
      title: Row(
        children: <Widget>[
          article.photo != null && article.photo!.isNotEmpty
              ? Hero(
                  tag: article.photo!,
                  child: CircleAvatar(
                      foregroundImage:
                          AssetImage('assets/photos/${article.photo}')),
                )
              : CircleAvatar(backgroundColor: Colors.transparent),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              '#${article.lineId}.${article.id}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              '${article.fullName}',
              style: article.status == false
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : const TextStyle(),
            ),
          ),
          if (articleLiveQt != 0.0) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(article.weight != 1
                  ? '${numFormat?.format(article.weight)}p. x ${numFormat?.format(articleLiveQt)}'
                  : '${numFormat?.format(articleLiveQt)}'),
            ),
            const Icon(Icons.warehouse, color: WeebiColors.grey)
          ],
        ],
      ),
    );
  }
}
