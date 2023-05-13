// Project imports:
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mixins_weebi/stores.dart';
import 'package:mixins_weebi/validators.dart';
import 'package:models_weebi/utils.dart';
import 'package:models_weebi/weebi_models.dart';
import 'package:provider/provider.dart';
import 'package:views_weebi/src/routes/articles/line_detail.dart';

import 'package:views_weebi/src/widgets/app_bar_weebi.dart';
import 'package:views_weebi/src/widgets/dialogs.dart';
import 'package:views_weebi/src/widgets/toast.dart';

class ArticleCreateView extends StatefulWidget {
  static const fullNameKey = Key('nom');
  static const priceKey = Key('prix');
  static const costKey = Key('coût');
  final ArticleLine line;
  const ArticleCreateView({@required this.line, Key key}) : super(key: key);

  @override
  State<ArticleCreateView> createState() => _ArticleCreateViewState();
}

class _ArticleCreateViewState extends State<ArticleCreateView> with ToastWeebi {
  ArticleRetailCreateFormStore store;
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    store = ArticleRetailCreateFormStore(articlesStore, widget.line);
    store.setupValidations();
  }

  @override
  void dispose() {
    controller.dispose();
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWeebiUpdateNotSaved(
          'Créer un sous-article dans la ligne #${widget.line.id}',
          backgroundColor: Colors.orange),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          store.validateAll();
          if (store.hasErrors) {
            return;
          }
          try {
            final articleRetailCreated =
                await store.createArticleRetailFromForm();

            toastSuccessArticle(context, message: 'sous-article créé');

            Navigator.of(context).popAndPushNamed(
                ArticleLineRetailDetailRoute.generateRoute('${widget.line.id}',
                    articleId: '${articleRetailCreated.id}'));
          } catch (e) {
            return InformDialog.showDialogWeebiNotOk(
                "Erreur lors de la création de l'article $e", context);
          }
        },
        backgroundColor: Colors.orange[800],
        child: const Text('OK', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: <Widget>[
            Observer(
                builder: (_) => AnimatedOpacity(
                    child: const LinearProgressIndicator(),
                    duration: const Duration(milliseconds: 300),
                    opacity: store.isArticleCreationPending ? 1 : 0)),
            Observer(
              name: 'fullName',
              builder: (_) => TextFormField(
                key: ArticleCreateView.fullNameKey,
                initialValue: store.fullName,
                onChanged: (value) => store.fullName = value,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Nom de l\'article*',
                    icon: const Icon(Icons.short_text),
                    errorText: store.errorStore.fullNameError),
                autofocus: true,
              ),
            ),
            Observer(
              name: 'prix',
              builder: (_) => TextField(
                key: ArticleCreateView.priceKey,
                onChanged: (value) => store.price = value,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Prix de vente*',
                  icon: const Icon(Icons.local_offer, color: Colors.teal),
                  errorText: store.errorStore.priceError,
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
              ),
            ),
            Observer(
              name: 'coût',
              builder: (_) => TextFormField(
                key: ArticleCreateView.costKey,
                initialValue: '0',
                onChanged: (value) => store.cost = value,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Coût d\'achat',
                  icon: const Icon(Icons.local_offer, color: Colors.red),
                  errorText: store.errorStore.costError,
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
              ),
            ),
            Observer(
              name: 'unités par pièce',
              builder: (_) => TextFormField(
                initialValue: '1',
                onChanged: (value) => store.unitsPerPiece = value,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExpWeebi.regExpDecimal)
                ],
                decoration: InputDecoration(
                    labelText: 'Unité(s) par pièce',
                    icon: const Icon(Icons.style),
                    errorText: store.errorStore.unitsPerPieceError),
              ),
            ),
            TextField(
              onChanged: (value) => store.barcodeEAN = value,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Code barre',
                icon: const Icon(Icons.speaker_phone),
              ),
              // inputFormatters: <TextInputFormatter>[
              //   FilteringTextInputFormatter.allow(
              //       RegExp(r'^[0-9A-Da-d\$\+\-\.\/\:]$'))
              // ],
            ),
          ],
        ),
      ),
    );
  }
}
