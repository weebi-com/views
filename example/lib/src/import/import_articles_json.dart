// Flutter imports:
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:models_weebi/extensions.dart';
import 'package:models_weebi/weebi_models.dart' show ArticleCalibre;
// Package imports:
import 'package:provider/provider.dart';
import 'package:views_weebi/styles.dart';
import 'package:mixins_weebi/stores.dart' show ArticlesStore;

// Project imports:
import 'package:views_weebi/widgets.dart' show InformDialog;

import 'package:views_weebi/widgets.dart' show AskDialog;
import 'import_provider_json.dart';

class ImportArticleCalibreJsonView extends StatelessWidget {
  static const title = 'Imports';
  const ImportArticleCalibreJsonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ImportProviderJson(),
        child: const ImportArticleCalibreJsonWidget());
  }
}

class ImportArticleCalibreJsonWidget extends StatefulWidget {
  const ImportArticleCalibreJsonWidget({Key? key}) : super(key: key);

  @override
  State<ImportArticleCalibreJsonWidget> createState() =>
      _ImportArticleCalibreJsonWidgetState();
}

class _ImportArticleCalibreJsonWidgetState
    extends State<ImportArticleCalibreJsonWidget> {
  @override
  Widget build(BuildContext context) {
    // final importProviderJson =
    //     Provider.of<ImportProviderJson>(context, listen: false);
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            ImportArticleCalibreJsonView.title,
            style: WeebiTextStyles.supportBig,
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(WeebiColors.orange),
              ),
              icon: const Icon(Icons.add),
              label: const Text("Ajouter"),
              onPressed: () async {
                final isOk = await AskDialog.areYouSure(
                    'Ajouter',
                    'Sans modifier les anciens articles, weebi va ajouter ceux qui ont un id unique',
                    context,
                    isDismissible: false);
                if (isOk == false) {
                  return;
                }
                final jsonText = await rootBundle
                    .loadString('assets/articles_confitures.json');
                final decoded = jsonDecode(jsonText);
                final deserialisedJson = <ArticleCalibre>[];
                deserialisedJson.addAll(List<ArticleCalibre>.from(decoded
                    .cast<Map>()
                    .cast<Map<String, dynamic>>()
                    .map((e) => ArticleCalibre.fromMap(e))));
                final twoLists = articlesStore.calibres
                    .findDupsById(newList: deserialisedJson);
                if (twoLists.noDups.isNotEmpty) {
                  final count =
                      await articlesStore.addAllArticleCalibre(twoLists.noDups);
                  if (count == 0) {
                    return InformDialog.showDialogWeebiNotOk(
                        "L'import des articles a échoué", context);
                  } else {
                    return InformDialog.showDialogWeebiOk(
                        "Import des $count articles terminé", context);
                  }
                }
              }),
        ),
        const Divider(),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(WeebiColors.orange),
              ),
              icon: const Icon(Icons.restore_page_outlined),
              label: const Text('Supprimer tous les articles'),
              onPressed: () async {
                final isOk = await AskDialog.areYouSure(
                    'Attention',
                    'Cette opération va effacer tous les articles.\nÊtes-vous sur de vouloir continuer ?',
                    context,
                    isDismissible: false);
                if (isOk == false) {
                  return;
                }
                if (await articlesStore.deleteAllArticlesAndCalibres() ==
                    false) {
                  return InformDialog.showDialogWeebiNotOk(
                      "La suppression des articles a échoué", context);
                } else {
                  return InformDialog.showDialogWeebiOk(
                      "Suppression de tous les articles terminée", context);
                }
              }),
        ),
      ],
    );
  }
}
