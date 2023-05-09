// Project imports:
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mixins_weebi/stores.dart';
import 'package:mixins_weebi/validators.dart';
import 'package:models_weebi/base.dart';
import 'package:models_weebi/common.dart';
import 'package:models_weebi/weebi_models.dart';
import 'package:provider/provider.dart';
import 'package:views_weebi/src/routes/articles/line_detail.dart';

import 'package:views_weebi/src/widgets/app_bar_weebi.dart';
import 'package:views_weebi/src/widgets/dialogs.dart';

class ArticleLineUpdateView<A extends ArticleAbstract> extends StatefulWidget {
  static const nameKey = Key('nom');
  final ArticleLine<A> line;
  const ArticleLineUpdateView(this.line, {Key key}) : super(key: key);

  @override
  State<ArticleLineUpdateView> createState() => _ArticleLineUpdateViewState();
}

class _ArticleLineUpdateViewState<A extends ArticleAbstract>
    extends State<ArticleLineUpdateView<A>> {
  ArticleLineUpdateFormStore store;
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    store = ArticleLineUpdateFormStore(articlesStore, widget.line);
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
      appBar: appBarWeebiUpdateNotSaved('Editer la ligne d\'articles',
          backgroundColor: Colors.orange[800]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          store.validateAll();
          if (store.hasErrors) {
            return;
          }
          try {
            final lineC = await store.updateLineArticleFromForm<A>(widget.line);
            // toastSuccessArticle(context, message: 'ligne mise à jour');
            Navigator.of(context).popAndPushNamed(
                ArticleLineRetailDetailRoute.generateRoute('${lineC.id}',
                    articleId: '1'));
          } on Exception catch (e) {
            return InformDialog.showDialogWeebiNotOk(
                "Erreur lors de la mise à jour de la ligne d\'article $e",
                context);
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
              builder: (_) => TextFormField(
                key: ArticleLineUpdateView.nameKey,
                initialValue: store.name,
                onChanged: (value) => store.name = value,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Nom de l\'article*',
                    icon: const Icon(Icons.short_text),
                    errorText: store.errorStore.nameError),
                autofocus: true,
              ),
            ),
            Observer(builder: (context) {
              return DropdownButtonFormField<StockUnit>(
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
                    store.stockUnit = value;
                  });
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
