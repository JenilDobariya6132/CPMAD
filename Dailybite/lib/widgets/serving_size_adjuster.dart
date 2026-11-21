import 'package:flutter/material.dart';

/// Calculator-style control for the number of servings.
///
/// The widget is stateless: it renders [servings] and reports every change
/// through [onChanged]. The parent owns the value and rebuilds with `setState`,
/// which is what triggers the ingredient quantities to be re-scaled.
class ServingSizeAdjuster extends StatelessWidget {
  const ServingSizeAdjuster({
    super.key,
    required this.servings,
    required this.onChanged,
    this.min = 1,
    this.max = 12,
    this.label = 'Servings',
  });

  final int servings;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final String label;

  void _step(int delta) {
    final int next = servings + delta;
    if (next < min || next > max) {
      return;
    }
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton.filledTonal(
              onPressed: servings > min ? () => _step(-1) : null,
              tooltip: 'Decrease servings',
              icon: const Icon(Icons.remove),
            ),
            SizedBox(
              width: 56,
              child: Text(
                '$servings',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            IconButton.filledTonal(
              onPressed: servings < max ? () => _step(1) : null,
              tooltip: 'Increase servings',
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        Slider(
          value: servings.toDouble().clamp(min.toDouble(), max.toDouble()),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          label: '$servings',
          onChanged: (double value) => onChanged(value.round()),
        ),
      ],
    );
  }
}
