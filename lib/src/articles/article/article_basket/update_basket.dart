// Flutter imports:

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:models_weebi/extensions.dart';
import 'package:models_weebi/utils.dart';
import 'package:models_weebi/weebi_models.dart'
    show AggregateProxies, ArticleBasket, ArticleWMinQt, ProxyArticle;
// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:views_weebi/routes.dart';
import 'package:mixins_weebi/stores.dart' show ArticlesStore;
import 'package:views_weebi/src/articles/article/article_basket/discount_amount_widget.dart';
import 'package:views_weebi/src/articles/article/article_basket/preview_proxies_selected_widget.dart';
import 'package:views_weebi/src/articles/article/article_basket/type_ahead.dart';
import 'package:views_weebi/src/styles/colors.dart';
import 'package:views_weebi/src/widgets/toast.dart';
import 'package:views_weebi/widgets.dart' show appBarWeebiUpdateNotSaved;
import 'package:views_weebi/widgets.dart' show FieldValueWidget, InformDialog;
// import 'package:weebi/src/widgets/toast.dart';

class ArticleBasketUpdateView extends StatefulWidget {
  final ArticleBasket article;
  const ArticleBasketUpdateView(this.article, {Key? key}) : super(key: key);
  @override
  _ArticleBasketUpdateViewState createState() =>
      _ArticleBasketUpdateViewState();
}

class _ArticleBasketUpdateViewState extends State<ArticleBasketUpdateView>
    with ToastWeebi {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKeyLine = GlobalKey<FormState>();
  ScrollController controller = ScrollController();

  // creating 1st article and product in the same time
  ArticleBasket? _articleBasketToBeUpdated;

  TextEditingController _newArticleFullName = TextEditingController();
  TextEditingController _newArticleCode = TextEditingController();
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
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);

    return NotificationListener<DiscountAmountChangedNotif>(
      onNotification: (n) {
        setState(() => discountAmount = n.val);
        return true;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (_formKeyLine.currentState?.validate() == false ||
                articlesStore.articlesSelectedForBasketMinQt.isEmpty) {
              // toastFailProduct(context,
              //     message: 'panier d\'articles incomplet');
              return InformDialog.showDialogWeebiNotOk(
                  "Erreur panier d\'articles incomplet", context);
            }
            final now = DateTime.now();
            _articleBasketToBeUpdated = ArticleBasket(
                status: true,
                creationDate: now,
                updateDate: now,
                discountAmountSalesOnly: discountAmount,
                calibreId: widget.article.calibreId,
                id: widget.article.id,
                fullName: _newArticleFullName.text,
                weight: 1.0,
                articleCode: articlesStore.calibres.nextId * 10 + 1,
                photo: '',
                proxies: [
                  for (var i = 0;
                      i < articlesStore.articlesSelectedForBasketMinQt.length;
                      i++)
                    ProxyArticle(
                        calibreId: widget.article.calibreId,
                        articleId: widget.article.id,
                        id: i + 1,
                        proxyCalibreId: articlesStore
                            .articlesSelectedForBasketMinQt[i].calibreId,
                        proxyArticleId:
                            articlesStore.articlesSelectedForBasketMinQt[i].id,
                        status: true,
                        articleWeight: articlesStore
                            .articlesSelectedForBasketMinQt[i].weight,
                        minimumUnitPerBasket: articlesStore
                            .articlesSelectedForBasketMinQt[i].minQt),
                ]);
            _formKeyLine.currentState?.save();
            try {
              final articleBasket =
                  await articlesStore.updateArticleRetail<ArticleBasket>(
                      _articleBasketToBeUpdated!);
              toastSuccessArticle(context,
                  message: 'panier d\'article mis à jour');
              articlesStore.clearAllArticleMinQtInSelected();
              await Navigator.of(context).popAndPushNamed(
                  ArticleDetailRoute.generateRoute(
                      '${articleBasket.calibreId}', '${articleBasket.id}'));
            } catch (e) {
              return InformDialog.showDialogWeebiNotOk(
                  'Erreur lors de la mise à jour $e', context);
            }
          },
          backgroundColor: WeebiColors.orange,
          child: const Text('OK', style: TextStyle(color: Colors.white)),
        ),
        appBar: appBarWeebiUpdateNotSaved('Modifier un panier d\'articles',
            backgroundColor: WeebiColors.orange,
            pushThatRouteInstead: ArticleDetailRoute.generateRoute(
                '${widget.article.calibreId}', '${widget.article.id}')),
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
                      calibreId: widget.article.calibreId,
                      articleId: widget.article.id,
                      id: i + 1,
                      proxyCalibreId: articlesStore
                          .articlesSelectedForBasketMinQt[i].calibreId,
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
                        articlesStore.calibresNotQuikspendNotBasket,
                        proxiesRaw);
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
                          return 'Saisir le nouveau nom de l\'article';
                        }
                        // _formKey.currentState.save();  will be useful to save title here so we can then preload article fullName, like they do for passwords
                        return null;
                      },
                      onSaved: (String? value) {
                        _articleBasketToBeUpdated = _articleBasketToBeUpdated
                            ?.copyWith(fullName: value?.trim());
                      },
                    ),
                    // TODO pub barcodeEAN here ?
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
                    DiscountAmountWidget(proxiesWorth.totalPrice),
                    if (articlesStore
                        .articlesSelectedForBasketMinQt.isNotEmpty) ...[
                      FieldValueWidget(
                        const Icon(Icons.local_offer, color: Colors.teal),
                        const Text("Prix de vente total"),
                        SelectableText(
                          numFormat
                              .format(proxiesWorth.totalPrice - discountAmount),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    const ArticlesInBasketTypeAhead(),
                    const PreviewArticlesProxiesSelectedWidget(),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
