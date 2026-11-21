import 'diet_type.dart';

/// Immutable data model for a recipe.
///
/// The same model is used for locally stored favourites, for recipes authored
/// in the app, and for recipes that come back from Firestore, so [fromJson] has
/// to tolerate the loosely typed values the Firestore SDK hands us (everything
/// arrives as `dynamic`).
class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    this.ingredients = const <String>[],
    this.steps = const <String>[],
    this.imageUrl = '',
    this.category = kUncategorised,
    this.dietType = DietType.vegetarian,
    this.servings = kDefaultServings,
    this.isFavourite = false,
  });

  static const String kUncategorised = 'Uncategorised';

  /// Number of servings the [ingredients] quantities are written for.
  static const int kDefaultServings = 2;

  final String id;
  final String title;
  final List<String> ingredients;
  final List<String> steps;
  final String imageUrl;
  final String category;
  final DietType dietType;

  /// The quantity of food the ingredient amounts are written for. The serving
  /// size adjuster scales ingredient lines against this baseline.
  final int servings;

  /// Favourites live on the device only, they are never written to Firestore.
  final bool isFavourite;

  /// Shared `Hero` tag so the image morphs between the list card and the
  /// detail screen.
  String get heroTag => 'recipe-image-$id';

  /// Builds a [Recipe] from a plain map (Firestore document or local JSON).
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      ingredients: _asStringList(json['ingredients']),
      steps: _asStringList(json['steps']),
      imageUrl: (json['imageUrl'] ?? json['image_url'] ?? '').toString(),
      category: _asCategory(json['category']),
      dietType: DietType.fromJson(json['dietType'] ?? json['diet_type']),
      servings: _asInt(json['servings'], fallback: kDefaultServings),
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
      'dietType': dietType.toJson(),
      'servings': servings,
      if (includeFavourite) 'isFavourite': isFavourite,
    };
  }

  /// Returns a copy with the given fields replaced.
  Recipe copyWith({
    String? id,
    String? title,
    List<String>? ingredients,
    List<String>? steps,
    String? imageUrl,
    String? category,
    DietType? dietType,
    int? servings,
    bool? isFavourite,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      dietType: dietType ?? this.dietType,
      servings: servings ?? this.servings,
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
      'dietType: ${dietType.name}, servings: $servings, '
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

  static int _asInt(dynamic value, {required int fallback}) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString().trim() ?? '') ?? fallback;
  }
}
