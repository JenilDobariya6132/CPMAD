import 'package:flutter/foundation.dart';

import '../models/recipe.dart';
import '../services/local_favourites_service.dart';
import '../services/personal_recipes_store.dart';
import '../services/recipe_service.dart';

/// Single source of truth for the recipe list and the device-local favourite
/// ids.
///
/// Home, Favourites and the detail screen all observe this one store, so adding
/// a recipe or toggling a favourite anywhere is reflected everywhere. The
/// favourite ids are persisted with `shared_preferences` and restored on start,
/// and the user's own recipes are mirrored to a JSON file on the device.
class RecipeStore extends ChangeNotifier {
  RecipeStore({
    RecipeService recipeService = const RecipeService(),
    LocalFavouritesService favouritesService = const LocalFavouritesService(),
    PersonalRecipesStore? personalRecipesStore,
  })  : _recipeService = recipeService,
        _favouritesService = favouritesService,
        _personalStore = personalRecipesStore ?? PersonalRecipesStore();

  final RecipeService _recipeService;
  final LocalFavouritesService _favouritesService;
  final PersonalRecipesStore _personalStore;

  List<Recipe> _recipes = const <Recipe>[];
  List<Recipe> _personalRecipes = const <Recipe>[];
  Set<String> _favouriteIds = <String>{};
  bool _isLoading = true;
  bool _communityLive = false;
  bool _disposed = false;

  List<Recipe> get recipes => _recipes;
  List<Recipe> get personalRecipes => _personalRecipes;
  bool get isLoading => _isLoading;
  bool get isCommunityLive => _communityLive;
  Set<String> get favouriteIds => _favouriteIds;

  List<Recipe> get favouriteRecipes => _recipes
      .where((Recipe recipe) => recipe.isFavourite)
      .toList(growable: false);

  bool isFavourite(String recipeId) => _favouriteIds.contains(recipeId);

  /// Loads the community feed, the saved personal recipes and the persisted
  /// favourite ids. Called once when the app starts.
  Future<void> load() async {
    _isLoading = true;
    _safeNotify();

    _communityLive = _recipeService.isCommunityLive;

    final List<Recipe> community = await _recipeService.fetchCommunityRecipes();
    final List<Recipe> personal = await _personalStore.load();
    final Set<String> favourites = await _favouritesService.loadFavouriteIds();

    _favouriteIds = favourites;
    _personalRecipes = personal;

    // Personal recipes first, then the community feed, de-duplicated by id and
    // with the restored favourite flag applied.
    final Map<String, Recipe> merged = <String, Recipe>{};
    for (final Recipe recipe in <Recipe>[...personal, ...community]) {
      merged[recipe.id] = recipe.copyWith(
        isFavourite: favourites.contains(recipe.id),
      );
    }
    _recipes = merged.values.toList(growable: false);

    _isLoading = false;
    _safeNotify();
  }

  Future<void> toggleFavourite(Recipe recipe) async {
    final Set<String> updated = Set<String>.of(_favouriteIds);
    if (recipe.isFavourite) {
      updated.remove(recipe.id);
    } else {
      updated.add(recipe.id);
    }

    _favouriteIds = updated;
    _recipes = _recipes
        .map(
          (Recipe r) => r.id == recipe.id
              ? r.copyWith(isFavourite: updated.contains(r.id))
              : r,
        )
        .toList(growable: false);
    _safeNotify();

    await _favouritesService.saveFavouriteIds(updated);
  }

  /// Removes every favourite and clears the persisted ids.
  Future<void> clearFavourites() async {
    if (_favouriteIds.isEmpty) {
      return;
    }
    _favouriteIds = <String>{};
    _recipes = _recipes
        .map((Recipe r) => r.copyWith(isFavourite: false))
        .toList(growable: false);
    _safeNotify();

    await _favouritesService.saveFavouriteIds(_favouriteIds);
  }

  /// Inserts a new recipe or replaces an existing one (matched by id). Recipes
  /// created in the app (`local-…`) are also written to the JSON file.
  Future<void> upsertRecipe(Recipe recipe) async {
    final List<Recipe> next = List<Recipe>.of(_recipes);
    final int index = next.indexWhere((Recipe r) => r.id == recipe.id);
    if (index == -1) {
      next.insert(0, recipe);
    } else {
      next[index] = recipe;
    }
    _recipes = next;
    _safeNotify();

    if (recipe.id.startsWith('local-')) {
      final Map<String, Recipe> personal = <String, Recipe>{
        for (final Recipe r in _personalRecipes) r.id: r,
      };
      personal[recipe.id] = recipe;
      _personalRecipes = personal.values.toList(growable: false);
      await _personalStore.save(_personalRecipes);
    }
  }

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
