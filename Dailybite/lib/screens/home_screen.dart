import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/diet_type.dart';
import '../models/recipe.dart';
import '../state/recipe_store.dart';
import '../utils/recipe_filters.dart';
import '../widgets/recipe_grid.dart';

/// Home tab: the community feed with a title search, a diet radio filter and
/// category chips.
///
/// The recipe list itself lives in [RecipeStore]; this screen only owns the
/// transient filter state. Cards open the detail screen through the shared
/// [RecipeGrid].
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = kAllCategories;
  DietFilter _dietFilter = DietFilter.all;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Applies the pure filtering helpers on top of the loaded recipes.
  List<Recipe> _visibleRecipes(List<Recipe> recipes) {
    return applyFilters(
      recipes,
      dietType: _dietFilter.dietType,
      category: _selectedCategory,
      query: _query,
    );
  }

  @override
  Widget build(BuildContext context) {
    final RecipeStore store = context.watch<RecipeStore>();
    final List<Recipe> recipes = store.recipes;
    final List<String> categories = availableCategories(recipes);
    final List<Recipe> visible = _visibleRecipes(recipes);

    return Column(
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
        _DietFilterBar(
          value: _dietFilter,
          onChanged: (DietFilter value) => setState(() => _dietFilter = value),
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
                onSelected: (_) => setState(() => _selectedCategory = category),
              );
            },
          ),
        ),
        Expanded(
          child: store.isLoading
              ? const Center(child: CircularProgressIndicator())
              : visible.isEmpty
                  ? const _EmptyState(message: 'No recipes match your filters.')
                  : RefreshIndicator(
                      onRefresh: store.load,
                      child: RecipeGrid(recipes: visible),
                    ),
        ),
      ],
    );
  }
}

/// Radio based filter bar: All / Vegetarian / Non-Veg.
///
/// The parent owns [value]; changing the selection calls [onChanged], which
/// rebuilds the list immediately through `setState`.
class _DietFilterBar extends StatelessWidget {
  const _DietFilterBar({required this.value, required this.onChanged});

  final DietFilter value;
  final ValueChanged<DietFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioGroup<DietFilter>(
      groupValue: value,
      onChanged: (DietFilter? next) {
        if (next != null) {
          onChanged(next);
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
        child: Row(
          children: DietFilter.values.map((DietFilter option) {
            return Expanded(
              child: RadioListTile<DietFilter>(
                key: ValueKey<String>('diet-filter-${option.name}'),
                value: option,
                title: Text(
                  option.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                dense: true,
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            );
          }).toList(growable: false),
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
