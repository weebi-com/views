// Flutter imports:
import 'package:views_weebi/src/amount_provider.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:views_weebi/buttons.dart';

class WeebiOkPaddedQtDouble extends StatelessWidget {
  const WeebiOkPaddedQtDouble({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _qtEditVal =
        Provider.of<AmountProvider>(context, listen: true).textEditVal;
    return WeebiButtonOkRectWide(
      tooltip: 'valider',
      string: 'OK',
      onPressed: (double.tryParse(_qtEditVal.text) ?? 0) < 0.01
          ? null
          : () {
              Navigator.of(context)
                  .pop((double.tryParse(_qtEditVal.text) ?? 0.0));
            },
    );
  }
}

class WeebiOkPaddedInt extends StatelessWidget {
  const WeebiOkPaddedInt({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _qtEditVal =
        Provider.of<AmountProvider>(context, listen: true).textEditVal;
    return WeebiButtonOkRectWide(
      tooltip: 'valider',
      string: 'OK',
      onPressed: (int.tryParse(_qtEditVal.text) ?? 0) < 1
          ? null
          : () {
              Navigator.of(context).pop((int.tryParse(_qtEditVal.text) ?? 0));
            },
    );
  }
}
