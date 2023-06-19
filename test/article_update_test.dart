import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:models_weebi/common.dart';
import 'package:models_weebi/dummies.dart';
import 'package:models_weebi/weebi_models.dart';
import 'package:views_weebi/demo.dart';
import 'package:views_weebi/views_article.dart';
import 'package:views_weebi/views_calibre.dart';

void main() {
  testWidgets('article retail update widget test', (tester) async {
    await tester.pumpWidget(
      ProvidersW(
        StoresLoader(
          const ArticlesDemoApp(),
          articlesInitData: [DummyArticleData.articleCalibreDummySugar],
          articlesPhotoInitData: [
            ArticlePhoto(
                path: Base64Cola.colaBase64, // pretend this is sugar
                source: PhotoSource.memory,
                calibreId: 3,
                id: 1),
          ],
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Articles'), findsWidgets);
    final calibres = tester
        .widgetList<ArticleCalibreGlimpse>(find.byType(ArticleCalibreGlimpse));
    expect(calibres.length, 1);
    final ArticleCalibreGlimpse calibreGlimpse = calibres.elementAt(0);
    final calibreGlimpseW = find.byWidget(calibreGlimpse);
    await tester.tap(calibreGlimpseW);
    await tester.pump();
    await tester.pump();

    // TODO check glimpse photo is displayed

    // ArticleDetailWidget
    expect(find.byType(ArticleDetailWidget), findsOneWidget);
    expect(find.text('#3.1'), findsOneWidget);
    final editIcon = find.byIcon(Icons.edit);
    await tester.tap(editIcon);
    await tester.pump();
    await tester.pump();

    expect(find.byType(ArticleRetailUpdateView), findsOneWidget);
    expect(find.text('Editer l\'article 3.1'), findsWidgets);
    expect(find.byIcon(Icons.local_offer), findsWidgets); // price & cost
    expect(find.byIcon(Icons.speaker_phone), findsOneWidget); // barcode
    expect(find.byIcon(Icons.folder_open), findsNothing); // photo
    // static const fullNameKey = Key('nom');
    // static const priceKey = Key('prix');
    // static const costKey = Key('coût');
  });
}
