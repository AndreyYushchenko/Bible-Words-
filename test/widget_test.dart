import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:bible_words/app.dart';
import 'package:bible_words/state/player_provider.dart';

void main() {
  testWidgets('Splash screen shows the app title and start button', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => PlayerProvider(),
        child: const BibleWordsApp(),
      ),
    );
    await tester.pump();

    expect(find.text('Bible'), findsOneWidget);
    expect(find.text('Words'), findsOneWidget);
    expect(find.text('Почати'), findsOneWidget);
  });

  testWidgets('Tapping Почати navigates to Home with categories and tab bar', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => PlayerProvider(),
        child: const BibleWordsApp(),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Почати'));
    await tester.pumpAndSettle();

    expect(find.text('Категорії'), findsOneWidget);
    expect(find.text('Імена людей'), findsOneWidget);
    expect(find.text('Головна'), findsOneWidget);
    expect(find.text('Профіль'), findsOneWidget);

    await tester.tap(find.text('Імена людей'));
    await tester.pumpAndSettle();

    expect(find.text('50 рівнів'), findsOneWidget);

    await tester.tap(find.text('1').first);
    await tester.pumpAndSettle();

    expect(find.text('Рівень 1'), findsOneWidget);
  });
}
