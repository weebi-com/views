// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mixins_weebi/mobx_store_article.dart';
import 'package:mixins_weebi/mobx_store_closing.dart';
import 'package:mixins_weebi/mobx_store_ticket.dart';
import 'package:mobx/mobx.dart';
import 'package:models_weebi/dummies.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:views_weebi/src/articles/app_bar_search.dart';

// Project imports:
import 'package:views_weebi/src/articles/line/frame_line.dart';
import 'package:views_weebi/src/icons/add_basket.dart';
import 'package:views_weebi/src/routes/articles/create_line_basket.dart';
import 'package:views_weebi/src/routes/articles/create_line_retail.dart';
import 'package:views_weebi/styles.dart' show WeebiColors;
import 'package:views_weebi/views_article_basket.dart';

// * This is for web only now
// articleBaskets are not included here yet
// so in weebi_app we stick to the traditionnal one in lines_of_articles.dart
class ArticlesLinesOverviewWebOnly extends StatelessWidget {
  final GlobalKey<NavigatorState> mainNavigator;
  const ArticlesLinesOverviewWebOnly({@required this.mainNavigator});

  @override
  Widget build(BuildContext context) {
    final scrollControllerVertical = ScrollController();

    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    ticketsInvoker() =>
        Provider.of<TicketsStore>(context, listen: false).tickets;
    closingStockShopsInvoker() =>
        Provider.of<ClosingsStore>(context, listen: false).closingStockShops;
    return Scaffold(
      body: Observer(builder: (context) {
        return Column(
          children: [
            articlesStore.searchedBy == SearchedBy.titleOrId
                ? const TopBarSearchArticles()
                : const SizedBox(),
            Expanded(
              child: articlesStore.searchedBy != SearchedBy.titleOrId
                  ? Observer(
                      builder: (context) => ListView.builder(
                        shrinkWrap: true,
                        controller: scrollControllerVertical,
                        itemCount: articlesStore.lines.length,
                        itemBuilder: (BuildContext context, int index) =>
                            ArticleLineFrame(
                          contextMain: context,
                          line: articlesStore.lines[index],
                          ticketsInvoker: ticketsInvoker,
                          closingStockShopsInvoker: closingStockShopsInvoker,
                        ),
                      ),
                    )
                  : ReactionBuilder(
                      builder: (_) {
                        // using reaction here is a bit trickier than in the addListener
                        // but it will allow us to move textedit anywhere in the widget tree
                        return reaction(
                            (_) => articlesStore.queryString,
                            (val) =>
                                articlesStore.searchPalpablesByTitleOrId());
                      },
                      child: Observer(
                        builder: (context) => ListView.builder(
                          shrinkWrap: true,
                          controller: scrollControllerVertical,
                          itemCount: articlesStore.linesPalpableFiltered.length,
                          itemBuilder: (BuildContext context, int index) =>
                              ArticleLineFrame(
                            contextMain: context,
                            line: articlesStore.linesPalpableFiltered[index],
                            ticketsInvoker: ticketsInvoker,
                            closingStockShopsInvoker: closingStockShopsInvoker,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        );
      }),
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 14,
              ),
              child: Observer(
                builder: (context) => FloatingActionButton(
                  heroTag: 'ArticleLinesFAB',
                  tooltip: 'Chercher un article',
                  backgroundColor: Colors.white,
                  child: articlesStore.searchedBy != SearchedBy.titleOrId
                      ? const Icon(Icons.search, color: WeebiColors.orange)
                      : const Icon(Icons.close, color: WeebiColors.orange),
                  onPressed: () {
                    if (articlesStore.searchedBy != SearchedBy.titleOrId) {
                      // print('setFilteredBy(FilteredBy.title)');
                      articlesStore.setSearchedBy(SearchedBy.titleOrId);
                    } else {
                      articlesStore.clearSearch();
                    }
                  },
                ),
              ),
            ),
          ),
          Builder(builder: (context) {
            return articlesStore.searchedBy != SearchedBy.titleOrId &&
                    articlesStore.lines.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 80),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          heroTag: 'Créer un panier',
                          tooltip: 'Créer un panier d\'articles',
                          backgroundColor: WeebiColors.orange,
                          onPressed: () async {
                            await articlesStore
                                .clearAllArticleMinQtInSelected();
                            Navigator.of(context).pushNamed(
                                ArticleLineBasketCreateRoute.routePath);
                          },
                          child: const IconAddArticleBasket(),
                        )),
                  )
                : const SizedBox();
          }),
          Observer(builder: (context) {
            return articlesStore.searchedBy != SearchedBy.titleOrId
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      backgroundColor: WeebiColors.orange,
                      tooltip: 'Créer un article',
                      heroTag: "btn1Add",
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(ArticleLineRetailCreateRoute.routePath);
                      },
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  )
                : const SizedBox();
          }),
          // ]
        ],
      ),
    );
  }
}
