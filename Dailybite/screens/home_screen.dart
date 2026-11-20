import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../services/local_favourites_service.dart';
import '../services/recipe_service.dart';
import '../utils/recipe_filters.dart';
import '../widgets/recipe_card.dart';

/// Landing screen: shows the community feed with search, category filtering and
/// a favourites-only toggle.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.themeMode,
    required this.onToggleThemeMode,
  });

  final ThemeMode themeMode;
  final VoidCallback onToggleThemeMode;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeService _recipeService = const RecipeService();
  final LocalFavouritesService _favouritesService =
      const LocalFavouritesService();
  final TextEditingController _searchController = TextEditingController();

  List<Recipe> _recipes = const <Recipe>[];
  Set<String> _favouriteIds = <String>{};
  String _selectedCategory = kAllCategories;
  String _query = '';
  bool _showFavouritesOnly = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final List<Recipe> recipes = await _recipeService.fetchCommunityRecipes();
    final Set<String> favouriteIds =
        await _favouritesService.loadFavouriteIds();

    if (!mounted) {
      return;
    }

    setState(() {
      _favouriteIds = favouriteIds;
      _recipes = recipes
          .map((Recipe r) => r.copyWith(isFavourite: favouriteIds.contains(r.id)))
          .toList(growable: false);
      _isLoading = false;
    });
  }

  Future<void> _toggleFavourite(Recipe recipe) async {
    final Set<String> updated = Set<String>.of(_favouriteIds);
    if (recipe.isFavourite) {
      updated.remove(recipe.id);
    } else {
      updated.add(recipe.id);
    }

    await _favouritesService.saveFavouriteIds(updated);
    if (!mounted) {
      return;
    }

    setState(() {
      _favouriteIds = updated;
      _recipes = _recipes
          .map(
            (Recipe r) => r.id == recipe.id
                ? r.copyWith(isFavourite: updated.contains(r.id))
                : r,
          )
          .toList(growable: false);
    });
  }

  /// Applies the pure filtering helpers on top of the loaded recipes.
  List<Recipe> get _visibleRecipes {
    final List<Recipe> filtered = applyFilters(
      _recipes,
      category: _selectedCategory,
      query: _query,
    );
    if (!_showFavouritesOnly) {
      return filtered;
    }
    return filtered
        .where((Recipe r) => _favouriteIds.contains(r.id))
        .toList(growable: false);
  }

  void _openRecipe(Recipe recipe) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) => _RecipeDetails(recipe: recipe),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> categories = availableCategories(_recipes);
    final List<Recipe> visible = _visibleRecipes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DailyBite'),
        actions: <Widget>[
          IconButton(
            tooltip: _showFavouritesOnly ? 'Show all recipes' : 'Show favourites',
            onPressed: _isLoading
                ? null
                : () => setState(() => _showFavouritesOnly = !_showFavouritesOnly),
            icon: Icon(
              _showFavouritesOnly ? Icons.favorite : Icons.favorite_border,
            ),
          ),
          IconButton(
            tooltip: widget.themeMode == ThemeMode.dark
                ? 'Switch to light theme'
                : 'Switch to dark theme',
            onPressed: widget.onToggleThemeMode,
            icon: Icon(
              widget.themeMode == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onChanged: (String value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search recipes by title',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (BuildContext context, int index) {
                final String category = categories[index];
                return FilterChip(
                  label: Text(category),
                  selected: _selectedCategory == category,
                  onSelected: (_) =>
                      setState(() => _selectedCategory = category),
                );
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : visible.isEmpty
                ? _EmptyState(
                    message: _showFavouritesOnly
                        ? 'No favourites yet.\nTap the heart on a recipe to save it.'
                        : 'No recipes match your search.',
                  )
                : RefreshIndicator(
                    onRefresh: _loadData,
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 320,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: visible.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Recipe recipe = visible[index];
                        return RecipeCard(
                          recipe: recipe,
                          onToggleFavourite: () => _toggleFavourite(recipe),
                          onTap: () => _openRecipe(recipe),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _recipeService.isCommunityLive
                    ? 'Connected to the Firestore community feed.'
                    : 'Offline mode — showing bundled recipes.',
              ),
            ),
          );
        },
        icon: const Icon(Icons.cloud_outlined),
        label: Text(
          _recipeService.isCommunityLive ? 'Community live' : 'Offline mode',
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.no_food_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _RecipeDetails extends StatelessWidget {
  const _RecipeDetails({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController controller) {
        return ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          children: <Widget>[
            Text(recipe.title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              recipe.category,
              style: theme.textTheme.labelLarge
                  ?.copyWith(color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 20),
            Text('Ingredients', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ...recipe.ingredients.map(
              (String item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('• '),
                    Expanded(child: Text(item)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Steps', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ...recipe.steps.asMap().entries.map(
                  (MapEntry<int, String> entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${entry.key + 1}. '),
                        Expanded(child: Text(entry.value)),
                      ],
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }
}
