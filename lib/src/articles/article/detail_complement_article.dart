// Flutter imports:
import 'package:flutter/material.dart';
import 'package:models_weebi/base.dart';
// Package imports:

// Project imports:
import 'package:models_weebi/weebi_models.dart'
    show ArticleBasket, ArticleRetail;
import 'package:views_weebi/widgets.dart';

class ArticleDetailComplementarySection<A extends ArticleAbstract>
    extends StatelessWidget {
  final A article;
  const ArticleDetailComplementarySection(
    this.article,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FieldValueWidget(const Icon(Icons.code), const Text('code'),
            SelectableText(article.articleCode.toString())),
        FieldValueWidget(
            const Icon(Icons.event),
            const Text('date création'),
            // ('dd/MM/yyyy HH:mm:ss')
            SelectableText(
                '${article.creationDate.day}/${article.creationDate.month}/${article.creationDate.year} ${article.creationDate.hour}:${article.creationDate.minute}:${article.creationDate.second}')),
        if (article.updateDate != null &&
            article.creationDate.isAtSameMomentAs(article.updateDate!) == false)
          FieldValueWidget(
              const Icon(Icons.event),
              const Text('date modification'),
              SelectableText(
                ('${article.updateDate?.day}/${article.updateDate?.month}/${article.updateDate?.year} ${article.updateDate?.hour}:${article.updateDate?.minute}:${article.updateDate?.second}'),
              )),
        if (article.statusUpdateDate != null &&
            article.creationDate.isAtSameMomentAs(article.statusUpdateDate!) ==
                false)
          FieldValueWidget(
            const Icon(Icons.event),
            const Text('date modification du statut'),
            SelectableText(
                '${article.statusUpdateDate!.day}/${article.statusUpdateDate!.month}/${article.statusUpdateDate!.year} ${article.statusUpdateDate!.hour}:${article.statusUpdateDate!.minute}:${article.statusUpdateDate!.second}'),
          ),
        FieldValueWidget(
            const Icon(Icons.settings_outlined),
            const Text('statut'),
            SelectableText(((article is ArticleRetail
                        ? article as ArticleRetail
                        : article as ArticleBasket)
                    .status)
                ? 'activé'
                : 'désactivé')),
      ],
    );
  }
}
