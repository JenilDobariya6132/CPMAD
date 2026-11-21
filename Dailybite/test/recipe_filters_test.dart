import 'package:daily_bite/models/diet_type.dart';
import 'package:daily_bite/models/recipe.dart';
import 'package:daily_bite/utils/recipe_filters.dart';
import 'package:flutter_test/flutter_test.dart';

/// Plain Dart tests for the pure filtering / searching helpers. No Flutter
/// widgets are pumped here, which is exactly why these functions live outside
/// the widget tree.
void main() {
  const List<Recipe> recipes = <Recipe>[
    Recipe(id: '1', title: 'Masala Omelette', category: 'Breakfast'),
    Recipe(id: '2', title: 'Lemon Garlic Pasta', category: 'Dinner'),
    Recipe(id: '3', title: 'Tomato Basil Soup', category: 'Dinner'),
    Recipe(id: '4', title: 'Banana Oat Pancakes', category: 'Breakfast'),
    Recipe(
      id: '5',
      title: 'Grilled Chicken Salad',
      category: 'Lunch',
      dietType: DietType.nonVegetarian,
    ),
  ];

  group('filterByCategory', () {
    test('returns every recipe for All / null / empty', () {
      expect(filterByCategory(recipes, kAllCategories).length, 5);
      expect(filterByCategory(recipes, null).length, 5);
      expect(filterByCategory(recipes, '   ').length, 5);
    });

    test('matches case-insensitively', () {
      final List<Recipe> dinner = filterByCategory(recipes, 'dinner');
      expect(dinner.map((Recipe r) => r.id), <String>['2', '3']);
    });

    test('returns an empty list for an unknown category', () {
      expect(filterByCategory(recipes, 'Snacks'), isEmpty);
    });

    test('does not mutate the source list', () {
      filterByCategory(recipes, 'Dinner');
      expect(recipes.length, 5);
    });
  });

  group('searchByTitle', () {
    test('returns every recipe for a blank query', () {
      expect(searchByTitle(recipes, null).length, 5);
      expect(searchByTitle(recipes, '').length, 5);
    });

    test('finds partial, case-insensitive matches', () {
      final List<Recipe> hits = searchByTitle(recipes, 'pAn');
      expect(hits.map((Recipe r) => r.title), <String>['Banana Oat Pancakes']);
    });

    test('returns an empty list when nothing matches', () {
      expect(searchByTitle(recipes, 'sushi'), isEmpty);
    });
  });

  group('filterByDiet', () {
    test('null means All', () {
      expect(filterByDiet(recipes, null).length, 5);
    });

    test('keeps only non-veg recipes', () {
      final List<Recipe> nonVeg =
          filterByDiet(recipes, DietType.nonVegetarian);
      expect(nonVeg.map((Recipe r) => r.id), <String>['5']);
    });

    test('keeps only veg recipes', () {
      final List<Recipe> veg = filterByDiet(recipes, DietType.vegetarian);
      expect(veg.map((Recipe r) => r.id), <String>['1', '2', '3', '4']);
    });

    test('DietFilter maps onto the right DietType', () {
      expect(DietFilter.all.dietType, isNull);
      expect(DietFilter.vegetarian.dietType, DietType.vegetarian);
      expect(DietFilter.nonVegetarian.dietType, DietType.nonVegetarian);
    });
  });

  group('applyFilters', () {
    test('combines category and query', () {
      final List<Recipe> result =
          applyFilters(recipes, category: 'Breakfast', query: 'banana');
      expect(result.map((Recipe r) => r.id), <String>['4']);
    });

    test('combines diet, category and query', () {
      final List<Recipe> result = applyFilters(
        recipes,
        dietType: DietType.nonVegetarian,
        category: 'Lunch',
        query: 'chicken',
      );
      expect(result.map((Recipe r) => r.id), <String>['5']);

      expect(
        applyFilters(recipes, dietType: DietType.vegetarian, category: 'Lunch'),
        isEmpty,
      );
    });
  });

  group('availableCategories', () {
    test('is sorted, de-duplicated and prefixed with All', () {
      expect(
        availableCategories(recipes),
        <String>['All', 'Breakfast', 'Dinner', 'Lunch'],
      );
    });
  });

  group('Recipe model', () {
    test('round-trips through toJson / fromJson', () {
      const Recipe original = Recipe(
        id: 'x1',
        title: 'Test Dish',
        ingredients: <String>['a', 'b'],
        steps: <String>['do it'],
        imageUrl: 'https://example.com/a.png',
        category: 'Lunch',
        dietType: DietType.nonVegetarian,
        servings: 6,
        isFavourite: true,
      );

      final Recipe restored = Recipe.fromJson(original.toJson());
      expect(restored, original);
      expect(restored.ingredients, <String>['a', 'b']);
      expect(restored.dietType, DietType.nonVegetarian);
      expect(restored.servings, 6);
      expect(restored.isFavourite, isTrue);
    });

    test('fromJson is null-safe and coerces a newline separated string', () {
      final Recipe recipe = Recipe.fromJson(<String, dynamic>{
        'title': 'Only a title',
        'ingredients': 'salt\npepper',
      });

      expect(recipe.id, '');
      expect(recipe.category, Recipe.kUncategorised);
      expect(recipe.dietType, DietType.vegetarian);
      expect(recipe.servings, Recipe.kDefaultServings);
      expect(recipe.isFavourite, isFalse);
      expect(recipe.ingredients, <String>['salt', 'pepper']);
    });

    test('fromJson accepts a string servings value and a bool diet flag', () {
      final Recipe recipe = Recipe.fromJson(<String, dynamic>{
        'title': 'Soup',
        'servings': '4',
        'dietType': false,
      });

      expect(recipe.servings, 4);
      expect(recipe.dietType, DietType.nonVegetarian);
    });

    test('copyWith only replaces the provided fields', () {
      const Recipe recipe = Recipe(id: '1', title: 'Soup', category: 'Dinner');
      final Recipe updated = recipe.copyWith(isFavourite: true, servings: 4);

      expect(updated.title, 'Soup');
      expect(updated.category, 'Dinner');
      expect(updated.isFavourite, isTrue);
      expect(updated.servings, 4);
      expect(recipe.isFavourite, isFalse);
      expect(recipe.servings, Recipe.kDefaultServings);
    });

    test('toJson can omit the device-local favourite flag', () {
      const Recipe recipe = Recipe(id: '1', title: 'Soup', isFavourite: true);
      expect(
        recipe.toJson(includeFavourite: false).containsKey('isFavourite'),
        isFalse,
      );
    });
  });
}
