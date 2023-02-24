// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/stock/abstracts/line_stock_abstract.dart';
import 'package:models_weebi/base.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart'
    show Article, ArticleBasket, LineOfArticles, PhotoSource;
import 'package:views_weebi/extensions.dart';
import 'package:views_weebi/src/articles/article/actions.dart';
import 'package:views_weebi/routes.dart';
import 'package:views_weebi/src/articles/photo.dart';
import 'package:views_weebi/views_article.dart';
import 'package:mixins_weebi/stores.dart' show ArticlesStore;
import 'package:views_weebi/styles.dart' show WeebiColors, weebiTheme;

import 'package:views_weebi/widgets.dart';

// same widget for article and article basket
class ArticleDetailWidget<A extends ArticleAbstract> extends StatelessWidget {
  final A article;
  final bool isShopLocked;
  final List<IconButton> iconButtonsInAppBar;
  final TicketsInvoker ticketsInvoker;
  final ClosingStockShopsInvoker closingStockShopsInvoker;
  final FloatingActionButton fabButton;
  const ArticleDetailWidget(this.article, this.iconButtonsInAppBar,
      this.fabButton, this.ticketsInvoker, this.closingStockShopsInvoker,
      {this.isShopLocked = false, super.key});

  Future<Article> deactivateArticleW(ArticlesStore articlesStore) async {
    final deactivated = (article as Article)
        .copyWith(statusUpdateDate: DateTime.now(), status: false);
    return await articlesStore.updateArticle<Article>(deactivated);
  }

  Future<ArticleBasket> deactivateArticleB(ArticlesStore articlesStore) async {
    final deactivated = (article as ArticleBasket)
        .copyWith(statusUpdateDate: DateTime.now(), status: false);
    return await articlesStore.updateArticle<ArticleBasket>(deactivated);
  }

  Future<dynamic> reactivateArticleW(ArticlesStore articlesStore) async {
    final deactivated = (article as Article)
        .copyWith(statusUpdateDate: DateTime.now(), status: true);
    return await articlesStore.updateArticle<Article>(deactivated);
  }

  Future<dynamic> reactivateArticleB(ArticlesStore articlesStore) async {
    final deactivated = (article as ArticleBasket)
        .copyWith(statusUpdateDate: DateTime.now(), status: true);
    return await articlesStore.updateArticle<ArticleBasket>(deactivated);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    LineOfArticles line = articlesStore.lines
        .firstWhere((element) => element.id == article.productId);

    return Scaffold(
      floatingActionButton: isShopLocked
          ? const SizedBox()
          : MultipleFABs(
              article.status
                  ? FloatingActionButton(
                      heroTag: 'deactivate',
                      tooltip: 'Désactiver l\'article',
                      backgroundColor: WeebiColors.greyLight,
                      onPressed: () async {
                        final d = article is Article
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
                        final d = article is Article
                            ? await reactivateArticleW(articlesStore)
                            : await reactivateArticleB(articlesStore);
                        Navigator.of(context).popAndPushNamed(
                            ArticleDetailRoute.generateRoute(
                                '${d.lineId}', '${d.id}'));
                      }),
              fabButton),
      body: CustomScrollView(
        //scrollBehavior: ,
        controller: controller,
        shrinkWrap: false,
        slivers: <Widget>[
          SliverAppBar(
            //forceElevated: true,
            elevation: 3,
            // toolbarHeight: context.screenHeight * .12,
            //*ncollapsedHeight: context.screenHeight * .08,
            expandedHeight: context.screenHeight * .47,
            centerTitle: false,
            //floating: true,
            //snap: true,
            stretch: true,
            pinned: true,
            backgroundColor: weebiTheme.scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              collapseMode: CollapseMode.parallax,
              // TODO update with photo widget here
              background: article.photo == null || article.photo!.isEmpty
                  ? (line.isBasket ?? false)
                      ? const Icon(Icons.shopping_basket,
                          color: WeebiColors.grey)
                      : Loader.productIcon
                  : Hero(
                      tag: '${article.lineId}.${article.id}',
                      child: PhotoWidget(article),
                    ),
              title: Text(
                  '#${line.id}.${article.id} ${article.status ? '' : ' \ndésactivé'}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                  overflow: TextOverflow.ellipsis),
            ),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: WeebiColors.grey),
                onPressed: () {
                  // * if article has just been created it would be nice to go back
                  Navigator.of(context).pop();
                },
                tooltip:
                    MaterialLocalizations.of(context).openAppDrawerTooltip),

            actions: actionsArticleWidgetUnfinished(
                context, isShopLocked, article, iconButtonsInAppBar),
          ),

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
          if (line.isBasket == false)
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: ArticleWFrameView(article as Article, false,
                  ticketsInvoker, closingStockShopsInvoker),
            )),
          if (article is ArticleBasket)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: ArticleBasketDetailSectionWidgetFakeFrame(
                    article as ArticleBasket),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: ArticleDetailComplementarySection(article),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 84)),

          // * consider displaying tickets where this was solved
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

class ArticleBasketDetailSectionWidgetFakeFrame extends StatelessWidget {
  final ArticleBasket articleBasket;
  const ArticleBasketDetailSectionWidgetFakeFrame(this.articleBasket,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO here implement ArticleBasketDetailSectionWidget(article as ArticleBasket)
    return Container();
  }
}
