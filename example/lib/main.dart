import 'package:models_weebi/dummies.dart';
import 'package:flutter/material.dart';
import 'src/1_providers.dart';
import 'src/2_stores_loader.dart';
import 'src/3_material_app.dart';

void main() {
  runApp(
    ProvidersW(StoresLoader(const ExampleApp(), ArticleLinesDummyJamsBM.jams)),
  );
}
