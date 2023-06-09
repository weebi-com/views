import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mixins_weebi/stores.dart';
import 'package:mixins_weebi/validators.dart';
import 'package:models_weebi/common.dart';
import 'package:models_weebi/utils.dart';
import 'package:provider/provider.dart';
import 'package:views_weebi/src/articles/photo_picker.dart';
import 'package:views_weebi/src/routes/articles/article_detail.dart';
import 'package:views_weebi/src/styles/colors.dart';

import 'package:views_weebi/src/widgets/app_bar_weebi.dart';
import 'package:views_weebi/src/widgets/dialogs.dart';
import 'package:views_weebi/src/widgets/toast.dart';

class ArticleRetailCalibrateAndCreateView extends StatefulWidget {
  static const nameKey = Key('nom');
  static const priceKey = Key('prix');
  static const costKey = Key('coût');
  const ArticleRetailCalibrateAndCreateView({Key? key}) : super(key: key);

  @override
  State<ArticleRetailCalibrateAndCreateView> createState() =>
      _ArticleRetailCalibrateAndCreateViewState();
}

class _ArticleRetailCalibrateAndCreateViewState
    extends State<ArticleRetailCalibrateAndCreateView> with ToastWeebi {
  late ArticleCalibreCreateFormStore store;
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    store = ArticleCalibreCreateFormStore(articlesStore);
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
        appBar: appBarWeebiUpdateNotSaved('Créer un article',
            backgroundColor: WeebiColors.orange),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            store.validateAll();
            if (store.hasErrors) {
              return;
            }
            try {
              final articleLine =
                  await store.createLineAndArticleRetailFromForm();
              toastSuccessArticle(context, message: 'article créé');
              Navigator.of(context).popAndPushNamed(
                  ArticleDetailRoute.generateRoute('${articleLine.id}', '1'));
            } catch (e) {
              return InformDialog.showDialogWeebiNotOk(
                  "Erreur lors de la mise à jour de la ligne $e", context);
            }
          },
          backgroundColor: WeebiColors.orange,
          child: const Text('OK', style: TextStyle(color: Colors.white)),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: SingleChildScrollView(
            controller: controller,
            child: Column(children: <Widget>[
              Observer(
                  builder: (_) => AnimatedOpacity(
                      child: const LinearProgressIndicator(),
                      duration: const Duration(milliseconds: 300),
                      opacity: store.isArticleCreationPending ? 1 : 0)),
              Observer(
                name: 'nom',
                builder: (_) => TextField(
                  key: ArticleRetailCalibrateAndCreateView.nameKey,
                  onChanged: (value) => store.name = value,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: 'Nom de l\'article*',
                      icon: const Icon(Icons.short_text),
                      errorText: store.errorStore.nameError),
                  autofocus: true,
                ),
              ),
              Observer(
                name: 'prix',
                builder: (_) => TextField(
                  key: ArticleRetailCalibrateAndCreateView.priceKey,
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
                  key: ArticleRetailCalibrateAndCreateView.costKey,
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
                name: 'unité de compte',
                builder: (context) => DropdownButtonFormField<StockUnit>(
                  decoration: InputDecoration(
                    icon: const Icon(Icons.filter_frames),
                    label: const Text('Unité de compte'),
                  ),
                  items: StockUnit.units
                      .map((unit) => DropdownMenuItem<StockUnit>(
                            child: Text(unit.stockUnitText),
                            value: unit,
                          ))
                      .toList(),
                  value: store.stockUnit,
                  onChanged: (value) {
                    setState(() {
                      store.stockUnit = value ?? StockUnit.unit;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
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
              Observer(
                name: 'photo',
                builder: (context) => NotificationListener<PhotoChangedNotif>(
                  onNotification: (n) {
                    setState(() {
                      // _path = n.path;
                      store.photoPath = n.path;
                      // _source = n.photoSource;
                    });
                    return true;
                  },
                  child: PhotoStateless(
                    path: store.photoPath,
                    source: PhotoSource.file,
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}
