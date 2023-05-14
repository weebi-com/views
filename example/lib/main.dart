import 'package:flutter/material.dart';
import 'package:views_weebi_example/src/jams.dart';
import 'src/1_providers.dart';
import 'src/2_stores_loader.dart';
import 'src/3_material_app.dart';

void main() {
  runApp(
    ProvidersW(
        StoresLoader(const ExampleApp(), ArticlesJams.jamsPhotoInAssets)),
  );
}
