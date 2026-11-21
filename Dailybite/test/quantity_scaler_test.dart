import 'package:daily_bite/utils/quantity_scaler.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pure Dart tests for the serving-size maths behind the adjuster widget.
void main() {
  group('parseLeadingQuantity', () {
    test('reads integers, decimals and fractions', () {
      expect(parseLeadingQuantity('3 eggs'), 3);
      expect(parseLeadingQuantity('1.5 cups milk'), 1.5);
      expect(parseLeadingQuantity('1/2 tsp salt'), 0.5);
      expect(parseLeadingQuantity('1 1/2 cups flour'), 1.5);
      expect(parseLeadingQuantity('200 g spaghetti'), 200);
    });

    test('returns null when there is no leading number', () {
      expect(parseLeadingQuantity('Salt to taste'), isNull);
      expect(parseLeadingQuantity('Parmesan, grated'), isNull);
      expect(parseLeadingQuantity(''), isNull);
    });

    test('returns null for a zero denominator instead of dividing by zero', () {
      expect(parseLeadingQuantity('1/0 cups'), isNull);
    });
  });

  group('formatQuantity', () {
    test('drops trailing zeros', () {
      expect(formatQuantity(2), '2');
      expect(formatQuantity(2.0), '2');
      expect(formatQuantity(1.5), '1.5');
      expect(formatQuantity(0.25), '0.25');
      expect(formatQuantity(1 / 3), '0.33');
    });
  });

  group('scaleIngredient', () {
    test('scales whole numbers and units', () {
      expect(scaleIngredient('200 g spaghetti', 2), '400 g spaghetti');
      expect(scaleIngredient('3 eggs', 3), '9 eggs');
    });

    test('turns fractions into readable quantities', () {
      expect(scaleIngredient('1/2 tsp turmeric', 2), '1 tsp turmeric');
      expect(scaleIngredient('1/2 cup basil leaves', 3), '1.5 cup basil leaves');
      expect(scaleIngredient('1 1/2 cups flour', 2), '3 cups flour');
    });

    test('handles a serving decrease', () {
      expect(scaleIngredient('6 ripe tomatoes', 0.5), '3 ripe tomatoes');
    });

    test('leaves lines without a leading quantity untouched', () {
      expect(scaleIngredient('Salt to taste', 4), 'Salt to taste');
    });

    test('a factor of 1 is a no-op', () {
      expect(scaleIngredient('1/2 tsp salt', 1), '1/2 tsp salt');
    });
  });

  group('servingScaleFactor', () {
    test('divides target by base', () {
      expect(servingScaleFactor(2, 4), 2);
      expect(servingScaleFactor(4, 2), 0.5);
      expect(servingScaleFactor(3, 3), 1);
    });

    test('guards against a zero base', () {
      expect(servingScaleFactor(0, 4), 1);
    });
  });

  group('scaleIngredients', () {
    test('scales a whole list', () {
      expect(
        scaleIngredients(
          <String>['2 cups rice', '1/2 tsp salt', 'Salt to taste'],
          baseServings: 2,
          targetServings: 4,
        ),
        <String>['4 cups rice', '1 tsp salt', 'Salt to taste'],
      );
    });

    test('returns the original amounts when the servings do not change', () {
      expect(
        scaleIngredients(
          <String>['2 cups rice'],
          baseServings: 2,
          targetServings: 2,
        ),
        <String>['2 cups rice'],
      );
    });
  });
}
