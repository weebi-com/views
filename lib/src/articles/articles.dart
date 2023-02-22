// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mixins_weebi/mobx_store_closing.dart';
import 'package:mixins_weebi/mobx_stores/articles.dart';
import 'package:mixins_weebi/mobx_stores/tickets.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart' show LineOfArticles;

import 'package:models_weebi/extensions.dart';
import 'package:views_weebi/src/articles/line/frame.dart';
import 'package:views_weebi/styles.dart' show WeebiColors, weebiTheme;

// * This is for web only now
// articleBaskets are not included here yet
// so in weebi_app we stick to the traditionnal one in lines_of_articles.dart
class ArticlesLinesViewWIP extends StatefulWidget {
  final GlobalKey<NavigatorState> mainNavigator;
  final List<LineOfArticles> lines;
  const ArticlesLinesViewWIP(
      {super.key, required this.mainNavigator, required this.lines});

  @override
  LinesArticlesViewStateWIP createState() => LinesArticlesViewStateWIP();
}

class LinesArticlesViewStateWIP extends State<ArticlesLinesViewWIP> {
  final barcodeController = TextEditingController();
  final scrollControllerVertical = ScrollController();
  late List<LineOfArticles> linesListReordered = [];
  late bool isListReorderedByLineTitle = false;
  late bool isListReorderedById = false;
  late bool isTitleAscending = false;
  late bool isIdAscending = true;

  List<LineOfArticles> searchResults = [];
  bool _isSearch = false;

  bool submitting = false;

  @override
  void initState() {
    super.initState();
    _isSearch = false;
    isListReorderedByLineTitle = false;
    isListReorderedById = false;
    isTitleAscending = true;
    isIdAscending = true;
  }

  @override
  void dispose() {
    barcodeController.dispose();
    scrollControllerVertical.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final top = Provider.of<TopProvider>(context, listen: false);

    return Scaffold(
      appBar: !_isSearch
          ? null
          : AppBar(
              backgroundColor: weebiTheme.scaffoldBackgroundColor,
              leading: const Icon(Icons.search, color: Colors.black),
              title: TextField(
                autofocus: true,
                onChanged: (value) {
                  _searchByTitleOrCode(value);
                },
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.text,
                controller: barcodeController,
                decoration: const InputDecoration(
                  hintText: "titre / code ",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  color: Colors.black,
                  onPressed: () => setState(() => _isSearch = false),
                ),
              ],
            ),
      body: Observer(builder: (context) {
        final closingsStore =
            Provider.of<ClosingsStore>(context, listen: false);
        final ticketsStore = Provider.of<TicketsStore>(context, listen: false);
        final linesSkip = widget.lines
            .where((element) => element.title != '*') // consider removing
            .where((element) => element.isPalpable ?? true)
            .toList()
          ..sort((a, b) => a.id.compareTo(b.id));
        return Column(
          children: <Widget>[
            if (isListReorderedByLineTitle == true ||
                isListReorderedById ==
                    true) // handle null, default case as well in view)
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: scrollControllerVertical,
                  itemCount: linesListReordered.length,
                  itemBuilder: (BuildContext context, int index) => LinesFrameW(
                      contextMain: context,
                      index: index,
                      lines: linesListReordered,
                      ticketsInvoker: () => ticketsStore.tickets,
                      closingStockShopsInvoker: () =>
                          closingsStore.closingStockShops),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  controller: scrollControllerVertical,
                  shrinkWrap: true,
                  itemCount: linesSkip.length,
                  itemBuilder: (BuildContext context, int index) => LinesFrameW(
                      contextMain: context,
                      index: index,
                      lines: linesSkip,
                      ticketsInvoker: () => ticketsStore.tickets,
                      closingStockShopsInvoker: () =>
                          closingsStore.closingStockShops),
                ),
              ),
            // below empty widget at bottom so that last product can also be selected
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
              child: FloatingActionButton(
                heroTag: "btnSearchProducts",
                tooltip: "Chercher un produit",
                backgroundColor: Colors.white,
                child: !_isSearch
                    ? const Icon(Icons.search, color: WeebiColors.orange)
                    : const Icon(Icons.close, color: WeebiColors.orange),
                onPressed: () {
                  setState(() => _isSearch = !_isSearch);
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
          //   Align(
          //     alignment: Alignment.bottomRight,
          //     child: FloatingActionButton(
          //       backgroundColor: WeebiColors.orange,
          //       tooltip: 'Créer un article',
          //       heroTag: "btn1Add",
          //       onPressed: () => Navigator.of(context)
          //           .pushNamed(ArticleLineCreateRoute.routePath),
          //       child: const Icon(Icons.add, color: Colors.white),
          //     ),
          //   ),
          // ]
        ],
      ),
    );
  }

  void _searchByTitleOrCode(String queryString) {
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    var temp = articlesStore.lines
        .where((p) => p.title != '*')
        .where((p) => p.isPalpable ?? true)
        .where((p) =>
            p.title
                .toLowerCase()
                .trim()
                .withoutAccents
                .contains(queryString.trim().withoutAccents.toLowerCase()) ||
            p.barcode.toString().contains(queryString))
        .toList();
    setState(() {
      searchResults = temp;
    });
  }
}
