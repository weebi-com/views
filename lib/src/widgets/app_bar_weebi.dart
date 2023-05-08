import 'package:flutter/material.dart';
import 'package:views_weebi/src/widgets/ask_are_you_sure.dart';
import 'package:views_weebi/widgets.dart' show AskDialog;

PreferredSizeWidget appBarWeebiUpdateNotSaved(String title,
    {Color backgroundColor, List<Widget> actions}) {
  return AppBar(
    backgroundColor: backgroundColor,
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            final isSureAboutQuitting =
                await AskDialog.areYouSureUpdateNotSaved(context);
            if (isSureAboutQuitting ?? false) {
              Navigator.of(context).pop();
            }
          },
        );
      },
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, textAlign: TextAlign.start),
      ],
    ),
    actions: actions ?? [],
  );
}
