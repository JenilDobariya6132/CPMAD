/// Immutable data model for a recipe.
///
/// The same model is used for locally stored favourites and for recipes that
/// come back from Firestore, so [fromJson] has to tolerate the loosely typed
/// values the Firestore SDK hands us (everything arrives as `dynamic`).
class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    this.ingredients = const <String>[],
    this.steps = const <String>[],
    this.imageUrl = '',
    this.category = kUncategorised,
    this.isFavourite = false,
  });

  static const String kUncategorised = 'Uncategorised';

  final String id;
  final String title;
  final List<String> ingredients;
  final List<String> steps;
  final String imageUrl;
  final String category;

  /// Favourites live on the device only, they are never written to Firestore.
  final bool isFavourite;

  /// Builds a [Recipe] from a plain map (Firestore document or local JSON).
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      ingredients: _asStringList(json['ingredients']),
      steps: _asStringList(json['steps']),
      imageUrl: (json['imageUrl'] ?? json['image_url'] ?? '').toString(),
      category: _asCategory(json['category']),
      isFavourite: json['isFavourite'] as bool? ?? false,
    );
  }

  /// Serialises the recipe back to a map.
  ///
  /// [isFavourite] is stripped by default because it is device-local state and
  /// must not be pushed to the shared community collection.
  Map<String, dynamic> toJson({bool includeFavourite = true}) {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'ingredients': ingredients,
      'steps': steps,
      'imageUrl': imageUrl,
      'category': category,
      if (includeFavourite) 'isFavourite': isFavourite,
    };
  }

  /// Returns a copy with the given fields replaced.
  ///
  /// Because [isFavourite] is a `bool` (not nullable) we cannot use the usual
  /// `field ?? this.field` trick, so a dedicated sentinel flag is used instead
  /// of inventing a copy of the favourite state.
  Recipe copyWith({
    String? id,
    String? title,
    List<String>? ingredients,
    List<String>? steps,
    String? imageUrl,
    String? category,
    bool? isFavourite,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Recipe && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Recipe(id: $id, title: $title, category: $category, '
      'ingredients: ${ingredients.length}, steps: ${steps.length}, '
      'isFavourite: $isFavourite)';

  /// Coerces `List<dynamic>` / newline separated `String` into `List<String>`.
  static List<String> _asStringList(dynamic value) {
    if (value is List) {
      return value
          .map((dynamic e) => e.toString().trim())
          .where((String e) => e.isNotEmpty)
          .toList(growable: false);
    }
    if (value is String && value.trim().isNotEmpty) {
      return value
          .split('\n')
          .map((String e) => e.trim())
          .where((String e) => e.isNotEmpty)
          .toList(growable: false);
    }
    return const <String>[];
  }

  static String _asCategory(dynamic value) {
    final String category = (value ?? '').toString().trim();
    return category.isEmpty ? kUncategorised : category;
  }
}
