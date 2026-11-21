import 'dart:io';

import 'package:daily_bite/models/diet_type.dart';
import 'package:daily_bite/models/recipe.dart';
import 'package:daily_bite/services/personal_recipes_store.dart';
import 'package:flutter_test/flutter_test.dart';

/// Exercises the `path_provider` + `dart:io` JSON persistence in isolation by
/// injecting a throw-away temp directory instead of the device documents dir.
void main() {
  late Directory tempDir;
  late PersonalRecipesStore store;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('daily_bite_personal_test');
    store = PersonalRecipesStore(directoryProvider: () async => tempDir);
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  test('returns an empty list when nothing has been saved yet', () async {
    expect(await store.load(), isEmpty);
  });

  test('round-trips personal recipes through the JSON file', () async {
    const Recipe recipe = Recipe(
      id: 'local-1',
      title: 'Test Curry',
      ingredients: <String>['2 cups coconut milk'],
      steps: <String>['Simmer everything.'],
      category: 'Dinner',
      dietType: DietType.nonVegetarian,
      servings: 3,
      isFavourite: true,
    );

    await store.save(<Recipe>[recipe]);

    final File file = File(
      '${tempDir.path}${Platform.pathSeparator}${PersonalRecipesStore.fileName}',
    );
    expect(file.existsSync(), isTrue);

    final List<Recipe> loaded = await store.load();
    expect(loaded, hasLength(1));
    expect(loaded.single.id, 'local-1');
    expect(loaded.single.title, 'Test Curry');
    expect(loaded.single.ingredients, <String>['2 cups coconut milk']);
    expect(loaded.single.steps, <String>['Simmer everything.']);
    expect(loaded.single.category, 'Dinner');
    expect(loaded.single.dietType, DietType.nonVegetarian);
    expect(loaded.single.servings, 3);
    // Favourite state is device-local and must never reach the JSON file.
    expect(loaded.single.isFavourite, isFalse);
  });

  test('ignores malformed JSON instead of throwing', () async {
    final File file = File(
      '${tempDir.path}${Platform.pathSeparator}${PersonalRecipesStore.fileName}',
    );
    file.writeAsStringSync('not json at all');

    expect(await store.load(), isEmpty);
  });
}
