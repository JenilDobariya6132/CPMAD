/// Scales ingredient lines when the serving size changes.
///
/// Ingredient lines in this app are free text, so scaling is done by rewriting
/// the *leading* quantity only: `"200 g spaghetti"` becomes `"400 g spaghetti"`
/// and `"1/2 tsp salt"` becomes `"1 tsp salt"` when the servings double. Lines
/// that do not start with a number (`"Salt to taste"`) are returned unchanged.
///
/// Everything here is pure Dart — no Flutter imports — so it can be unit tested
/// directly.
library;

/// Matches a leading quantity in one of these shapes:
/// `1 1/2` (mixed), `1/2` (fraction), `1.5` (decimal), `3` (integer).
final RegExp _leadingQuantity = RegExp(
  r'^(\d+\s+\d+\s*/\s*\d+|\d+\s*/\s*\d+|\d+(?:\.\d+)?)',
);

/// Reads the leading quantity of [ingredient], or `null` when the line does not
/// start with a number.
double? parseLeadingQuantity(String ingredient) {
  final Match? match = _leadingQuantity.firstMatch(ingredient.trim());
  if (match == null) {
    return null;
  }

  final String raw = match.group(1)!;
  if (!raw.contains('/')) {
    return double.tryParse(raw);
  }

  final List<String> parts = raw.split('/');
  final double? denominator = double.tryParse(parts[1].trim());
  if (denominator == null || denominator == 0) {
    return null;
  }

  final String numerator = parts[0].trim();
  if (numerator.contains(' ')) {
    // Mixed number, e.g. `1 1/2`.
    final List<String> mixed = numerator.split(RegExp(r'\s+'));
    final double? whole = double.tryParse(mixed[0]);
    final double? fraction = double.tryParse(mixed[1]);
    if (whole == null || fraction == null) {
      return null;
    }
    return whole + fraction / denominator;
  }

  final double? value = double.tryParse(numerator);
  return value == null ? null : value / denominator;
}

/// Renders [value] without noisy trailing zeros: `2.0` -> `2`, `1.50` -> `1.5`.
String formatQuantity(double value) {
  if (value == value.roundToDouble()) {
    return value.round().toString();
  }
  return value
      .toStringAsFixed(2)
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}

/// Multiplier that converts a recipe written for [baseServings] into
/// [targetServings]. A non-positive base yields `1` (no scaling) instead of
/// dividing by zero.
double servingScaleFactor(int baseServings, int targetServings) {
  if (baseServings <= 0) {
    return 1;
  }
  return targetServings / baseServings;
}

/// Returns [ingredient] with its leading quantity multiplied by [factor].
String scaleIngredient(String ingredient, double factor) {
  if (factor <= 0 || factor == 1) {
    return ingredient.trim();
  }

  final String trimmed = ingredient.trim();
  final Match? match = _leadingQuantity.firstMatch(trimmed);
  if (match == null) {
    return trimmed;
  }

  final double? quantity = parseLeadingQuantity(trimmed);
  if (quantity == null) {
    return trimmed;
  }

  return trimmed.replaceRange(
    match.start,
    match.end,
    formatQuantity(quantity * factor),
  );
}

/// Convenience wrapper for a whole ingredient list.
List<String> scaleIngredients(
  List<String> ingredients, {
  required int baseServings,
  required int targetServings,
}) {
  final double factor = servingScaleFactor(baseServings, targetServings);
  return ingredients
      .map((String line) => scaleIngredient(line, factor))
      .toList(growable: false);
}
