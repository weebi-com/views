// Flutter imports:
import 'package:flutter/material.dart';
import 'package:models_weebi/base.dart';
import 'package:views_weebi/src/articles/article/article_basket/ask_min_qt_basket.dart';
import 'package:views_weebi/src/widgets/ask_big_quantity.dart';

abstract class AskDialog {
  static Future<double> askBigQuantityDialog<A extends ArticleAbstract>(
      bool isStockOutput, A thisArticle, BuildContext context,
      {required double articleStockNow,
      double? articleQtInCart,
      bool isBasket = false}) async {
    double? lotBigQuantity = 0.0;
    lotBigQuantity = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (c) {
        return AskBigQuantity(isStockOutput,
            articleStockNow: articleStockNow,
            articleQtInCart: articleQtInCart,
            isBasket: isBasket);
      },
    );
    if (lotBigQuantity == null) {
      throw 'Annulé';
    }
    return lotBigQuantity;
  }

  static Future<double> askMinimumQuantityDialog(BuildContext context) async {
    double? minimumQuantity = 0.0;
    minimumQuantity = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (c) => const AskMinimumQuantity());
    if (minimumQuantity == null) {
      throw 'Annulé';
    }
    return minimumQuantity;
  }

  static Future<bool> areYouSure(
      String title, String message, BuildContext context,
      {required bool? barrierDismissible}) async {
    return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible ?? true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text(
                    'Annuler',
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('OK', overflow: TextOverflow.ellipsis),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static Future<bool> areYouSureUpdateNotSaved(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Modifications non sauvegardées'),
              content: const Text(
                  'Êtes-vous sûr de quitter la page sans enregister ?'),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: const Text(
                        'Non je n\'ai pas fini !',
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: const Text('Oui', overflow: TextOverflow.ellipsis),
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ) ??
        false;
  }

  static Future<bool> areYouSureQuitApp(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quitter l\'application ?'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text('Non'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Oui'),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
