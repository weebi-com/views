import 'package:flutter/material.dart';

class IconAddArticleBasket extends StatelessWidget {
  const IconAddArticleBasket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        Center(
          child: Icon(
            Icons.shopping_basket,
            color: Colors.white,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
