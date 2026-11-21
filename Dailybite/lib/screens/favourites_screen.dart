import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../state/recipe_store.dart';
import '../widgets/recipe_grid.dart';

/// Favourites tab: every recipe the user has hearted, restored from
/// `shared_preferences` on start.
class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RecipeStore store = context.watch<RecipeStore>();

    if (store.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<Recipe> favourites = store.favouriteRecipes;
    if (favourites.isEmpty) {
      return const _EmptyFavourites();
    }

    return RecipeGrid(
      recipes: favourites,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
    );
  }
}

class _EmptyFavourites extends StatelessWidget {
  const _EmptyFavourites();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.favorite_border,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'No favourites yet.\nTap the heart on a recipe to save it.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
