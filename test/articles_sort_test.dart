import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models_weebi/dummies.dart';
import 'package:views_weebi/views_calibre.dart';
import 'package:views_weebi/src/demo/1_providers.dart';
import 'package:views_weebi/src/demo/2_stores_loader.dart';
import 'package:views_weebi/src/demo/3_material_app.dart';

void main() {
  testWidgets('check articles sorting by title and codeShortcut',
      (tester) async {
    await tester.pumpWidget(ProvidersW(StoresLoader(const ArticlesDemoApp(),
        articlesInitData: DummyArticleData.articleCalibresDummies,
        articlesPhotoInitData: const [])));
    // pumps ChassisTutoProducts and also ArticlesCalibresViewWIP
    await tester.pump();

    expect(find.text('Articles'), findsWidgets);

    final sortByCodeFound = find.byTooltip('Trier par code');
    expect(sortByCodeFound, findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_up), findsNothing);

    // by default Noix de Cola is first
    ArticleCalibreGlimpse item = tester
        .widgetList<ArticleCalibreGlimpse>(find.byType(ArticleCalibreGlimpse))
        .elementAt(0);
    expect(item.calibre.title, 'Noix de cola');
    expect(item.calibre.id, 1);

    // Tap the icon and trigger a frame
    // and verify that icon is updated and list reordered
    await tester.tap(sortByCodeFound);
    await tester.pump();
    expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    ArticleCalibreGlimpse itemCodeAfterReorder = tester
        .widgetList<ArticleCalibreGlimpse>(find.byType(ArticleCalibreGlimpse))
        .elementAt(0);
    expect('Sucre', itemCodeAfterReorder.calibre.title);
    expect(3, itemCodeAfterReorder.calibre.id);

    // and verify that icon is updated and list reordered back
    await tester.tap(sortByCodeFound);
    await tester.pump();
    expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_up), findsNothing);
    ArticleCalibreGlimpse itemCodeAfterRereorder = tester
        .widgetList<ArticleCalibreGlimpse>(find.byType(ArticleCalibreGlimpse))
        .elementAt(0);
    expect('Noix de cola', itemCodeAfterRereorder.calibre.title);
    expect(1, itemCodeAfterRereorder.calibre.id);

    // check sort by title works
    final sortByTitleFound = find.byTooltip('Trier par nom');
    expect(sortByTitleFound, findsOneWidget);
    await tester.tap(sortByTitleFound);
    await tester.pump();
    ArticleCalibreGlimpse itemTitleAfterReorder = tester
        .widgetList<ArticleCalibreGlimpse>(find.byType(ArticleCalibreGlimpse))
        .elementAt(0);
    expect('Babibel', itemTitleAfterReorder.calibre.title);
    expect(2, itemTitleAfterReorder.calibre.id);
  });
}
