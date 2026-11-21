/// Dietary classification used by the home screen filter.
enum DietType {
  vegetarian('Vegetarian'),
  nonVegetarian('Non-Veg');

  const DietType(this.label);

  /// Human readable name shown in the UI.
  final String label;

  /// Tolerant parser: accepts the enum [name], the label, `veg` / `non-veg`
  /// spellings and a plain `bool`.
  static DietType fromJson(dynamic value) {
    if (value is bool) {
      return value ? DietType.vegetarian : DietType.nonVegetarian;
    }
    final String raw = (value ?? '')
        .toString()
        .trim()
        .toLowerCase()
        .replaceAll(RegExp('[^a-z]'), '');
    // A missing / blank value falls back to the model default rather than
    // silently labelling the recipe as non-vegetarian.
    if (raw.isEmpty) {
      return DietType.vegetarian;
    }
    return switch (raw) {
      'vegetarian' || 'veg' => DietType.vegetarian,
      _ => DietType.nonVegetarian,
    };
  }

  String toJson() => name;
}

/// Tri-state filter used by the home screen radio bar.
///
/// [all] carries a `null` [dietType], which is exactly what
/// `filterByDiet` interprets as "do not filter".
enum DietFilter {
  all('All', null),
  vegetarian('Vegetarian', DietType.vegetarian),
  nonVegetarian('Non-Veg', DietType.nonVegetarian);

  const DietFilter(this.label, this.dietType);

  final String label;
  final DietType? dietType;
}
