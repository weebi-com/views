// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:mixins_weebi/mobx_store_closing.dart';
import 'package:models_weebi/utils.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart' show ArticleBasket, ArticleLine;
import 'package:mixins_weebi/stock.dart';

import 'package:views_weebi/routes.dart';
import 'package:mixins_weebi/stores.dart' show ArticlesStore;
import 'package:mixins_weebi/stores.dart' show TicketsStore;
import 'package:views_weebi/src/articles/photo.dart';
import 'package:views_weebi/styles.dart' show WeebiColors;
import 'package:views_weebi/views_article_basket.dart';

class ArticleBasketGlimpseWidget extends ArticleStockStatelessAbstract
    with ArticleBasketRealizableNow {
  final ArticleLine line;

  const ArticleBasketGlimpseWidget(this.line, ArticleBasket article)
      : super(article);

  @override
  Widget build(BuildContext context) {
    final ticketsStore = Provider.of<TicketsStore>(context, listen: false);
    final closingsStore = Provider.of<ClosingsStore>(context, listen: false);
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);

    final doTheGroove = articleBasketWrapThem(
        closingsStore.closingStockShops ?? [],
        ticketsStore.tickets,
        articlesStore.lines,
        WeebiDates.defaultFirstDate,
        DateTime.now());
    int realizableBaskets = basketsRealizableNow(doTheGroove);

    return ArticleBasketGlimpseWidStateFul(article, realizableBaskets);
  }
}

class ArticleBasketGlimpseWidStateFul extends StatefulWidget {
  final ArticleBasket article;
  final int realizableBaskets;
  const ArticleBasketGlimpseWidStateFul(this.article, this.realizableBaskets,
      {Key key})
      : super(key: key);

  @override
  State<ArticleBasketGlimpseWidStateFul> createState() =>
      _ArticleBasketGlimpseWidStateFulState();
}

class _ArticleBasketGlimpseWidStateFulState
    extends State<ArticleBasketGlimpseWidStateFul> {
  Color iconColor;
  @override
  void initState() {
    super.initState();
    iconColor = Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Navigator.of(context).pushNamed(ArticleDetailRoute.generateRoute(
            '${widget.article.lineId}', '${widget.article.id}'));
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
            widget.article.photo != null && widget.article.photo.isNotEmpty
                ? Hero(
                    tag: '${widget.article.lineId}.${widget.article.id}',
                    child: CircleAvatar(
                        foregroundImage: PhotoWidget(widget.article).getImage
                            as ImageProvider),
                  )
                : CircleAvatar(backgroundColor: Colors.transparent),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                '#${widget.article.lineId}.${widget.article.id}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Expanded(
              child: Text(
                '${widget.article.fullName}',
                style: widget.article.status == false
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : const TextStyle(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.realizableBaskets > 0
                  ? '${numFormat?.format(widget.realizableBaskets)}' // réalisables
                  : ''),
            ),
            // SizedBox(width: ScreenUtil().setWidth(10)),
            Icon(Icons.shopping_basket, color: iconColor)
          ],
        ),
        children: <Widget>[
          for (final proxy in (widget.article).proxies)
            ProxyArticleGlimpseFrameWidget(proxy)
        ],
      ),
    );
  }
}
