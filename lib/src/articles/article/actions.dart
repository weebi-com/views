import 'package:flutter/material.dart';
import 'package:models_weebi/base.dart';

//TODO using a dedicated function here is stupid
List<Widget> actionsArticleWidgetUnfinished<A extends ArticleAbstract>(
    BuildContext context,
    bool isShopLocked,
    A article,
    List<IconButton> iconButtons) {
  return <Widget>[
    for (final iconButton in iconButtons)
      if (!isShopLocked) iconButton,
  ];
}
