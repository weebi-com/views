import 'package:flutter/material.dart';
import 'package:models_weebi/weebi_models.dart';

List<Widget> actionsLineWidgetUnfinished(BuildContext context,
    bool isShopLocked, LineOfArticles line, List<IconButton> iconButtons) {
  return <Widget>[
    for (final iconButton in iconButtons)
      if (!isShopLocked) iconButton,
  ];
}
