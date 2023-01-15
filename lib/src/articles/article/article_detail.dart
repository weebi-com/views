// Flutter imports:
import 'package:flutter/material.dart';
import 'package:models_weebi/base.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart'
    show ArticleBasket, Article, LineOfArticles;
import 'package:views_weebi/icons.dart';
import 'package:views_weebi/extensions.dart';
import 'package:views_weebi/src/articles/article/actions.dart';
import 'package:views_weebi/routes.dart';
import 'package:views_weebi/views_article.dart';
import 'package:mixins_weebi/stores.dart' show ArticlesStore;
import 'package:views_weebi/styles.dart' show WeebiColors, weebiTheme;

import 'package:views_weebi/widgets.dart';

// TODO use this for actionsWidget
// Iterable<Widget> actionsWidget(BuildContext context, ShopWeebi thisShop) {
//   return <Widget>[
//     if (!isShopLocked)
//       IconButton(
//         tooltip: "Editer l'article",
//         icon: const Icon(Icons.edit, color: WeebiColors.grey),
//         onPressed: () async {
//           if (isShopLocked == true) {
//             return showDialogWeebi('Permission requise', context);
//           } else {
//             return Navigator.of(context).pushNamed(
//                 ArticleUpdateRoute.generateRoute(
//                     '${article.productId}', '${article.id}'));
//           }
//         },
//       ),
//     if (context.read<TopProvider>().environment != EnvironmentWeebi.ldb ||
//         !isShopLocked)
//       IconButton(
//         tooltip: "Supprimer l'article",
//         icon: const Icon(Icons.delete, color: WeebiColors.grey),
//         onPressed: () async {
//           final isOkToDelete = await showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (c) => AskAreYouSure(
//                 'Attention effacer l\'article est irréversible. Êtes vous sur de vouloir continuer ?'),
//           );

//           if (!isOkToDelete) {
//             return;
//           }
//           final articlesStore =
//               Provider.of<ArticlesStore>(context, listen: false);
//           final p = articlesStore.lines
//               .firstWhere((element) => element.id == article.productId);
//           if (p.articles.length <= 1) {
//             await articlesStore.deleteForeverLineArticle(p);
//             Navigator.of(context).popAndPushNamed(ArticleLinesRoute.routePath);
//           } else {
//             await articlesStore.deleteForeverArticle(article);
//             Navigator.of(context).popAndPushNamed(
//                 LineArticlesDetailRoute.generateRoute('${p.id}'));
//           }
//         },
//       )
//   ];
// }

// same widget for article and article basket
class ArticleDetailWidget<A extends ArticleAbstract> extends StatelessWidget {
  final A article;
  final bool isShopLocked;
  const ArticleDetailWidget(this.article,
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
              (line.isBasket ?? false)
                  ? FloatingActionButton(
                      heroTag: 'createBasketSameLine',
                      tooltip: 'Créer un sous-panier d\'articles',
                      backgroundColor: WeebiColors.orange,
                      child: const IconAddArticleBasket(),
                      onPressed: () {
                        articlesStore.clearAllArticleMinQtInSelected();
                        Navigator.of(context).pushNamed(
                            ArticleBasketCreateRoute.generateRoute(
                                '${line.id}'));
                      })
                  : FloatingActionButton(
                      heroTag: 'createArticleSameLine',
                      tooltip: 'Créer un article dans la même ligne',
                      backgroundColor: WeebiColors.orange,
                      onPressed: () => Navigator.of(context).pushNamed(
                          ArticleCreateRoute.generateRoute('${line.id}')),
                      child: const Icon(Icons.library_add, color: Colors.white),
                    )),
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
              background: article.photo == null || article.photo!.isEmpty
                  ? (line.isBasket ?? false)
                      ? const Icon(Icons.shopping_basket,
                          color: WeebiColors.grey)
                      : Image.asset('assets/icons/product_detail.png',
                          color: WeebiColors.greyLight)
                  : Hero(
                      tag: '${article.lineId}.${article.id}',
                      child: Image.asset('assets/photos/${article.photo}',
                          fit: BoxFit.scaleDown,
                          errorBuilder: (_, o, stack) => Image.asset(
                              'assets/icons/product_detail.png',
                              color: WeebiColors.grey)),
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
                  Navigator.of(context).pop();
                },
                tooltip:
                    MaterialLocalizations.of(context).openAppDrawerTooltip),

            actions: actionsArticleWidget(context, isShopLocked, article),
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
              child: ArticleWFrameView(article as Article, false),
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
