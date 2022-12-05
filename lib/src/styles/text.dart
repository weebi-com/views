import 'package:flutter/material.dart' show TextStyle, Colors, FontWeight;

class WeebiTextStyles {
  static const white = TextStyle(color: Colors.white);
  static const blackAndBold =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold);

  static const quickSandBig = TextStyle(
    fontFamily: 'Quicksand',
    fontSize: 18.0,
    color: Colors.black,
  );
  static const quickSandBigWhite = TextStyle(
    fontFamily: 'Quicksand',
    fontSize: 18.0,
    color: Colors.white,
  );

  static const supportBlack = TextStyle(
    fontFamily: 'PT_Sans-Narrow',
    fontSize: 16.0,
    color: Colors.black,
  );

  static const supportSmall = TextStyle(
    fontFamily: 'PT_Sans-Narrow',
    fontSize: 14.0,
  );

  static const supportBig = TextStyle(
      fontFamily: 'PT_Sans-Narrow',
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.bold);
}
