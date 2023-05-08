import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:views_weebi/views.dart' show ArticleLineFrame;
import 'package:views_weebi_example/example.dart';
import 'package:views_weebi/providers.dart';

void main() {
  testWidgets('check articles sorting by title and codeShortcut',
      (tester) async {
    await tester.pumpWidget(const ZeProviders(StoresLoader(ExampleApp())));
    // pumps ChassisTutoProducts and also ArticlesLinesViewWIP
    await tester.pump();

    expect(find.text('Articles'), findsWidgets);

    final sortByCodeFound = find.byTooltip('Trier par code');
    expect(sortByCodeFound, findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_up), findsNothing);

    // by default Noix de Cola is first
    ArticleLineFrame item = tester
        .widgetList<ArticleLineFrame>(find.byType(ArticleLineFrame))
        .elementAt(0);
    expect(item.line.title, 'Noix de cola');
    expect(item.line.id, 1);

    // Tap the icon and trigger a frame
    // and verify that icon is updated and list reordered
    await tester.tap(sortByCodeFound);
    await tester.pump();
    expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    ArticleLineFrame itemCodeAfterReorder = tester
        .widgetList<ArticleLineFrame>(find.byType(ArticleLineFrame))
        .elementAt(0);
    expect('Babibel', itemCodeAfterReorder.line.title);
    expect(2, itemCodeAfterReorder.line.id);

    // and verify that icon is updated and list reordered back
    await tester.tap(sortByCodeFound);
    await tester.pump();
    expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_up), findsNothing);
    ArticleLineFrame itemCodeAfterRereorder = tester
        .widgetList<ArticleLineFrame>(find.byType(ArticleLineFrame))
        .elementAt(0);
    expect('Noix de cola', itemCodeAfterRereorder.line.title);
    expect(1, itemCodeAfterRereorder.line.id);

    // check sort by title works
    final sortByTitleFound = find.byTooltip('Trier par nom');
    expect(sortByTitleFound, findsOneWidget);
    await tester.tap(sortByTitleFound);
    await tester.pump();
    ArticleLineFrame itemTitleAfterReorder = tester
        .widgetList<ArticleLineFrame>(find.byType(ArticleLineFrame))
        .elementAt(0);
    expect('Babibel', itemTitleAfterReorder.line.title);
    expect(2, itemTitleAfterReorder.line.id);
  });
}
