// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart' show ArticleLine;
import 'package:models_base/utils.dart';
import 'package:views_weebi/src/articles/photo.dart';

class LineSingleArticleBasketTileTitle extends StatelessWidget {
  final ArticleLine line;
  final int realizableBaskets;
  final Color iconColor;
  const LineSingleArticleBasketTileTitle(
      this.line, this.realizableBaskets, this.iconColor,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        line?.articles?.first?.photo == null ||
                line.articles.first.photo.isEmpty
            ? CircleAvatar(backgroundColor: Colors.transparent)
            : Hero(
                tag: line.id,
                child: CircleAvatar(
                  foregroundImage: PhotoWidget(line.articles.first).getImage
                      as ImageProvider,
                ),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            '#${line.id}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${line.title}', // (${line.stockUnitText})
              style: line.articles.first.status == false
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : const TextStyle(),
            ),
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(realizableBaskets > 0
                  ? '${numFormat?.format(realizableBaskets)}'
                  : ''),
            ),
            Icon(Icons.shopping_basket, color: iconColor)
          ],
        ),
      ],
    );
  }
}
