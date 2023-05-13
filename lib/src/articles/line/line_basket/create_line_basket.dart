// Flutter imports:
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:models_base/common.dart' show StockUnit;
import 'package:models_weebi/extensions.dart';
import 'package:models_weebi/utils.dart';
import 'package:models_weebi/weebi_models.dart'
    show AggregateProxies, ArticleBasket, ArticleLine, ProxyArticle;
// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:views_weebi/routes.dart';
import 'package:mixins_weebi/stores.dart' show ArticlesStore;

import 'package:views_weebi/widgets.dart'
    show appBarWeebiUpdateNotSaved, InformDialog;
import 'package:views_weebi/views_article_basket.dart';

import 'package:views_weebi/src/widgets/toast.dart';

class ArticleLineBasketCreateView extends StatefulWidget {
  const ArticleLineBasketCreateView({Key key}) : super(key: key);
  @override
  _ArticleLineBasketCreateViewState createState() =>
      _ArticleLineBasketCreateViewState();
}

class _ArticleLineBasketCreateViewState
    extends State<ArticleLineBasketCreateView> with ToastWeebi {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKeyLine = GlobalKey<FormState>();
  String _thisCategory;
  ScrollController controller = ScrollController();

  // creating 1st article and product in the same time
  ArticleBasket _newArticleBasket;
  ArticleLine<ArticleBasket> _newLine;
  final titleTextController = TextEditingController();

  TextEditingController _newLineBarcode;
  int discountAmount = 0;
  @override
  void initState() {
    super.initState();

    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    _newLineBarcode =
        TextEditingController(text: '${articlesStore.lines.nextId * 10 + 1}');
  }

  @override
  void dispose() {
    titleTextController.dispose();

    _newLineBarcode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = [];
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    return NotificationListener<DiscountAmountChangedNotif>(
      onNotification: (n) {
        setState(() {
          discountAmount = n.val;
        });
        return true;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (_formKeyLine.currentState.validate() &&
                articlesStore.articlesSelectedForBasketMinQt.isNotEmpty) {
              final now = DateTime.now();
              _newArticleBasket = ArticleBasket(
                  creationDate: now,
                  updateDate: now,
                  discountAmountSalesOnly: discountAmount,
                  lineId: articlesStore.lines.nextId,
                  id: 1,
                  fullName: titleTextController?.text ?? '',
                  weight: 1.0,
                  articleCode: articlesStore.lines.nextId * 10 + 1,
                  photo: '',
                  status: true,
                  statusUpdateDate: now,
                  proxies: [
                    for (var i = 0;
                        i < articlesStore.articlesSelectedForBasketMinQt.length;
                        i++)
                      ProxyArticle(
                          lineId: articlesStore.lines.nextId,
                          articleId: 1,
                          id: i + 1,
                          proxyLineId: articlesStore
                              .articlesSelectedForBasketMinQt[i].lineId,
                          proxyArticleId: articlesStore
                              .articlesSelectedForBasketMinQt[i].id,
                          status: true,
                          minimumUnitPerBasket: articlesStore
                              .articlesSelectedForBasketMinQt[i].minQt,
                          articleWeight: articlesStore
                              .articlesSelectedForBasketMinQt[i].weight),
                  ]);

              _newLine = ArticleLine<ArticleBasket>(
                  creationDate: now,
                  isPalpable: true,
                  updateDate: now,
                  id: articlesStore.lines.nextId,
                  title: '', // fake reassigned when form is saved
                  stockUnit: StockUnit.unit,
                  categories: [''],
                  status: true,
                  statusUpdateDate: null,
                  articles: [_newArticleBasket]);
              _formKeyLine.currentState.save();
              // * better not create lot at all
              try {
                final lineCreated = await articlesStore
                    .createLineArticle<ArticleBasket>(_newLine);
                // CustomSuccessToastWidget

                toastSuccessArticle(context, message: 'panier créé');

                articlesStore.clearAllArticleMinQtInSelected();
                if (lineCreated is ArticleLine<ArticleBasket>) {
                  Navigator.of(context).popAndPushNamed(
                      ArticleDetailRoute.generateRoute(
                          '${lineCreated.id}', '1'));
                }
              } catch (e) {
                return InformDialog.showDialogWeebiNotOk(
                    'Erreur lors de la création du produit $e', context);
              }
            } else {
              toastFailProduct(context,
                  message: 'panier d\'articles incomplet');
              return;
            }
          },
          backgroundColor: Colors.orange[800],
          child: const Text('OK', style: TextStyle(color: Colors.white)),
        ),
        appBar: appBarWeebiUpdateNotSaved('Créer un panier d\'articles',
            backgroundColor: Colors.orange[800]),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            controller: controller,
            child: Observer(builder: (context) {
              final proxiesRaw = <ProxyArticle>[];
              for (var i = 0;
                  i < articlesStore.articlesSelectedForBasketMinQt.length;
                  i++) {
                // only interested in pure proxies fields to compute price and cost below
                final proxyRaw = ProxyArticle(
                    lineId: articlesStore.lines.nextId,
                    articleId: 1,
                    id: i + 1,
                    proxyLineId:
                        articlesStore.articlesSelectedForBasketMinQt[i].lineId,
                    proxyArticleId:
                        articlesStore.articlesSelectedForBasketMinQt[i].id,
                    status: true,
                    articleWeight:
                        articlesStore.articlesSelectedForBasketMinQt[i].weight,
                    minimumUnitPerBasket:
                        articlesStore.articlesSelectedForBasketMinQt[i].minQt);
                proxiesRaw.add(proxyRaw);
              }
              // now i can use the top notch function below to get the worth
              final proxiesWorth = ArticleBasket
                  .getProxiesListWithPriceAndCostArticleNotCreatedYetOnly(
                      articlesStore.linesPalpableNoBasket, proxiesRaw);
              final temp = proxiesWorth.totalPrice - discountAmount;
              final totalPrice = numFormat?.format(temp);
              return Form(
                key: _formKeyLine,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Nom du panier d\'articles*',
                          icon: const Icon(Icons.short_text),
                        ),
                        controller: titleTextController,
                        autofocus: true,
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Saisir le nom du panir d\'articles';
                          }
                          articlesStore.setQueryString(value);
                          if (articlesStore.getLinesNames
                              .contains(value.trim().toLowerCase())) {
                            return 'Un article avec ce nom existe déjà';
                          }
                          // _formKey.currentState.save();  will be useful to save title here so we can then preload article fullName
                          return null;
                        },
                        onSaved: (String value) {
                          _newLine = _newLine.copyWith(title: value.trim());
                        },
                      ),
                      if (categories.isNotEmpty)
                        DropdownButtonFormField<String>(
                          decoration:
                              InputDecoration(icon: const Icon(Icons.category)),
                          hint: const Text('Catégorie'),
                          items: categories
                              .map((cat) => DropdownMenuItem<String>(
                                  child: Text(cat), value: cat))
                              .toList(),
                          value: _thisCategory,
                          onChanged: (value) {
                            setState(() {
                              _thisCategory = value;
                            });
                          },
                          onSaved: (String value) {
                            if (value != null) {
                              _newLine.categories.add(value);
                            }
                          },
                        ),
                      DiscountAmountWidget(proxiesWorth.totalPrice),
                      PriceTotalBasketWidget(totalPrice),
                      const ArticlesInBasketTypeAhead(),
                      const SizedBox(height: 16),
                      if (articlesStore
                          .articlesSelectedForBasketMinQt.isNotEmpty) ...[
                        const Text('Articles sélectionnés : '),
                        const SizedBox(height: 16),
                        const PreviewArticlesProxiesSelectedWidget(),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
