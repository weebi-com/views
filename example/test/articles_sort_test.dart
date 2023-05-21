import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:views_weebi/views_calibre.dart';
import 'package:views_weebi_example/src/1_providers.dart';
import 'package:views_weebi_example/src/2_stores_loader.dart';
import 'package:views_weebi_example/src/3_material_app.dart';
import 'package:views_weebi_example/src/article_calibre_dummy.dart';

void main() {
  testWidgets('check articles sorting by title and codeShortcut',
      (tester) async {
    await tester.pumpWidget(
        ProvidersW(StoresLoader(const ExampleApp(), articleCalibresDummies)));
    // pumps ChassisTutoProducts and also ArticlesCalibresViewWIP
    await tester.pump();

    expect(find.text('Articles'), findsWidgets);

    final sortByCodeFound = find.byTooltip('Trier par code');
    expect(sortByCodeFound, findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_up), findsNothing);

    // by default Noix de Cola is first
    ArticleCalibreFrame item = tester
        .widgetList<ArticleCalibreFrame>(find.byType(ArticleCalibreFrame))
        .elementAt(0);
    expect(item.calibre.title, 'Noix de cola');
    expect(item.calibre.id, 1);

    // Tap the icon and trigger a frame
    // and verify that icon is updated and list reordered
    await tester.tap(sortByCodeFound);
    await tester.pump();
    expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    ArticleCalibreFrame itemCodeAfterReorder = tester
        .widgetList<ArticleCalibreFrame>(find.byType(ArticleCalibreFrame))
        .elementAt(0);
    expect('Sucre', itemCodeAfterReorder.calibre.title);
    expect(3, itemCodeAfterReorder.calibre.id);

    // and verify that icon is updated and list reordered back
    await tester.tap(sortByCodeFound);
    await tester.pump();
    expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_up), findsNothing);
    ArticleCalibreFrame itemCodeAfterRereorder = tester
        .widgetList<ArticleCalibreFrame>(find.byType(ArticleCalibreFrame))
        .elementAt(0);
    expect('Noix de cola', itemCodeAfterRereorder.calibre.title);
    expect(1, itemCodeAfterRereorder.calibre.id);

    // check sort by title works
    final sortByTitleFound = find.byTooltip('Trier par nom');
    expect(sortByTitleFound, findsOneWidget);
    await tester.tap(sortByTitleFound);
    await tester.pump();
    ArticleCalibreFrame itemTitleAfterReorder = tester
        .widgetList<ArticleCalibreFrame>(find.byType(ArticleCalibreFrame))
        .elementAt(0);
    expect('Babibel', itemTitleAfterReorder.calibre.title);
    expect(2, itemTitleAfterReorder.calibre.id);
  });
}
