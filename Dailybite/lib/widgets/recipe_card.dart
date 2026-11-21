import 'package:flutter/material.dart';

import '../models/diet_type.dart';
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
            Expanded(
              child: Hero(tag: recipe.heroTag, child: _buildImage(scheme)),
            ),
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
                        const SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            _DietDot(dietType: recipe.dietType),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '${recipe.dietType.label} · ${recipe.category}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
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

/// Small green / red marker for the veg / non-veg classification.
class _DietDot extends StatelessWidget {
  const _DietDot({required this.dietType});

  final DietType dietType;

  @override
  Widget build(BuildContext context) {
    final bool isVeg = dietType == DietType.vegetarian;
    final Color color = isVeg ? const Color(0xFF2E7D32) : const Color(0xFFC62828);

    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
      ),
    );
  }
}
