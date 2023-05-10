// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart' show ArticleLine;
import 'package:models_weebi/utils.dart';
import 'package:views_weebi/src/articles/photo.dart';

class LineArticleRetailTileTitle extends StatelessWidget {
  final ArticleLine line;
  final double lineLiveQt;
  final Color iconColor;
  const LineArticleRetailTileTitle(this.line, this.lineLiveQt, this.iconColor,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          height: 42,
          width: 42,
          child: Hero(
            tag: '${line.id}.${line.articles.first.id}',
            child: ClipOval(child: PhotoWidget(line.articles.first)),
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
