import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:views_weebi/views_calibre.dart';
import 'package:views_weebi_example/src/1_providers.dart';
import 'package:views_weebi_example/src/2_stores_loader.dart';
import 'package:views_weebi_example/src/3_material_app.dart';
import 'package:views_weebi_example/src/article_calibre_dummy.dart';

void main() {
  testWidgets('check articles search by title', (tester) async {
    // pumps ChassisTutoProducts and also ArticlesCalibresViewWIP
    await tester.pumpWidget(
        ProvidersW(StoresLoader(const ExampleApp(), articleCalibresDummies)));
    await tester.pump();
    expect(find.text('Articles'), findsWidgets);

    final searchArticleFound = find.byTooltip("Chercher un article");
    expect(searchArticleFound, findsOneWidget);
    await tester.tap(searchArticleFound);
    await tester.pump();

    final searchBar = find.byType(TextField);
    expect(searchBar, findsOneWidget);
    await tester.enterText(searchBar, 'ba');
    await tester.pump();
    int itemsLength = tester
        .widgetList<ArticleCalibreFrame>(find.byType(ArticleCalibreFrame))
        .length;
    expect(itemsLength, 1);

    ArticleCalibreFrame articleCalibreFrameViewBabibel = tester
        .widgetList<ArticleCalibreFrame>(find.byType(ArticleCalibreFrame))
        .elementAt(0);
    expect(articleCalibreFrameViewBabibel.calibre.title, 'Babibel');
    expect(articleCalibreFrameViewBabibel.calibre.id, 2);

    // verify that close icon is there and works
    final closeIcon = find.byTooltip('Chercher un article');
    expect(closeIcon, findsOneWidget);
    await tester.tap(closeIcon);
    await tester.pump();
    expect(searchBar, findsNothing);

    final linesSearchClose = tester
        .widgetList<ArticleCalibreFrame>(find.byType(ArticleCalibreFrame));
    expect(linesSearchClose.isNotEmpty, isTrue);

    final ArticleCalibreFrame lineFrameView2 = linesSearchClose.elementAt(0);
    expect(lineFrameView2.calibre.articles.length, 3);
    expect(lineFrameView2.calibre.title, 'Noix de cola');
    expect(lineFrameView2.calibre.id, 1);
  });
}
