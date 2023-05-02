// Flutter imports:
import 'package:mixins_weebi/mobx_store_closing.dart';
import 'package:flutter/material.dart';
import 'package:models_weebi/utils.dart';

// Package imports:

// Project imports:
import 'package:models_weebi/weebi_models.dart' show Article, ProxyArticle;
import 'package:provider/provider.dart';
import 'package:mixins_weebi/stock.dart';
import 'package:views_weebi/routes.dart';
import 'package:mixins_weebi/stores.dart' show TicketsStore;
import 'package:views_weebi/styles.dart' show WeebiColors;

class ProxyAGlimpseWidget extends ArticleStockStatelessAbstract
    with ArticleStockNowMixin {
  final Article article;
  final ProxyArticle proxy;

  ProxyAGlimpseWidget({@required this.article, @required this.proxy})
      : super(article);

  @override
  Widget build(BuildContext context) {
    final ticketsStore = Provider.of<TicketsStore>(context, listen: false);
    final closingsStore = Provider.of<ClosingsStore>(context, listen: false);

    double articleLiveQt = articleStockNow(
        closingsStore.closingStockShops ?? [], ticketsStore.tickets);

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(ProxyADetailRoute.generateRoute(
            '${proxy.productId}', '${proxy.articleId}', '${proxy.id}'));
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
                      text: '${proxy.lineId}.${proxy.articleId}.${proxy.id}',
                      style: const TextStyle(fontSize: 8, color: Colors.grey),
                    ),
                    TextSpan(
                      text: '\n${proxy.proxyLineId}.${proxy.proxyArticleId}',
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
            if (articleLiveQt != 0.0) ...[
              Text('${numFormat?.format(articleLiveQt)}'),
              const Icon(Icons.warehouse, color: WeebiColors.grey)
            ],
          ],
        ),
        trailing: Text('qt min: ${proxy.minimumUnitPerBasket}'),
      ),
    );
  }
}
