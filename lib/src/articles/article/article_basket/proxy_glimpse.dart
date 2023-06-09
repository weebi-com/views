// Flutter imports:
import 'package:mixins_weebi/mobx_store_closing.dart';
import 'package:flutter/material.dart';
import 'package:models_weebi/utils.dart';

// Package imports:

// Project imports:
import 'package:models_weebi/weebi_models.dart'
    show ArticleRetail, ProxyArticle;
import 'package:provider/provider.dart';
import 'package:mixins_weebi/stock.dart';
import 'package:views_weebi/routes.dart';
import 'package:mixins_weebi/stores.dart' show TicketsStore;
import 'package:views_weebi/styles.dart' show WeebiColors;

class ProxyAGlimpseWidget extends StatelessWidget {
  final ArticleRetail article;
  final ProxyArticle proxy;

  ProxyAGlimpseWidget({required this.article, required this.proxy});

  @override
  Widget build(BuildContext context) {
    final ticketsStore = Provider.of<TicketsStore>(context, listen: false);
    final closingsStore = Provider.of<ClosingsStore>(context, listen: false);

    final articleStock = ArticleRetailStockNow(
        article: article,
        ticketsInvoker: () => ticketsStore.tickets,
        closingStockShopsInvoker: () => closingsStore.closingStockShops);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(ArticleDetailRoute.generateRoute(
            '${proxy.proxyCalibreId}', '${proxy.proxyArticleId}'));
      },
      child: ListTile(
        leading: SizedBox(
          width: 50,
          height: 50,
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              maxLines: 2,
              text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: <InlineSpan>[
                    TextSpan(
                      text: '${proxy.calibreId}.${proxy.articleId}.${proxy.id}',
                      style: const TextStyle(fontSize: 8, color: Colors.grey),
                    ),
                    TextSpan(
                      text: '\n${proxy.proxyCalibreId}.${proxy.proxyArticleId}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ]),
            ),
          ),
        ),
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text('${article.fullName}'),
            ),
            if (articleStock.stockNow != 0.0) ...[
              Text('${numFormat.format(articleStock.stockNow)}'),
              const Icon(Icons.warehouse, color: WeebiColors.grey)
            ],
          ],
        ),
        trailing: Text('qt min: ${proxy.minimumUnitPerBasket}'),
      ),
    );
  }
}
