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

// Project imports:
import 'package:views_weebi/src/articles/line/frame.dart';
import 'package:views_weebi/src/routes/articles/line_article_create_unfinished.dart';
import 'package:views_weebi/styles.dart' show WeebiColors, weebiTheme;

// * This is for web only now
// articleBaskets are not included here yet
// so in weebi_app we stick to the traditionnal one in lines_of_articles.dart
class ArticlesLinesViewWebOnly extends StatefulWidget {
  final GlobalKey<NavigatorState> mainNavigator;
  const ArticlesLinesViewWebOnly({@required this.mainNavigator});

  @override
  ArticlesLinesViewWebOnlyState createState() =>
      ArticlesLinesViewWebOnlyState();
}

class ArticlesLinesViewWebOnlyState extends State<ArticlesLinesViewWebOnly> {
  final textController = TextEditingController();
  final scrollControllerVertical = ScrollController();

  bool submitting = false;

  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      final String text = textController.text;
      textController.value = textController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
      final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
      articlesStore.setQueryString(textController.value.text);
    });
  }

  @override
  void dispose() {
    textController.dispose();
    scrollControllerVertical.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final top = Provider.of<TopProvider>(context, listen: false);
    final closingsStore = Provider.of<ClosingsStore>(context, listen: false);
    final ticketsStore = Provider.of<TicketsStore>(context, listen: false);
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    return Scaffold(
      appBar: articlesStore.filteredBy != FilteredBy.title
          ? null
          : AppBar(
              backgroundColor: weebiTheme.scaffoldBackgroundColor,
              leading: const Icon(Icons.search, color: WeebiColors.grey),
              title: TextField(
                autofocus: true,
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.text,
                controller: textController,
                decoration: const InputDecoration(
                  hintText: "Nom ",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
      body: ReactionBuilder(
        builder: (_) {
          // using reaction here is a bit trickier than in the addListener
          // but it will allow us to move textedit anywhere in the widget tree
          return reaction((_) => articlesStore.queryString,
              (val) => articlesStore.filterByTitle()
              //print(articlesStore.lines.length);
              //print(val);
              );
        },
        child: Observer(builder: (context) {
          return ListView.builder(
            shrinkWrap: true,
            controller: scrollControllerVertical,
            itemCount: articlesStore.linesPalpableFiltered.length,
            itemBuilder: (BuildContext context, int index) => LinesFrameW(
                contextMain: context,
                line: articlesStore.linesPalpableFiltered[index],
                ticketsInvoker: () => ticketsStore.tickets,
                closingStockShopsInvoker: () =>
                    closingsStore.closingStockShops),
          );
        }),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 14,
              ),
              child: FloatingActionButton(
                heroTag: 'btnSearchArticles',
                tooltip: 'Chercher un article',
                backgroundColor: Colors.white,
                child: articlesStore.filteredBy != FilteredBy.title
                    ? const Icon(Icons.search, color: WeebiColors.orange)
                    : const Icon(Icons.close, color: WeebiColors.orange),
                onPressed: () {
                  if (articlesStore.filteredBy != FilteredBy.title) {
                    // print('setFilteredBy(FilteredBy.title)');
                    articlesStore.setFilteredBy(FilteredBy.title);
                  } else {
                    articlesStore.clearFilter(data: [
                      ...DummyArticleData.cola,
                      ...DummyArticleData.babibel
                    ]);
                    // JamfBM.jams);
                  }
                  setState(() {});
                },
              ),
            ),
          ),
          // if (!_isSearch) ...[
          //   Align(
          //       alignment: Alignment.bottomCenter,
          //       child: FloatingActionButton(
          //         heroTag: 'Créer un panier',
          //         tooltip: 'Créer un panier d\'articles',
          //         backgroundColor: WeebiColors.orange,
          //         onPressed: () => Navigator.of(context).push(
          //           MaterialPageRoute(
          //             builder: (context) =>
          //                 const LineArticleBasketCreateView(),
          //           ),
          //         ),
          //         child: const IconAddArticleBasket(),
          //       )),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              backgroundColor: WeebiColors.orange,
              tooltip: 'Créer un article',
              heroTag: "btn1Add",
              onPressed: () => Navigator.of(context)
                  .pushNamed(ArticleLineCreateRouteUnfinished.routePath),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
          // ]
        ],
      ),
    );
  }
}
