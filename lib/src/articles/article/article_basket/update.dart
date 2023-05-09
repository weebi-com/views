// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:models_weebi/extensions.dart';
import 'package:models_weebi/utils.dart';
import 'package:models_weebi/weebi_models.dart'
    show AggregateProxies, ArticleBasket, ArticleWMinQt, ProxyArticle;
// Package imports:
import 'package:provider/provider.dart';

import 'package:views_weebi/extensions.dart';

// Project imports:
import 'package:views_weebi/routes.dart';
import 'package:mixins_weebi/stores.dart' show ArticlesStore;
import 'package:views_weebi/src/articles/article/article_basket/discount_amount_widget.dart';
import 'package:views_weebi/src/articles/article/article_basket/preview_proxies_selected_widget.dart';
import 'package:views_weebi/src/articles/article/article_basket/type_ahead.dart';
import 'package:views_weebi/widgets.dart'
    show AskDialog, appBarWeebiUpdateNotSaved;
import 'package:views_weebi/widgets.dart' show FieldValueWidget, InformDialog;
// import 'package:weebi/src/widgets/toast.dart';

class ArticleBasketUpdateView extends StatefulWidget {
  final ArticleBasket article;
  const ArticleBasketUpdateView(this.article, {Key key}) : super(key: key);
  @override
  _ArticleBasketUpdateViewState createState() =>
      _ArticleBasketUpdateViewState();
}

