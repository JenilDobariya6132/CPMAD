import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/diet_type.dart';
import '../models/recipe.dart';

/// Categories offered in the "Add / Edit recipe" form.
const List<String> kRecipeCategories = <String>[
  'Breakfast',
  'Lunch',
  'Dinner',
  'Snack',
  'Dessert',
];

/// Form screen used for both creating and editing a recipe.
///
/// Pops with the resulting [Recipe] when saved, or with `null` when cancelled.
class AddEditRecipeScreen extends StatefulWidget {
  const AddEditRecipeScreen({super.key, this.recipe});

  /// When non-null the form is pre-filled and the screen acts as an editor.
  final Recipe? recipe;

  bool get isEditing => recipe != null;

  @override
  State<AddEditRecipeScreen> createState() => _AddEditRecipeScreenState();
}

class _AddEditRecipeScreenState extends State<AddEditRecipeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _servingsController;
  late final List<TextEditingController> _ingredientControllers;
  late final List<TextEditingController> _stepControllers;

  late String _category;
  late DietType _dietType;

  String? _ingredientsError;
  String? _stepsError;

  @override
  void initState() {
    super.initState();

    final Recipe? existing = widget.recipe;

    _titleController = TextEditingController(text: existing?.title ?? '');
    _imageUrlController = TextEditingController(text: existing?.imageUrl ?? '');
    _servingsController = TextEditingController(
      text: '${existing?.servings ?? Recipe.kDefaultServings}',
    );
    _ingredientControllers = _controllersFor(existing?.ingredients);
    _stepControllers = _controllersFor(existing?.steps);
    _category = existing?.category ?? kRecipeCategories.first;
    _dietType = existing?.dietType ?? DietType.vegetarian;
  }

  static List<TextEditingController> _controllersFor(List<String>? values) {
    if (values == null || values.isEmpty) {
      return <TextEditingController>[TextEditingController()];
    }
    return values
        .map((String value) => TextEditingController(text: value))
        .toList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _servingsController.dispose();
    for (final TextEditingController controller in _ingredientControllers) {
      controller.dispose();
    }
    for (final TextEditingController controller in _stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<String> get _categoryOptions => kRecipeCategories.contains(_category)
      ? kRecipeCategories
      : <String>[_category, ...kRecipeCategories];

  List<String> _values(List<TextEditingController> controllers) => controllers
      .map((TextEditingController c) => c.text.trim())
      .where((String value) => value.isNotEmpty)
      .toList(growable: false);

  void _addRow(List<TextEditingController> controllers) {
    setState(() => controllers.add(TextEditingController()));
  }

  void _removeRow(List<TextEditingController> controllers, int index) {
    setState(() => controllers.removeAt(index).dispose());
  }

  void _save() {
    final List<String> ingredients = _values(_ingredientControllers);
    final List<String> steps = _values(_stepControllers);

    setState(() {
      _ingredientsError =
          ingredients.isEmpty ? 'Add at least one ingredient.' : null;
      _stepsError = steps.isEmpty ? 'Add at least one step.' : null;
    });

    // Validate everything in one pass so title, ingredient and step problems
    // surface together instead of one field at a time.
    final bool formValid = _formKey.currentState?.validate() ?? false;
    if (!formValid || ingredients.isEmpty || steps.isEmpty) {
      return;
    }

    final Recipe result = Recipe(
      id: widget.recipe?.id ??
          'local-${DateTime.now().microsecondsSinceEpoch.toString()}',
      title: _titleController.text.trim(),
      ingredients: ingredients,
      steps: steps,
      imageUrl: _imageUrlController.text.trim(),
      category: _category,
      dietType: _dietType,
      servings: int.parse(_servingsController.text.trim()),
      isFavourite: widget.recipe?.isFavourite ?? false,
    );

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Recipe' : 'Add Recipe'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: <Widget>[
            TextFormField(
              key: const Key('title-field'),
              controller: _titleController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Recipe title',
                hintText: 'e.g. Masala Omelette',
              ),
              validator: _validateTitle,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: _categoryOptions
                  .map(
                    (String option) => DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() => _category = value);
                }
              },
              validator: (String? value) =>
                  value == null ? 'Pick a category.' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<DietType>(
              initialValue: _dietType,
              decoration: const InputDecoration(labelText: 'Diet'),
              items: DietType.values
                  .map(
                    (DietType type) => DropdownMenuItem<DietType>(
                      value: type,
                      child: Text(type.label),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (DietType? value) {
                if (value != null) {
                  setState(() => _dietType = value);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('servings-field'),
              controller: _servingsController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: 'Servings',
                helperText: 'The ingredient amounts below are written for this.',
              ),
              validator: _validateServings,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageUrlController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Image URL (optional)',
                hintText: 'https://…',
              ),
              validator: _validateImageUrl,
            ),
            const SizedBox(height: 24),
            _SectionHeader(
              title: 'Ingredients',
              onAdd: () => _addRow(_ingredientControllers),
            ),
            if (_ingredientsError != null) _ErrorText(_ingredientsError!),
            ..._buildRows(
              controllers: _ingredientControllers,
              keyPrefix: 'ingredient-field',
              hint: 'e.g. 200 g spaghetti',
            ),
            const SizedBox(height: 24),
            _SectionHeader(
              title: 'Steps',
              onAdd: () => _addRow(_stepControllers),
            ),
            if (_stepsError != null) _ErrorText(_stepsError!),
            ..._buildRows(
              controllers: _stepControllers,
              keyPrefix: 'step-field',
              hint: 'e.g. Boil the spaghetti until al dente.',
            ),
            const SizedBox(height: 12),
            Text(
              'Tip: start an ingredient with a quantity (200, 1.5 or 1/2) so the '
              'serving adjuster can scale it.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton.icon(
            key: const Key('save-recipe-button'),
            onPressed: _save,
            icon: const Icon(Icons.check),
            label: Text(widget.isEditing ? 'Save changes' : 'Add recipe'),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRows({
    required List<TextEditingController> controllers,
    required String keyPrefix,
    required String hint,
  }) {
    return List<Widget>.generate(controllers.length, (int index) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: TextFormField(
                key: Key('$keyPrefix-$index'),
                controller: controllers[index],
                decoration: InputDecoration(hintText: hint),
              ),
            ),
            IconButton(
              tooltip: 'Remove',
              // Always keep one row so the field never disappears entirely.
              onPressed: controllers.length > 1
                  ? () => _removeRow(controllers, index)
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
          ],
        ),
      );
    });
  }

  String? _validateTitle(String? value) {
    final String title = (value ?? '').trim();
    if (title.isEmpty) {
      return 'A recipe needs a title.';
    }
    if (title.length < 3) {
      return 'Use at least 3 characters.';
    }
    return null;
  }

  String? _validateServings(String? value) {
    final int? servings = int.tryParse((value ?? '').trim());
    if (servings == null) {
      return 'Enter the number of servings.';
    }
    if (servings < 1 || servings > 12) {
      return 'Servings must be between 1 and 12.';
    }
    return null;
  }

  String? _validateImageUrl(String? value) {
    final String url = (value ?? '').trim();
    if (url.isEmpty) {
      return null;
    }
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'Image URL must start with http:// or https://';
    }
    return null;
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onAdd});

  final String title;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: const Text('Add'),
        ),
      ],
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 12,
        ),
      ),
    );
  }
}
