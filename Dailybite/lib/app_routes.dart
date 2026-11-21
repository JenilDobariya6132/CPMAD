/// Names of the app's named routes.
///
/// Kept free of screen imports so the form-flow helper can reference route
/// names without creating an import cycle with the route factory.
abstract final class AppRoutes {
  /// Full-screen recipe detail; expects a `Recipe` as the route argument.
  static const String recipeDetail = '/recipe';

  /// Add / Edit form; expects a `Recipe?` (null means "create new").
  static const String addRecipe = '/recipe/edit';

  /// Static About screen.
  static const String about = '/about';

  /// Static Settings screen.
  static const String settings = '/settings';
}
