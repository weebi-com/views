import 'package:flutter/material.dart';
import 'package:models_weebi/weebi_models.dart';
import 'package:views_weebi/demo.dart';

void main() {
  runApp(
    ProvidersW(StoresLoader(
      const ArticlesDemoApp(),
      articlesInitData: ArticleCalibre.jams,
      articlesPhotoInitData: ArticleCalibre.jamsPhoto,
    )),
  );
}
