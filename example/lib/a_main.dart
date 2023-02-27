import 'package:views_weebi_example/b_providers.dart';
import 'package:views_weebi_example/c_stores_loader.dart';

import 'package:flutter/material.dart';

import 'package:views_weebi_example/d_material_app.dart';

void main() {
  runApp(
    const ZeProviders(StoresLoader(ExampleApp())),
  );
}
