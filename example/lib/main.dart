import 'package:models_weebi/dummies.dart';
import 'package:views_weebi_example/example.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    ProvidersW(StoresLoader(const ExampleApp(), ArticleLinesDummyJamsBM.jams)),
  );
}