class _ArticleBasketUpdateViewState extends State<ArticleBasketUpdateView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKeyLine = GlobalKey<FormState>();
  ScrollController controller = ScrollController();

  // creating 1st article and product in the same time
  ArticleBasket _articleBasketToBeUpdated;

  TextEditingController _newArticleFullName;
  TextEditingController _newArticleCode;
  final discountAmountController = TextEditingController();
  final scrollControllerVert = ScrollController();
  final articlesMinQtWeebi = <ArticleWMinQt>[];
  int discountAmount = 0;
  @override
  void initState() {
    super.initState();
    _newArticleFullName = TextEditingController(text: widget.article.fullName);
    _newArticleCode =
        TextEditingController(text: '${widget.article.articleCode}');
  }

  @override
  void dispose() {
    _newArticleFullName.dispose();
    _newArticleCode.dispose();
    discountAmountController.dispose();
    scrollControllerVert.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final categories = [];
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final lines =
        articlesStore.lines.where((element) => element.isBasket == false);
    articlesMinQtWeebi.addAll(widget.article.proxies.getProxiesMinQt(lines));
    for (final a in articlesMinQtWeebi) {
      articlesStore.addArticleWInSelected(a);
    }

    return WillPopScope(
      onWillPop: () async {
        final isLeaving = await AskDialog.areYouSureUpdateNotSaved(context);
        if (isLeaving) {
          await articlesStore.clearAllArticleMinQtInSelected();
          return true;
        } else {
          return false;
        }
      },
      child: NotificationListener<DiscountAmountChangedNotif>(
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
                _articleBasketToBeUpdated = ArticleBasket(
                    status: true,
                    creationDate: now,
                    updateDate: now,
                    discountAmountSalesOnly: discountAmount,
                    lineId: widget.article.lineId,
                    id: widget.article.id,
                    fullName: _newArticleFullName.text,
                    weight: 1.0,
                    articleCode: articlesStore.lines.nextId * 10 + 1,
                    photo: '',
                    proxies: [
                      for (var i = 0;
                          i <
                              articlesStore
                                  .articlesSelectedForBasketMinQt.length;
                          i++)
                        ProxyArticle(
                            lineId: widget.article.lineId,
                            articleId: widget.article.id,
                            id: i + 1,
                            proxyLineId: articlesStore
                                .articlesSelectedForBasketMinQt[i].lineId,
                            proxyArticleId: articlesStore
                                .articlesSelectedForBasketMinQt[i].id,
                            status: true,
                            articleWeight: articlesStore
                                .articlesSelectedForBasketMinQt[i].weight,
                            minimumUnitPerBasket: articlesStore
                                .articlesSelectedForBasketMinQt[i].minQt),
                    ]);
                _formKeyLine.currentState.save();
                try {
                  final articleBasket = await articlesStore
                      .updateArticleRetail(_articleBasketToBeUpdated);
                  // CustomSuccessToastWidget
                  // toastSuccessArticle(context,
                  //     message: 'panier d\'article mis à jour');
                  articlesStore.clearAllArticleMinQtInSelected();
                  await Navigator.of(context).popAndPushNamed(
                      ArticleDetailRoute.generateRoute(
                          '${articleBasket.lineId}', '${articleBasket.id}'));
                } catch (e) {
                  return InformDialog.showDialogWeebiNotOk(
                      'Erreur lors de la mise à jour $e', context);
                }
              } else {
                // toastFailProduct(context,
                //     message: 'panier d\'articles incomplet');
                return InformDialog.showDialogWeebiNotOk(
                    "Erreur panier d\'articles incomplet", context);
              }
            },
            backgroundColor: Colors.orange[800],
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
          appBar: appBarWeebiUpdateNotSaved('Modifier un panier d\'articles',
              backgroundColor: Colors.orange[800]),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              controller: controller,
              child: Form(
                key: _formKeyLine,
                child: Observer(builder: (context) {
                  final proxiesRaw = <ProxyArticle>[];
                  for (var i = 0;
                      i < articlesStore.articlesSelectedForBasketMinQt.length;
                      i++) {
                    // only interested in pure proxies fields to compute price and cost below
                    final proxyRaw = ProxyArticle(
                        lineId: widget.article.lineId,
                        articleId: widget.article.id,
                        id: i + 1,
                        proxyLineId: articlesStore
                            .articlesSelectedForBasketMinQt[i].lineId,
                        proxyArticleId:
                            articlesStore.articlesSelectedForBasketMinQt[i].id,
                        status: true,
                        articleWeight: articlesStore
                            .articlesSelectedForBasketMinQt[i].weight,
                        minimumUnitPerBasket: articlesStore
                            .articlesSelectedForBasketMinQt[i].minQt);
                    proxiesRaw.add(proxyRaw);
                  }
                  // now i can use the top notch function below to get the worth
                  final proxiesWorth = ArticleBasket
                      .getProxiesListWithPriceAndCostArticleNotCreatedYetOnly(
                          articlesStore.linesPalpableNoBasket, proxiesRaw);
                  return Column(
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Nouveau nom de l\'article*',
                            icon: const Icon(Icons.subject)),
                        controller: _newArticleFullName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Saisir le nouveau nom du produit';
                          }
                          // _formKey.currentState.save();  will be useful to save title here so we can then preload article fullName, like they do for passwords
                          return null;
                        },
                        onSaved: (String value) {
                          _articleBasketToBeUpdated = _articleBasketToBeUpdated
                              .copyWith(fullName: value.trim());
                        },
                      ),
                      // TextFormField(
                      //   keyboardType: TextInputType.number,
                      //   decoration: InputDecoration(
                      //       labelText: 'Code barre',
                      //       icon: const Icon(Icons.speaker_phone)),
                      //   controller: _newArticleCode,
                      //   inputFormatters: <TextInputFormatter>[
                      //     FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      //   ],
                      //   validator: (value) {
                      //     if (value.isNotEmpty && int.tryParse(value) == null) {
                      //       return 'erreur $value';
                      //     }
                      //     return null;
                      //   },
                      //   onSaved: (String value) {
                      //     if (value != null) {
                      //       _articleBasketToBeUpdated =
                      //           _articleBasketToBeUpdated.copyWith(
                      //               articleCode: int.parse(value.trim()));
                      //     }
                      //   },
                      // ),
                      const ArticlesInBasketTypeAhead(),
                      if (articlesStore
                          .articlesSelectedForBasketMinQt.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        FieldValueWidget(
                          const Icon(Icons.local_offer, color: Colors.teal),
                          const Text("Prix de vente total"),
                          SelectableText(
                            numFormat?.format(
                                proxiesWorth.totalPrice - discountAmount),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      DiscountAmountWidget(proxiesWorth.totalPrice),
                      const PreviewArticlesProxiesSelectedWidget(),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
