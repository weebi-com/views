// Flutter imports:
import 'package:flutter/material.dart';
import 'package:models_weebi/utils.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart' show ArticleBasket;
import 'package:views_weebi/src/articles/photo.dart';

class LineSingleArticleBasketTileTitle extends StatelessWidget {
  final ArticleBasket articleBasket;
  final int realizableBaskets;
  final Color iconColor;
  const LineSingleArticleBasketTileTitle(
      this.articleBasket, this.realizableBaskets, this.iconColor,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        articleBasket.photo.isEmpty
            ? CircleAvatar(backgroundColor: Colors.transparent)
            : Hero(
                tag: articleBasket.calibreId,
                child: CircleAvatar(
                  foregroundImage:
                      PhotoWidget(articleBasket).getImage as ImageProvider,
                ),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            '#${articleBasket.calibreId}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${articleBasket.fullName}',
              style: articleBasket.status == false
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
                  ? '${numFormat.format(realizableBaskets)}'
                  : ''),
            ),
            Icon(Icons.shopping_basket, color: iconColor)
          ],
        ),
      ],
    );
  }
}
