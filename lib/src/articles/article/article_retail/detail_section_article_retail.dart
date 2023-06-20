// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mixins_weebi/stock.dart';
import 'package:models_weebi/utils.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart' show ArticleRetail;
import 'package:views_weebi/widgets.dart';

class ArticleRetailDetailSection extends StatelessWidget {
  final ArticleRetail article;
  final ArticleRetailStockNow articleRetailStockNow;
  const ArticleRetailDetailSection(
    this.article,
    this.articleRetailStockNow,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FieldValueWidget(
          const Icon(Icons.local_offer, color: Colors.teal),
          const Text("Prix de vente"),
          SelectableText(
            numFormat.format((article).price),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        FieldValueWidget(
          const Icon(Icons.local_offer, color: Colors.red),
          const Text("Coût d'achat"),
          SelectableText(
            numFormat.format((article).cost),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        FieldValueWidget(
          const Icon(Icons.warehouse),
          const Text("Quantité"),
          SelectableText(
            numFormat.format(articleRetailStockNow.stockNow),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        FieldValueWidget(
          const Icon(Icons.style),
          const Text("Unités par pièce"),
          SelectableText(
            "${article.weight}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        if (article.barcodeEAN.isNotEmpty &&
            '${article.barcodeEAN}' != '${article.calibreId}${article.id}')
          FieldValueWidget(
            const Icon(Icons.speaker_phone),
            const Text("Code barre"),
            SelectableText(
              "${article.barcodeEAN}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
