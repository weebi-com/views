// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart' show LineOfArticles;
import 'package:models_base/utils.dart';

class LineArticleTileTitle extends StatelessWidget {
  final LineOfArticles line;
  final double lineLiveQt;
  final Color iconColor;
  const LineArticleTileTitle(this.line, this.lineLiveQt, this.iconColor,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Hero(
          tag: line.id,
          child: line?.articles?.first?.photo == null ||
                  line.articles.first.photo!.isEmpty
              ? const CircleAvatar(backgroundColor: Colors.transparent)
              : CircleAvatar(
                  foregroundImage:
                      AssetImage('assets/photos/${line.articles.first.photo}'),
                ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            '#${line.id}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              line.title, // (${line.stockUnitText})
              style: line.articles.first.status == false
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : const TextStyle(),
            ),
          ),
        ),
        if (line.title != '*') //
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(numFormat.format(lineLiveQt)),
              ),
              Icon(Icons.warehouse, color: iconColor),
            ],
          ),
      ],
    );
  }
}
