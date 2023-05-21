// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:models_weebi/utils.dart';
// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:mixins_weebi/stores.dart' show ArticlesStore;
import 'package:views_weebi/src/widgets/ask_dialog.dart';

class PreviewArticlesProxiesSelectedWidget extends StatelessWidget {
  const PreviewArticlesProxiesSelectedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Observer(builder: (context) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          direction: Axis.vertical,
          children: [
            for (final articleSelected
                in articlesStore.articlesSelectedForBasketMinQt)
              Chip(
                onDeleted: () =>
                    articlesStore.removeArticleMinQtInSelected(articleSelected),
                deleteIcon: const Icon(Icons.close),
                label: InkWell(
                  onLongPress: () {
                    // TORuminate display article full info to avoid mistakes
                  },
                  onTap: () async {
                    final minQt =
                        await AskDialog.askMinimumQuantityDialog(context);
                    articlesStore.updateArticleMinQtInSelected(
                        articleSelected, minQt);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(articleSelected.fullName,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Wrap(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: const Icon(Icons.style),
                          ),
                          Text(
                            'x ${numFormat.format(articleSelected.minQt)}',
                            style: const TextStyle(
                                decoration: TextDecoration.underline),
                          ),
                          const Text(' unités/panier'),
                        ],
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.amberAccent,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              ),
          ],
        );
      }),
    );
  }
}
