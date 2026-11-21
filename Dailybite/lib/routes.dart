import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'models/recipe.dart';
import 'screens/about_screen.dart';
import 'screens/add_edit_recipe_screen.dart';
import 'screens/recipe_detail_screen.dart';
import 'screens/settings_screen.dart';

/// Central route factory registered on [MaterialApp.onGenerateRoute].
///
/// The recipe detail route is a *named* route: the full [Recipe] object travels
/// as the route argument and is read straight out of [RouteSettings.arguments].
Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.recipeDetail:
      final Recipe recipe = settings.arguments! as Recipe;
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => RecipeDetailScreen(recipe: recipe),
      );
    case AppRoutes.addRecipe:
      return MaterialPageRoute<Recipe>(
        settings: settings,
        builder: (BuildContext context) =>
            AddEditRecipeScreen(recipe: settings.arguments as Recipe?),
      );
    case AppRoutes.about:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => const AboutScreen(),
      );
    case AppRoutes.settings:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => const SettingsScreen(),
      );
    default:
      return null;
  }
}
