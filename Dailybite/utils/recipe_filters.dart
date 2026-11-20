/// Pure filtering / searching helpers.
///
/// They are deliberately free of any Flutter or Firebase dependency so they can
/// be exercised with plain Dart tests (see `test/recipe_filters_test.dart`).
/// None of them mutate the incoming list — they always return a new one.
library;

import '../models/recipe.dart';

/// Sentinel used by the category chips to mean "do not filter".
const String kAllCategories = 'All';

/// Returns every recipe whose [Recipe.category] matches [category]
/// (case-insensitive). Passing `null`, an empty string or [kAllCategories]
/// returns the full list.
List<Recipe> filterByCategory(List<Recipe> recipes, String? category) {
  if (category == null ||
      category.trim().isEmpty ||
      category == kAllCategories) {
    return List<Recipe>.unmodifiable(recipes);
  }
  final String target = category.trim().toLowerCase();
  return recipes
      .where((Recipe r) => r.category.toLowerCase() == target)
      .toList(growable: false);
}

/// Returns every recipe whose [Recipe.title] contains [query]
/// (case-insensitive). A blank [query] returns the full list.
List<Recipe> searchByTitle(List<Recipe> recipes, String? query) {
  final String q = (query ?? '').trim().toLowerCase();
  if (q.isEmpty) {
    return List<Recipe>.unmodifiable(recipes);
  }
  return recipes
      .where((Recipe r) => r.title.toLowerCase().contains(q))
      .toList(growable: false);
}

/// Convenience helper that applies the category filter and the title search in
/// one pass, which is what the home screen actually needs.
List<Recipe> applyFilters(
  List<Recipe> recipes, {
  String? category,
  String? query,
}) {
  return searchByTitle(filterByCategory(recipes, category), query);
}

/// Distinct categories present in [recipes], sorted alphabetically and prefixed
/// with [kAllCategories] for the filter bar.
List<String> availableCategories(List<Recipe> recipes) {
  final Set<String> unique = recipes
      .map((Recipe r) => r.category)
      .where((String c) => c.isNotEmpty)
      .toSet();
  final List<String> sorted = unique.toList()..sort();
  return <String>[kAllCategories, ...sorted];
}
