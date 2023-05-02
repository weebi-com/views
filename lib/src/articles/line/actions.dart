import 'package:flutter/material.dart';

List<Widget> actionsLineWidgetUnfinished(
    bool isShopLocked, List<IconButton> iconButtons) {
  return <Widget>[
    for (final iconButton in iconButtons)
      if (!isShopLocked) iconButton,
  ];
}
