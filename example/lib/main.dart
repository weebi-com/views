import 'package:views_weebi_example/c_stores_loader.dart';

import 'package:flutter/material.dart';

import 'package:views_weebi_example/d_material_app.dart';
import 'package:views_weebi/providers.dart';

void main() {
  runApp(
    const ProvidersW(StoresLoader(ExampleApp())),
  );
}
