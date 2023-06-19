import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models_weebi/dummies.dart';
import 'package:views_weebi/views_calibre.dart';
import 'package:views_weebi/src/demo/1_providers.dart';
import 'package:views_weebi/src/demo/2_stores_loader.dart';
import 'package:views_weebi/src/demo/3_material_app.dart';

void main() {
  testWidgets('check articles search by title', (tester) async {
    // pumps ChassisTutoProducts and also ArticlesCalibresViewWIP
    await tester.pumpWidget(ProvidersW(StoresLoader(const ArticlesDemoApp(),
        articlesInitData: DummyArticleData.articleCalibresDummies,
        articlesPhotoInitData: const [])));
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
        .widgetList<ArticleCalibreGlimpse>(find.byType(ArticleCalibreGlimpse))
        .length;
    expect(itemsLength, 1);

    ArticleCalibreGlimpse articleCalibreFrameViewBabibel = tester
        .widgetList<ArticleCalibreGlimpse>(find.byType(ArticleCalibreGlimpse))
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
        .widgetList<ArticleCalibreGlimpse>(find.byType(ArticleCalibreGlimpse));
    expect(linesSearchClose.isNotEmpty, isTrue);

    final ArticleCalibreGlimpse lineFrameView2 = linesSearchClose.elementAt(0);
    expect(lineFrameView2.calibre.articles.length, 3);
    expect(lineFrameView2.calibre.title, 'Noix de cola');
    expect(lineFrameView2.calibre.id, 1);
  });
}
