// Flutter imports:
import 'package:flutter/material.dart';
import 'package:models_weebi/common.dart';
import 'package:models_weebi/utils.dart';

// Package imports:

import 'package:models_weebi/weebi_models.dart'
    show ArticleBasket, LineOfArticles;
import 'package:views_weebi/src/articles/line/actions.dart';
import 'package:views_weebi/src/routes/articles/article_basket_create.dart';
import 'package:views_weebi/src/routes/articles/article_create.dart';
import 'package:views_weebi/src/routes/articles/line_articles.dart';
import 'package:views_weebi/views_article.dart';
import 'package:views_weebi/styles.dart' show WeebiColors, WeebiTextStyles;
import 'package:mixins_weebi/stock.dart';

import 'package:views_weebi/widgets.dart';

Gradient getLineGradient(LineOfArticles line) {
  if (line.status) {
    return const LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment(0.0, 0.9),
      colors: [Color.fromRGBO(245, 245, 245, 1), Colors.black],
      tileMode: TileMode.clamp,
    );
  } else {
    return const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment(0.0, 0.9),
        colors: [Color.fromRGBO(230, 81, 0, 1), Colors.black],
        tileMode: TileMode.clamp);
  }
}

class LineArticlesDetailWidget extends LineArticleStockAbstract
    with LineArticleStockNowMixin {
  final int initArticle;
  final bool isShopLocked;
  LineArticlesDetailWidget(
    LineOfArticles line,
    TicketsInvoker ticketsInvoker,
    ClosingStockShopsInvoker closingStockShopsInvoker, {
    this.isShopLocked = false,
    this.initArticle = 1,
    super.key,
  }) : super(line, ticketsInvoker, closingStockShopsInvoker);

  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    final lineLiveQt = lineStockNow;

    return Scaffold(
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 31),
            child: Align(
              alignment: Alignment.bottomRight,
              child: isShopLocked
                  ? const SizedBox()
                  : (line.isBasket ?? false)
                      ? FloatingActionButton(
                          heroTag: 'créer un panier',
                          tooltip: 'créer un panier d\'article',
                          backgroundColor: Colors.amber[700],
                          onPressed: () => Navigator.of(context).pushNamed(
                              ArticleBasketCreateRoute.generateRoute(
                                  '${line.id}')),
                          child: const Icon(Icons.library_add,
                              color: Colors.white),
                        )
                      : FloatingActionButton(
                          heroTag: 'créer un article',
                          tooltip: 'créer un article',
                          backgroundColor: Colors.orange[700],
                          onPressed: () => Navigator.of(context).pushNamed(
                              ArticleCreateRoute.generateRoute('${line.id}')),
                          child: const Icon(
                            Icons.library_add,
                            color: Colors.white,
                          ),
                        ),
            ),
          )
        ],
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: WeebiColors.grey),
          onPressed: () =>
              Navigator.of(context).pushNamed(ArticleLinesRoute.routePath),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        title: Row(
          children: [
            Text('#${line.id}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
                overflow: TextOverflow.ellipsis),
            if (line.isBasket == false)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${numFormat?.format(lineLiveQt)}',
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
            const Icon(Icons.warehouse, color: Colors.black),
          ],
        ),
        actions: actionsLineWidget(context, isShopLocked, line),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment(0.0, 1),
              colors: [Color(0xFF20272B), Colors.white],
              tileMode: TileMode.clamp),
        ),
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              // if (line.isBasket) ...[
              //   if (line.isSingleArticle)
              //     LineSingleABasketGlimpseWidget(line)
              //   else
              //     LineABasketGlimpseWidgetStateful(line)
              // ] else ...[
              //   if (line.isSingleArticle)
              //     LineSingleArticleGlimpseWidget(line)
              //   else
              //     LineArticlesGlimpseWidget(line)
              // ],

              if (!(line.isBasket ?? false)) ...[
                if (line.stockUnit != StockUnit.unit)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FieldValueWidget(
                      const Icon(Icons.style),
                      const Text("Unité"),
                      SelectableText(
                        line.stockUnit.stockUnitText,
                        style: WeebiTextStyles.blackAndBold,
                      ),
                    ),
                  ),
                if (line.status == false)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FieldValueWidget(
                      const Icon(Icons.pause),
                      const Text("Articles désactivés le "),
                      SelectableText(
                        "${line.statusUpdateDate}",
                        style: WeebiTextStyles.blackAndBold,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                SlidableCardsV2(
                  line,
                  articleId: initArticle,
                )
              ] else ...[
                for (final article in line.articles)
                  ArticleBasketGlimpseWidgetFakeFrame(
                      line, article as ArticleBasket)
              ],
            ],
          ),
        ),
      ),
    );
  }
}

typedef ActionsWidget = List<Widget> Function(
    BuildContext context, bool isShopLocked);

class ArticleBasketGlimpseWidgetFakeFrame extends StatelessWidget {
  final LineOfArticles line;
  final ArticleBasket articleBasket;
  const ArticleBasketGlimpseWidgetFakeFrame(this.line, this.articleBasket,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO implement ArticleBasketGlimpseWidget(line,articleBasket)
    return Container();
  }
}
