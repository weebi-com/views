// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:models_weebi/utils.dart';
// Package imports:
import 'package:provider/provider.dart';
import 'package:views_weebi/src/articles/article/article_basket/ask_min_qt_basket.dart';

// Project imports:
import 'package:mixins_weebi/stores.dart' show ArticlesStore;

Future<double> askMinimumQuantityDialog(
  BuildContext context,
) async {
  double minimumQuantity = 0.0;
  minimumQuantity = await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (c) {
      return const AskMinimumQuantity();
    },
  );
  if (minimumQuantity == null) {
    throw 'Annulé';
  }
  return minimumQuantity;
}

class PreviewArticlesProxiesSelectedWidget extends StatelessWidget {
  const PreviewArticlesProxiesSelectedWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Observer(builder: (context) {
        return Wrap(
          spacing: 8,
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
                    final minQt = await askMinimumQuantityDialog(context);
                    articlesStore.updateArticleMinQtInSelected(
                        articleSelected, minQt);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(articleSelected.fullName),
                      const Text('qt minimum/panier :'),
                      Wrap(
                        children: [
                          const Icon(Icons.style),
                          Text('x ${numFormat.format(articleSelected.minQt)}')
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
