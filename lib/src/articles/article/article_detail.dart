// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/stock.dart';
import 'package:models_weebi/base.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart'
    show ArticleRetail, ArticleBasket, ArticleLine;
import 'package:views_weebi/extensions.dart';
import 'package:views_weebi/routes.dart';
import 'package:views_weebi/src/articles/article/article_basket/detail_section_basket_widget.dart';
import 'package:views_weebi/src/articles/article/buttons.dart';
import 'package:views_weebi/src/articles/line/buttons_line.dart';
import 'package:views_weebi/src/articles/photo.dart';
import 'package:views_weebi/views_article.dart';
import 'package:mixins_weebi/stores.dart' show ArticlesStore;
import 'package:views_weebi/styles.dart' show WeebiColors, weebiTheme;

import 'package:views_weebi/widgets.dart';

// same widget for article and article basket
class ArticleDetailWidget<A extends ArticleAbstract> extends StatelessWidget {
  final A article;
  final bool isShopLocked;
  final TicketsInvoker ticketsInvoker;
  final ClosingStockShopsInvoker closingStockShopsInvoker;
  const ArticleDetailWidget(
    this.article,
    this.ticketsInvoker,
    this.closingStockShopsInvoker, {
    this.isShopLocked = false,
  });

  Future<ArticleRetail> deactivateArticleW(ArticlesStore articlesStore) async {
    final deactivated = (article as ArticleRetail)
        .copyWith(statusUpdateDate: DateTime.now(), status: false);
    return await articlesStore.updateArticleRetail<ArticleRetail>(deactivated);
  }

  Future<ArticleBasket> deactivateArticleB(ArticlesStore articlesStore) async {
    final deactivated = (article as ArticleBasket)
        .copyWith(statusUpdateDate: DateTime.now(), status: false);
    return await articlesStore.updateArticleRetail<ArticleBasket>(deactivated);
  }

  Future<dynamic> reactivateArticleW(ArticlesStore articlesStore) async {
    final deactivated = (article as ArticleRetail)
        .copyWith(statusUpdateDate: DateTime.now(), status: true);
    return await articlesStore.updateArticleRetail<ArticleRetail>(deactivated);
  }

  Future<dynamic> reactivateArticleB(ArticlesStore articlesStore) async {
    final deactivated = (article as ArticleBasket)
        .copyWith(statusUpdateDate: DateTime.now(), status: true);
    return await articlesStore.updateArticleRetail<ArticleBasket>(deactivated);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    ArticleLine line = articlesStore.lines
        .firstWhere((element) => element.id == article.lineId);

    return Scaffold(
      floatingActionButton: isShopLocked ||
              // ! only one basket per line
              (line.isBasket ?? false)
          ? const SizedBox()
          : MultipleFABs(
              line.isSingleArticle == false
                  ? const SizedBox()
                  : CreateArticleWithinLineButton(line.id,
                      isShopLocked: isShopLocked),
              (article.status ?? true)
                  ? FloatingActionButton(
                      heroTag: 'deactivate',
                      tooltip: 'Désactiver l\'article',
                      backgroundColor: WeebiColors.greyLight,
                      onPressed: () async {
                        final d = article is ArticleRetail
                            ? await deactivateArticleW(articlesStore)
                            : await deactivateArticleB(articlesStore);
                        Navigator.of(context).popAndPushNamed(
                            ArticleDetailRoute.generateRoute(
                                '${d.lineId}', '${d.id}'));
                      },
                      child: const Icon(Icons.pause, color: Colors.white))
                  : FloatingActionButton(
                      heroTag: 'reactivate',
                      tooltip: 'Réactiver l\'article',
                      backgroundColor: WeebiColors.orange,
                      child: const Icon(Icons.play_arrow, color: Colors.white),
                      onPressed: () async {
                        final d = article is ArticleRetail
                            ? await reactivateArticleW(articlesStore)
                            : await reactivateArticleB(articlesStore);
                        Navigator.of(context).popAndPushNamed(
                            ArticleDetailRoute.generateRoute(
                                '${d.lineId}', '${d.id}'));
                      }),
            ),
      body: CustomScrollView(
        //scrollBehavior: ,
        controller: controller,
        shrinkWrap: false,
        slivers: <Widget>[
          SliverAppBar(
              //forceElevated: true,
              // toolbarHeight: context.screenHeight * .12,
              //*ncollapsedHeight: context.screenHeight * .08,
              //floating: true,
              //snap: true,
              elevation: 3,
              expandedHeight: context.screenHeight * .47,
              centerTitle: false,
              stretch: true,
              pinned: true,
              backgroundColor: weebiTheme.scaffoldBackgroundColor,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                collapseMode: CollapseMode.parallax,
                // TODO update with photo widget here
                background: article.photo == null || article.photo.isEmpty
                    ? (line.isBasket ?? false)
                        ? const Icon(Icons.shopping_basket,
                            color: WeebiColors.grey)
                        : const Icon(Icons.article)
                    : Hero(
                        tag: '${article.lineId}.${article.id}',
                        child: PhotoWidget(article),
                      ),
                title: Text(
                    '#${line.id}.${article.id} ${(article.status ?? true) ? '' : ' \ndésactivé'}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                    overflow: TextOverflow.ellipsis),
              ),
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: WeebiColors.grey),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip),
              actions: isShopLocked
                  ? []
                  : [
                      EditArticleButton(article),
                      DeleteArticleButton<A>(article),
                    ]),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FieldValueWidget(
                const Icon(Icons.subject),
                const Text("Nom de l'article : "),
                SelectableText(
                  article.fullName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: line.isBasket
                  ? ArticleBasketDetailSectionWidget(article as ArticleBasket)
                  : ArticleRetailFrameView(article as ArticleRetail, false,
                      ticketsInvoker, closingStockShopsInvoker),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: ArticleDetailComplementarySection(article),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 84)),

          // * consider displaying tickets when this is solved
          //Divider(height: 12),
          // display latest tickets ?
          // SliverPadding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10),
          //   sliver: SliverList(
          //     delegate: SliverChildBuilderDelegate(
          //       (BuildContext context, int index) =>
          //           //for (final article in line.articles)
          //           line.articles[index] is ArticleBasket
          //               ? ArticleBasketGlimpseWidget(
          //                   line, line.articles[index])
          //               : ArticleGlimpseWidget(line, line.articles[index]),
          //       childCount: line.articles.length,
          //     ),
          //   ),
          // ),
          // SliverToBoxAdapter(
          //   child: SizedBox(height: context.screenHeight * 0.15),
          // )
        ],
      ),
    );
  }
}
