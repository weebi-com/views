import 'package:flutter/material.dart';
import 'package:models_weebi/base.dart' show ArticleAbstract;

extension ArticleIconA<A extends ArticleAbstract> on A {
  Icon get getIconForGenericA {
    if (id == 1) {
      return const Icon(Icons.filter_1);
    } else if (id == 2) {
      return const Icon(Icons.filter_2);
    } else if (id == 3) {
      return const Icon(Icons.filter_3);
    } else if (id == 4) {
      return const Icon(Icons.filter_4);
    } else if (id == 5) {
      return const Icon(Icons.filter_5);
    } else if (id == 6) {
      return const Icon(Icons.filter_6);
    } else if (id == 7) {
      return const Icon(Icons.filter_7);
    } else if (id == 8) {
      return const Icon(Icons.filter_8);
    } else if (id == 9) {
      return const Icon(Icons.filter_9);
    } else {
      return const Icon(Icons.filter_9_plus);
    }
  }
}

extension ArticleIcon on ArticleAbstract {
  Icon get getIcon {
    if (id == 1) {
      return const Icon(Icons.filter_1);
    } else if (id == 2) {
      return const Icon(Icons.filter_2);
    } else if (id == 3) {
      return const Icon(Icons.filter_3);
    } else if (id == 4) {
      return const Icon(Icons.filter_4);
    } else if (id == 5) {
      return const Icon(Icons.filter_5);
    } else if (id == 6) {
      return const Icon(Icons.filter_6);
    } else if (id == 7) {
      return const Icon(Icons.filter_7);
    } else if (id == 8) {
      return const Icon(Icons.filter_8);
    } else if (id == 9) {
      return const Icon(Icons.filter_9);
    } else {
      return const Icon(Icons.filter_9_plus);
    }
  }
}
