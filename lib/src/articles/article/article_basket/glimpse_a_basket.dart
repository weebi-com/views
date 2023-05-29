// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:models_weebi/utils.dart';

// Project imports:
import 'package:mixins_weebi/stock.dart';

import 'package:views_weebi/routes.dart';
import 'package:views_weebi/src/articles/photo.dart';
import 'package:views_weebi/styles.dart' show WeebiColors;
import 'package:views_weebi/views_article_basket.dart';

class ArticleBasketGlimpseWidStateFul extends StatefulWidget {
  final ArticleBasketRealizablekNow articleStock;
  const ArticleBasketGlimpseWidStateFul(this.articleStock, {Key? key})
      : super(key: key);

  @override
  State<ArticleBasketGlimpseWidStateFul> createState() =>
      _ArticleBasketGlimpseWidStateFulState();
}

class _ArticleBasketGlimpseWidStateFulState
    extends State<ArticleBasketGlimpseWidStateFul> {
  Color iconColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Navigator.of(context).pushNamed(ArticleDetailRoute.generateRoute(
            '${widget.articleStock.article.calibreId}',
            '${widget.articleStock.article.id}'));
      },
      child: ExpansionTile(
        onExpansionChanged: (bool expanding) => setState(() =>
            iconColor = expanding ? WeebiColors.buttonColor : WeebiColors.grey),
        leading: CircleAvatar(backgroundColor: Colors.transparent),
        subtitle: Row(
          children: [
            CircleAvatar(backgroundColor: Colors.transparent),
            const Text('panier d\'articles'),
          ],
        ),
        title: Row(
          children: <Widget>[
            widget.articleStock.article.photo.isNotEmpty
                ? Hero(
                    tag:
                        '${widget.articleStock.article.calibreId}.${widget.articleStock.article.id}',
                    child: CircleAvatar(
                        foregroundImage:
                            PhotoWidget(widget.articleStock.article).getImage
                                as ImageProvider),
                  )
                : CircleAvatar(backgroundColor: Colors.transparent),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                '#${widget.articleStock.article.calibreId}.${widget.articleStock.article.id}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Expanded(
              child: Text(
                '${widget.articleStock.article.fullName}',
                style: (widget.articleStock.article.status) == false
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : const TextStyle(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.articleStock.stockRealizablesBasketsNow > 0
                  ? '${numFormat.format(widget.articleStock.stockRealizablesBasketsNow)}' // réalisables
                  : ''),
            ),
            // SizedBox(width: ScreenUtil().setWidth(10)),
            Icon(Icons.shopping_basket, color: iconColor)
          ],
        ),
        children: <Widget>[
          for (final proxy in (widget.articleStock.article).proxies)
            ProxyArticleGlimpseFrameWidget(proxy)
        ],
      ),
    );
  }
}
