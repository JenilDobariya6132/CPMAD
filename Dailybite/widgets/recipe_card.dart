import 'package:flutter/material.dart';

import '../models/recipe.dart';

/// Compact, tappable recipe tile used by the home grid.
class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onToggleFavourite,
    this.onTap,
  });

  final Recipe recipe;
  final VoidCallback onToggleFavourite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: _buildImage(scheme)),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          recipe.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${recipe.category} · ${recipe.ingredients.length} items',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onToggleFavourite,
                    tooltip: recipe.isFavourite
                        ? 'Remove from favourites'
                        : 'Add to favourites',
                    icon: Icon(
                      recipe.isFavourite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: recipe.isFavourite ? scheme.primary : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(ColorScheme scheme) {
    if (recipe.imageUrl.isEmpty) {
      return _placeholder(scheme);
    }
    return Image.network(
      recipe.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent? progress,
      ) {
        if (progress == null) {
          return child;
        }
        return _placeholder(scheme, child: const CircularProgressIndicator());
      },
      errorBuilder: (
        BuildContext context,
        Object error,
        StackTrace? stackTrace,
      ) =>
          _placeholder(scheme, child: const Icon(Icons.restaurant, size: 32)),
    );
  }

  Widget _placeholder(ColorScheme scheme, {Widget? child}) {
    return Container(
      color: scheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: child,
    );
  }
}
