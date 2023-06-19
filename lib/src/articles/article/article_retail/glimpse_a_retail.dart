// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/stock.dart';
import 'package:models_weebi/utils.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart' show ArticleRetail;
import 'package:views_weebi/routes.dart';
import 'package:views_weebi/src/articles/photo.dart';
import 'package:views_weebi/styles.dart' show WeebiColors;

class ArticleRetailGlimpseWidget extends StatelessWidget {
  final ArticleRetail article;
  final ArticleRetailStockNow articleRetailStockNow;
  const ArticleRetailGlimpseWidget(
    this.article,
    this.articleRetailStockNow,
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(
            ArticleCalibreRetailDetailRoute.generateRoute(
                '${article.calibreId}',
                articleId: '${article.id}'));
      },
      onLongPress: () {
        Navigator.of(context).pushNamed(ArticleDetailRoute.generateRoute(
            '${article.calibreId}', '${article.id}'));
      },
      leading: const CircleAvatar(backgroundColor: Colors.transparent),
      title: Row(
        children: <Widget>[
          SizedBox(
            height: 42,
            width: 42,
            child: ClipOval(
              child: ArticlePhotoWidget(article),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              '#${article.calibreId}.${article.id}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              article.fullName,
              style: (article.status) == false
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : const TextStyle(),
            ),
          ),
          if (articleRetailStockNow.stockNow != 0.0) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(article.weight != 1
                  ? '${numFormat.format(article.weight)}p. x ${numFormat.format(articleRetailStockNow.stockNow)}'
                  : numFormat.format(articleRetailStockNow.stockNow)),
            ),
            const Icon(Icons.warehouse, color: WeebiColors.grey)
          ],
        ],
      ),
    );
  }
}
