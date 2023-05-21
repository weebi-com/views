import 'package:flutter/material.dart';

class PriceTotalBasketWidget extends StatelessWidget {
  final String totalPrice;
  const PriceTotalBasketWidget(this.totalPrice, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 2, 12, 2),
          child: const Icon(Icons.local_offer, color: Colors.teal),
        ),
        const Text('Prix de vente total : '),
        Expanded(
          child: SelectableText(
            totalPrice,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ]),
    );
  }
}
