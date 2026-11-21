import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../state/recipe_store.dart';
import '../utils/quantity_scaler.dart';
import '../utils/recipe_form_flow.dart';
import '../widgets/serving_size_adjuster.dart';

/// Full-screen recipe detail, reached through the named `AppRoutes.recipeDetail`
/// route with the [Recipe] passed as the route argument.
///
/// The serving adjuster is owned here: moving it calls `setState` and the
/// ingredient quantities re-scale through [scaleIngredients].
class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late int _servings = widget.recipe.servings;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final RecipeStore store = context.watch<RecipeStore>();

    // Re-read from the store so favourite toggles / edits stay in sync.
    final Recipe recipe = store.recipes.firstWhere(
      (Recipe r) => r.id == widget.recipe.id,
      orElse: () => widget.recipe,
    );

    final bool isScaled = _servings != recipe.servings;
    final List<String> ingredients = scaleIngredients(
      recipe.ingredients,
      baseServings: recipe.servings,
      targetServings: _servings,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        actions: <Widget>[
          IconButton(
            tooltip: recipe.isFavourite
                ? 'Remove from favourites'
                : 'Add to favourites',
            onPressed: () => store.toggleFavourite(recipe),
            icon: Icon(
              recipe.isFavourite ? Icons.favorite : Icons.favorite_border,
              color: recipe.isFavourite ? theme.colorScheme.primary : null,
            ),
          ),
          IconButton(
            tooltip: 'Edit recipe',
            onPressed: () => openRecipeForm(context, existing: recipe),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: <Widget>[
          Hero(tag: recipe.heroTag, child: _buildHeroImage(theme, recipe)),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Chip(
                      label: Text(recipe.category),
                      visualDensity: VisualDensity.compact,
                    ),
                    Chip(
                      label: Text(recipe.dietType.label),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ServingSizeAdjuster(
                  servings: _servings,
                  onChanged: (int value) => setState(() => _servings = value),
                ),
                const Divider(height: 32),
                Row(
                  children: <Widget>[
                    Text('Ingredients', style: theme.textTheme.titleMedium),
                    const Spacer(),
                    Text(
                      isScaled ? 'written for ${recipe.servings}' : 'as written',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...ingredients.map(
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
                if (isScaled)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Quantities scaled ${_servings / recipe.servings}x '
                      'for $_servings servings.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(ThemeData theme, Recipe recipe) {
    const double height = 240;
    final Color placeholderColor = theme.colorScheme.surfaceContainerHighest;

    if (recipe.imageUrl.isEmpty) {
      return Container(
        height: height,
        color: placeholderColor,
        alignment: Alignment.center,
        child: const Icon(Icons.restaurant, size: 48),
      );
    }

    return Image.network(
      recipe.imageUrl,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent? progress,
      ) {
        if (progress == null) {
          return child;
        }
        return Container(
          height: height,
          color: placeholderColor,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
      },
      errorBuilder: (
        BuildContext context,
        Object error,
        StackTrace? stackTrace,
      ) =>
          Container(
        height: height,
        color: placeholderColor,
        alignment: Alignment.center,
        child: const Icon(Icons.restaurant, size: 48),
      ),
    );
  }
}
