// Flutter imports:
import 'package:flutter/material.dart';
import 'package:models_weebi/utils.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart' show ArticleRetail;
import 'package:views_weebi/routes.dart';
import 'package:views_weebi/src/articles/photo.dart';
import 'package:views_weebi/styles.dart' show WeebiColors;

class ArticleWGlimpse2Widget extends StatelessWidget {
  final ArticleRetail article;
  final double articleLiveQt;
  const ArticleWGlimpse2Widget(
    this.article,
    this.articleLiveQt,
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(ArticleLineDetailRoute.generateRoute(
            '${article.lineId}',
            articleId: '${article.id}')); // TODO isShopLocked
      },
      onLongPress: () {
        Navigator.of(context).pushNamed(ArticleDetailRoute.generateRoute(
            '${article.lineId}', '${article.id}'));
      },
      leading: const CircleAvatar(backgroundColor: Colors.transparent),
      title: Row(
        children: <Widget>[
          SizedBox(
            height: 42,
            width: 42,
            child: ClipOval(
              child: PhotoWidget(article),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              '#${article.lineId}.${article.id}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              article.fullName,
              style: article.status == false
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : const TextStyle(),
            ),
          ),
          if (articleLiveQt != 0.0) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(article.weight != 1
                  ? '${numFormat.format(article.weight)}p. x ${numFormat.format(articleLiveQt)}'
                  : numFormat.format(articleLiveQt)),
            ),
            const Icon(Icons.warehouse, color: WeebiColors.grey)
          ],
        ],
      ),
    );
  }
}
