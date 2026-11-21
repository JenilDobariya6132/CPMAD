import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../models/recipe.dart';
import '../state/recipe_store.dart';
import 'recipe_card.dart';

/// Responsive grid of [RecipeCard]s.
///
/// Tapping a card opens the detail screen through the named route, passing the
/// full [Recipe] as the route argument.
class RecipeGrid extends StatelessWidget {
  const RecipeGrid({
    super.key,
    required this.recipes,
    this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 96),
  });

  final List<Recipe> recipes;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: recipes.length,
      itemBuilder: (BuildContext context, int index) {
        final Recipe recipe = recipes[index];
        return RecipeCard(
          recipe: recipe,
          onToggleFavourite: () =>
              context.read<RecipeStore>().toggleFavourite(recipe),
          onTap: () => Navigator.of(context).pushNamed(
            AppRoutes.recipeDetail,
            arguments: recipe,
          ),
        );
      },
    );
  }
}
