// Flutter imports:
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:mixins_weebi/stock.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart' show AggregateProxies;

import 'package:models_weebi/utils.dart';
import 'package:views_weebi/src/articles/article/article_basket/proxy_article_glimpse_frame.dart';
import 'package:views_weebi/styles.dart';
import 'package:views_weebi/widgets.dart';

class ArticleBasketDetailSectionWidget extends StatelessWidget {
  final ArticleBasketRealizablekNow articleStock;
  const ArticleBasketDetailSectionWidget(this.articleStock, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Observer(builder: (context) {
          return FieldValueWidget(
            const Icon(Icons.local_offer, color: Colors.teal),
            const Text("Prix de vente du panier :"),
            SelectableText(
              numFormat.format((articleStock.article)
                      .getProxiesListWithPriceAndCost(
                          articleStock.calibresNoQuickspend)
                      .totalPrice -
                  (articleStock.article).discountAmountSalesOnly),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }),
        if ((articleStock.article).discountAmountSalesOnly > 0) ...[
          FieldValueWidget(
            const Icon(Icons.redeem),
            const Text("Réduction sur le total"),
            SelectableText(
              numFormat.format((articleStock.article).discountAmountSalesOnly),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Observer(builder: (context) {
            return FieldValueWidget(
              const Icon(Icons.info),
              const Text("Prix de vente sans réduction"),
              SelectableText(
                numFormat.format((articleStock.article)
                    .getProxiesListWithPriceAndCost(
                        articleStock.calibresNoQuickspend)
                    .totalPrice),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }),
        ],
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text('Articles contenus dans le panier : ',
              style: WeebiTextStyles.supportSmall),
        ),
        if (articleStock.stockRealizablesBasketsNow > 0)
          FieldValueWidget(
            const Icon(Icons.shopping_basket),
            const Text("Nombre de paniers réalisables : "),
            SelectableText(
              '${numFormat.format(articleStock.stockRealizablesBasketsNow)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
        // * display this is in better looking fashion
        for (final proxy in (articleStock.article).proxies)
          ProxyArticleGlimpseFrameWidget(proxy),
        Divider(),
      ],
    );
  }
}
