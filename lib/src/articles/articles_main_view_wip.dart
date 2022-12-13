// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart'
    show EnvironmentWeebi, LineOfArticles;
import 'package:views_weebi/src/articles/lines/frame.dart';
import 'package:weebi/src/providers/top_provider.dart';

import 'package:models_weebi/extensions.dart';
// import 'package:weebi/src/routes/articles/line_article_create.dart';
import 'package:weebi/src/stores/articles.dart';

import 'package:views_weebi/styles.dart' show WeebiColors, weebiTheme;
import 'package:views_weebi/icons.dart';

// import 'package:weebi/src/views/main_views/articles/line/line_basket/line_basket_create.dart';
// import 'package:weebi/src/views/main_views/articles/lines_frame.dart';

class LinesArticlesView extends StatefulWidget {
  final GlobalKey<NavigatorState> mainNavigator;
  const LinesArticlesView({super.key, required this.mainNavigator});

  @override
  LinesArticlesViewState createState() => LinesArticlesViewState();
}

class LinesArticlesViewState extends State<LinesArticlesView> {
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

    return Stack(
      children: [
        Scaffold(
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
            final articlesStore =
                Provider.of<ArticlesStore>(context, listen: false);
            final linesSkip = articlesStore.lines
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
                      itemBuilder: (BuildContext context, int index) =>
                          LinesFrameW(
                              contextMain: context,
                              index: index,
                              lines: linesListReordered),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      controller: scrollControllerVertical,
                      shrinkWrap: true,
                      itemCount: linesSkip.length,
                      itemBuilder: (BuildContext context, int index) =>
                          LinesFrameW(
                              contextMain: context,
                              index: index,
                              lines: linesSkip),
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
        )
      ],
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

  // fetch from original lines_of_articles.dart in mainView
  void _orderByTitle(bool _isAscending) {
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    List<LineOfArticles> ordering = articlesStore.lines;
    if (_isAscending == true) {
      ordering.sort((a, b) => a.title.compareTo(b.title));
    } else {
      ordering.sort((a, b) => b.title.compareTo(a.title));
    }
    setState(() {
      isTitleAscending = !_isAscending;
      linesListReordered = ordering;
      isListReorderedByLineTitle = true;
      isListReorderedById = false;
      _isSearch = false;
    });
  }

  void _orderById(bool _isAscending) {
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    List<LineOfArticles> ordering = articlesStore.lines;
    if (_isAscending == true) {
      ordering.sort((a, b) => a.id.compareTo(b.id));
    } else {
      ordering.sort((a, b) => b.id.compareTo(a.id));
    }
    setState(() {
      isIdAscending = _isAscending;
      linesListReordered = ordering;
      isListReorderedById = true;
      isListReorderedByLineTitle = false;
      _isSearch = false;
    });
  }
}
