import 'dart:io';

import 'package:daily_bite/main.dart';
import 'package:daily_bite/screens/recipe_detail_screen.dart';
import 'package:daily_bite/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Boots the real app with (by default) an empty favourites store and a viewport
/// large enough that the whole grid is laid out (so `find.text` is
/// deterministic).
Future<void> pumpApp(
  WidgetTester tester, {
  Map<String, Object> initialPrefs = const <String, Object>{},
}) async {
  SharedPreferences.setMockInitialValues(initialPrefs);

  // `path_provider` has no platform implementation inside `flutter test`, so the
  // un-answered channel would leave `RecipeStore.load` pending forever. Point
  // it at a throwaway temp directory instead.
  final Directory tempDir =
      Directory.systemTemp.createTempSync('daily_bite_widget_test');
  addTearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/path_provider'),
    (MethodCall call) async => tempDir.path,
  );

  tester.view.physicalSize = const Size(1000, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(const DailyBiteApp());
  await tester.pumpAndSettle();
}

/// Finds the heart button that belongs to the card titled [title].
Finder heartInCard(String title) {
  return find.descendant(
    of: find.ancestor(
      of: find.text(title),
      matching: find.byType(RecipeCard),
    ),
    matching: find.byIcon(Icons.favorite_border),
  );
}

void main() {
  testWidgets('renders the AppBar, search field, diet filter and seed recipes',
      (WidgetTester tester) async {
    await pumpApp(tester);

    expect(find.widgetWithText(AppBar, 'DailyBite'), findsOneWidget);
    expect(find.text('Search recipes by title'), findsOneWidget);
    expect(find.text('Masala Omelette'), findsOneWidget);
    expect(find.widgetWithText(FilterChip, 'All'), findsOneWidget);

    // One radio per option in the diet filter bar.
    expect(find.byKey(const ValueKey<String>('diet-filter-all')), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('diet-filter-vegetarian')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('diet-filter-nonVegetarian')),
      findsOneWidget,
    );
  });

  testWidgets('searching narrows the visible recipes',
      (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.enterText(find.byType(TextField), 'pasta');
    await tester.pumpAndSettle();

    expect(find.text('Lemon Garlic Pasta'), findsOneWidget);
    expect(find.text('Masala Omelette'), findsNothing);
  });

  testWidgets('the diet radio filter updates the list immediately',
      (WidgetTester tester) async {
    await pumpApp(tester);

    expect(find.text('Lemon Garlic Pasta'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey<String>('diet-filter-nonVegetarian')),
    );
    await tester.pumpAndSettle();

    // Only the two non-veg seeds survive.
    expect(find.text('Masala Omelette'), findsOneWidget);
    expect(find.text('Grilled Chicken Salad'), findsOneWidget);
    expect(find.text('Lemon Garlic Pasta'), findsNothing);

    await tester.tap(find.byKey(const ValueKey<String>('diet-filter-all')));
    await tester.pumpAndSettle();

    expect(find.text('Lemon Garlic Pasta'), findsOneWidget);
  });

  testWidgets('tapping the heart on a card persists the favourite flag',
      (WidgetTester tester) async {
    await pumpApp(tester);

    expect(find.byIcon(Icons.favorite), findsNothing);

    await tester.tap(heartInCard('Masala Omelette'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite), findsOneWidget);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getStringList('daily_bite.favourite_ids'), <String>['seed-001']);
  });

  testWidgets('adding a recipe through the form appends it to the grid',
      (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Add Recipe'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('title-field')), 'Test Curry');
    await tester.enterText(
      find.byKey(const Key('ingredient-field-0')),
      '2 cups coconut milk',
    );
    await tester.enterText(
      find.byKey(const Key('step-field-0')),
      'Simmer everything for 20 minutes.',
    );

    await tester.tap(find.byKey(const Key('save-recipe-button')));
    await tester.pumpAndSettle();

    expect(find.text('Test Curry'), findsOneWidget);
    expect(find.text('Added "Test Curry".'), findsOneWidget);

    // Let the SnackBar dismiss so no timer outlives the test.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('the form validates an empty submission',
      (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Add Recipe'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('save-recipe-button')));
    await tester.pumpAndSettle();

    expect(find.text('A recipe needs a title.'), findsOneWidget);
    expect(find.text('Add at least one ingredient.'), findsOneWidget);
    expect(find.text('Add at least one step.'), findsOneWidget);
    // Still on the form.
    expect(find.byKey(const Key('title-field')), findsOneWidget);
  });

  testWidgets('the serving adjuster rescales ingredient quantities',
      (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Lemon Garlic Pasta'));
    await tester.pumpAndSettle();

    // Written for 2 servings.
    expect(find.text('200 g spaghetti'), findsOneWidget);

    await tester.tap(find.byTooltip('Increase servings'));
    await tester.pumpAndSettle();
    expect(find.text('300 g spaghetti'), findsOneWidget);

    await tester.tap(find.byTooltip('Increase servings'));
    await tester.pumpAndSettle();
    expect(find.text('400 g spaghetti'), findsOneWidget);

    await tester.tap(find.byTooltip('Decrease servings'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Decrease servings'));
    await tester.pumpAndSettle();
    expect(find.text('200 g spaghetti'), findsOneWidget);
  });

  testWidgets('a card opens the detail screen through the named route + Hero',
      (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Masala Omelette'));
    await tester.pumpAndSettle();

    expect(find.byType(RecipeDetailScreen), findsOneWidget);
    expect(find.byType(Hero), findsWidgets);
    expect(find.text('Ingredients'), findsOneWidget);
    expect(find.text('Steps'), findsOneWidget);
  });

  testWidgets('restores persisted favourite ids on app start',
      (WidgetTester tester) async {
    await pumpApp(
      tester,
      initialPrefs: <String, Object>{
        // seed-001 is "Masala Omelette".
        'daily_bite.favourite_ids': <String>['seed-001'],
      },
    );

    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('the bottom navigation switches between the three tabs',
      (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(
      find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.text('Favourites'),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('No favourites yet.\nTap the heart on a recipe to save it.'),
      findsOneWidget,
    );

    await tester.tap(
      find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.text('Profile'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('DailyBite Cook'), findsOneWidget);
  });

  testWidgets('the drawer opens the About screen',
      (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.text('Version 1.0.0'), findsOneWidget);
  });
}
