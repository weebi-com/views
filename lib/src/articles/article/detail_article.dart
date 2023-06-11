// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/invokers.dart';
import 'package:mixins_weebi/stock.dart';
import 'package:models_weebi/base.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart'
    show ArticleRetail, ArticleBasket, ArticleCalibre;
import 'package:views_weebi/extensions.dart';
import 'package:views_weebi/routes.dart';
import 'package:views_weebi/src/articles/article/article_basket/detail_section_basket_widget.dart';
import 'package:views_weebi/src/articles/article/buttons.dart';
import 'package:views_weebi/src/articles/calibre/buttons_calibre.dart';
import 'package:views_weebi/src/articles/photo.dart';
import 'package:views_weebi/views_article.dart';
import 'package:mixins_weebi/stores.dart' show ArticlesStore, CoolExtension;
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
    ArticleCalibre calibre = articlesStore.calibres
        .firstWhere((element) => element.id == article.calibreId);

    return Scaffold(
      floatingActionButton: isShopLocked ||
              // ! only one basket per calibre
              (calibre.isBasket)
          ? const SizedBox()
          : MultipleFABs(
              calibre.isSingleArticle == false
                  ? const SizedBox()
                  : CreateArticleWithinExistingCaliberButton(calibre.id,
                      isShopLocked: isShopLocked),
              (article.status)
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
                                '${d.calibreId}', '${d.id}'));
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
                                '${d.calibreId}', '${d.id}'));
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
                background: article.photo.isEmpty
                    ? (calibre.isBasket)
                        ? const Icon(Icons.shopping_basket,
                            color: WeebiColors.grey)
                        : const Icon(Icons.article)
                    : Hero(
                        tag: '${article.calibreId}.${article.id}',
                        child: PhotoWidget(article),
                      ),
                title: Text(
                    '#${calibre.id}.${article.id} ${(article.status) ? '' : ' \ndésactivé'}',
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
              child: (calibre.isBasket)
                  ? ArticleBasketDetailSectionWidget(
                      ArticleBasketRealizablekNow(
                        article: article as ArticleBasket,
                        ticketsInvoker: ticketsInvoker,
                        closingStockShopsInvoker: closingStockShopsInvoker,
                        calibresNoQuickspend:
                            articlesStore.calibres.notQuickSpend,
                      ),
                    )
                  : ArticleRetailFrameView(
                      ArticleRetailStockNow(
                        article: article as ArticleRetail,
                        ticketsInvoker: ticketsInvoker,
                        closingStockShopsInvoker: closingStockShopsInvoker,
                      ),
                      false),
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
          //           //for (final article in calibre.articles)
          //           calibre.articles[index] is ArticleBasket
          //               ? ArticleBasketGlimpseWidget(
          //                   calibre, calibre.articles[index])
          //               : ArticleGlimpseWidget(calibre, calibre.articles[index]),
          //       childCount: calibre.articles.length,
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
