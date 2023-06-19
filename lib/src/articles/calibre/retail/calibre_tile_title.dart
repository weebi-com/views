// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart' show ArticleCalibre;
import 'package:models_weebi/utils.dart';
import 'package:views_weebi/src/articles/photo.dart';

class ArticleRetailCalibreTileTitle extends StatelessWidget {
  final ArticleCalibre articleCalibre;
  final double calibreStockNow;
  final Color iconColor;
  const ArticleRetailCalibreTileTitle(
      this.articleCalibre, this.calibreStockNow, this.iconColor,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          height: 42,
          width: 42,
          child: Hero(
            tag: '${articleCalibre.id}.${articleCalibre.articles.first.id}',
            child: ClipOval(
                child: ArticlePhotoWidget(articleCalibre.articles.first)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            '#${articleCalibre.id}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              articleCalibre.title,
              style: articleCalibre.articles.first.status == false
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : const TextStyle(),
            ),
          ),
        ),
        if (articleCalibre.title != '*') //
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(numFormat.format(calibreStockNow)),
              ),
              Icon(Icons.warehouse, color: iconColor),
            ],
          ),
      ],
    );
  }
}
