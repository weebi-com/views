import 'package:flutter_test/flutter_test.dart';

import 'package:models_weebi/common.dart';
import 'package:models_weebi/dummies.dart';
import 'package:models_weebi/weebi_models.dart';
import 'package:views_weebi/demo.dart';
import 'package:views_weebi/src/articles/article/article_retail/glimpse_a_retail.dart';
import 'package:views_weebi/views_calibre.dart';

void main() {
  testWidgets('article retail update widget test', (tester) async {
    await tester.pumpWidget(
      ProvidersW(
        StoresLoader(
          const ArticlesDemoApp(),
          articlesInitData: [...DummyArticleData.cola],
          articlesPhotoInitData: [
            ArticlePhoto(
                path: Base64Cola.colaBase64,
                source: PhotoSource.memory,
                calibreId: 1,
                id: 1),
            ArticlePhoto(
                path: Base64Cola.cola6Base64,
                source: PhotoSource.memory,
                calibreId: 1,
                id: 2),
            ArticlePhoto(
                path: 'cola_x100.jpg',
                source: PhotoSource.unknown,
                calibreId: 1,
                id: 3),
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
    await tester.pump();
    final articlesRetailGlimpses =
        tester.widgetList<ArticleRetailGlimpseWidget>(
            find.byType(ArticleRetailGlimpseWidget));
    expect(articlesRetailGlimpses.length, 3);

    final cola1 = articlesRetailGlimpses.elementAt(0);
    final cola1W = find.byWidget(cola1);
    await tester.tap(cola1W); // longPress
    await tester.pump();
    await tester.pump();

// yields : Warning: A call to tap() with finder "exactly one widget with the given widget (ArticleRetailGlimpseWidget) (ignoring offstage widgets): ArticleRetailGlimpseWidget" derived an Offset (Offset(400.0, 57.0)) that would not hit test on the specified widget.

    // open slideable cards
    // open cola 1
    // expect(find.text('#1.1'), findsWidgets);
  });
}
