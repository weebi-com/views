// Flutter imports:
import 'package:flutter/material.dart';
import 'package:models_weebi/base.dart';
import 'package:intl/intl.dart' as intl;
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
            SelectableText(intl.DateFormat('dd/MM/yyyy HH:mm:ss')
                .format(article.creationDate))),
        if (article.updateDate != null &&
            article.creationDate.isAtSameMomentAs(article.updateDate!) == false)
          FieldValueWidget(
              const Icon(Icons.event),
              const Text('date modification'),
              SelectableText(intl.DateFormat('dd/MM/yyyy HH:mm:ss')
                  .format(article.updateDate!))),
        if (article.statusUpdateDate != null &&
            article.creationDate.isAtSameMomentAs(article.statusUpdateDate!) ==
                false)
          FieldValueWidget(
            const Icon(Icons.event),
            const Text('date modification du statut'),
            SelectableText(
              intl.DateFormat('dd/MM/yyyy HH:mm:ss').format(
                  (article is ArticleRetail
                          ? article as ArticleRetail
                          : article as ArticleBasket)
                      .statusUpdateDate!),
            ),
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