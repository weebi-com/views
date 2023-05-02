// Flutter imports:
import 'package:mixins_weebi/mobx_store_closing.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:mixins_weebi/stock.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart'
    show AggregateProxies, ArticleBasket;

import 'package:mixins_weebi/stores.dart' show ArticlesStore;
import 'package:mixins_weebi/stores.dart' show TicketsStore;
import 'package:models_weebi/utils.dart';
import 'package:views_weebi/src/articles/article/proxy_article_glimpse_frame.dart';
import 'package:views_weebi/styles.dart';
import 'package:views_weebi/widgets.dart';

// same widget for article and article basket
class ArticleBasketDetailSectionWidget extends ArticleStockStatelessAbstract
    with ArticleBasketRealizableNow {
  const ArticleBasketDetailSectionWidget(ArticleBasket article)
      : super(article);

  @override
  Widget build(BuildContext context) {
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final ticketsStore = Provider.of<TicketsStore>(context, listen: false);
    final closingsStore = Provider.of<ClosingsStore>(context, listen: false);

    final doTheGroove = articleBasketWrapThem(
        closingsStore.closingStockShops ?? [],
        ticketsStore.tickets,
        articlesStore.lines,
        WeebiDates.defaultFirstDate,
        DateTime.now());
    int realizableBaskets = basketsRealizableNow(doTheGroove);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if ((article as ArticleBasket).discountAmountSalesOnly > 0) ...[
          FieldValueWidget(
            const Icon(Icons.info),
            const Text("Prix de vente cumulés des articles"),
            SelectableText(
              numFormat?.format((article as ArticleBasket)
                  .getProxiesListWithPriceAndCost(
                      articlesStore.linesPalpableNoBasket)
                  .totalPrice),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          FieldValueWidget(
            const Icon(Icons.redeem),
            const Text("Réduction sur le total"),
            SelectableText(
              numFormat
                  .format((article as ArticleBasket).discountAmountSalesOnly),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        FieldValueWidget(
          const Icon(Icons.local_offer, color: Colors.teal),
          const Text("Prix de vente du panier"),
          SelectableText(
            numFormat?.format((article as ArticleBasket)
                    .getProxiesListWithPriceAndCost(
                        articlesStore.linesPalpableNoBasket)
                    .totalPrice -
                (article as ArticleBasket).discountAmountSalesOnly),
            // * prefer above to have dynamic pricing as user might update or remove articleProxies in the basket
            // below only provides static price
            // widget.article.getProxiesListWithPriceAndCost(lines).totalPrice
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text('Articles contenus dans le panier : ',
              style: WeebiTextStyles.supportSmall),
        ),
        if (realizableBaskets > 0)
          FieldValueWidget(
            const Icon(Icons.shopping_basket),
            const Text("Nombre de paniers réalisables : "),
            SelectableText(
              '${numFormat?.format(realizableBaskets)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
        // * consider displaying this is in better looking fashion
        for (final proxy in (article as ArticleBasket).proxies)
          ProxyArticleGlimpseFrameWidget(proxy),
        Divider(),
      ],
    );
  }
}
