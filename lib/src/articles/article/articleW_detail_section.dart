// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart' show Article;
import 'package:models_base/utils.dart';
import 'package:views_weebi/widgets.dart';

class ArticleWDetailSection extends StatelessWidget {
  final Article article;
  final double articleLiveQt;
  const ArticleWDetailSection(this.article, this.articleLiveQt, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FieldValueWidget(
          const Icon(Icons.local_offer, color: Colors.teal),
          const Text("Prix de vente"),
          SelectableText(
            "${numFormat.format((article).price)}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        FieldValueWidget(
          const Icon(Icons.local_offer, color: Colors.red),
          const Text("Coût d'achat"),
          SelectableText(
            "${numFormat?.format((article).cost)}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        FieldValueWidget(
          const Icon(Icons.warehouse),
          const Text("Quantité"),
          SelectableText(
            '${numFormat?.format(articleLiveQt)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        FieldValueWidget(
          const Icon(Icons.style),
          const Text("Vendu par lots de "),
          SelectableText(
            "${article.weight}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        if (article?.articleCode != null &&
            '${article.articleCode}' != '${article.lineId}${article.id}')
          FieldValueWidget(
            const Icon(Icons.speaker_phone),
            const Text("Code barre"),
            SelectableText(
              "${article?.articleCode}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
