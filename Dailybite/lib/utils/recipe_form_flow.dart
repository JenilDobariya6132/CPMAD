import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../models/recipe.dart';
import '../state/recipe_store.dart';

/// Pushes the Add / Edit form as a named route, stores the returned recipe and
/// shows a confirmation snack bar.
///
/// Shared by the Home FAB and the detail screen's "Edit" action so both stay in
/// sync with the single [RecipeStore].
Future<void> openRecipeForm(BuildContext context, {Recipe? existing}) async {
  final NavigatorState navigator = Navigator.of(context);
  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
  final RecipeStore store = context.read<RecipeStore>();

  final Recipe? result = await navigator.pushNamed<Recipe>(
    AppRoutes.addRecipe,
    arguments: existing,
  );

  if (result == null) {
    return;
  }

  await store.upsertRecipe(result);

  messenger.showSnackBar(
    SnackBar(
      content: Text(
        existing == null ? 'Added "${result.title}".' : 'Saved changes.',
      ),
    ),
  );
}
