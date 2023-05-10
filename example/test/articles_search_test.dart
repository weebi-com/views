import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:views_weebi/views_line.dart';
import 'package:views_weebi_example/example.dart';
import 'package:views_weebi/providers.dart';

void main() {
  testWidgets('check articles search by title', (tester) async {
    // pumps ChassisTutoProducts and also ArticlesLinesViewWIP
    await tester.pumpWidget(const ProvidersW(StoresLoader(ExampleApp())));
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
        .widgetList<ArticleLineFrame>(find.byType(ArticleLineFrame))
        .length;
    expect(itemsLength, 1);

    ArticleLineFrame lineFrameViewBabibel = tester
        .widgetList<ArticleLineFrame>(find.byType(ArticleLineFrame))
        .elementAt(0);
    expect(lineFrameViewBabibel.line.title, 'Babibel');
    expect(lineFrameViewBabibel.line.id, 2);

    // verify that close icon is there and works
    final closeIcon = find.byTooltip('Chercher un article');
    expect(closeIcon, findsOneWidget);
    await tester.tap(closeIcon);
    await tester.pump();
    expect(searchBar, findsNothing);

    final linesSearchClose =
        tester.widgetList<ArticleLineFrame>(find.byType(ArticleLineFrame));
    expect(linesSearchClose.isNotEmpty, isTrue);

    final ArticleLineFrame lineFrameView2 = linesSearchClose.elementAt(0);
    expect(lineFrameView2.line.articles.length, 3);
    expect(lineFrameView2.line.title, 'Noix de cola');
    expect(lineFrameView2.line.id, 1);
  });
}
