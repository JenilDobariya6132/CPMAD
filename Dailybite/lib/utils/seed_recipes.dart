import '../models/diet_type.dart';
import '../models/recipe.dart';

// Bundled recipes used for local development and as the offline fallback for
// the Firestore-backed community feed.

const List<Recipe> kSeedRecipes = <Recipe>[
  Recipe(
    id: 'seed-001',
    title: 'Masala Omelette',
    category: 'Breakfast',
    dietType: DietType.nonVegetarian,
    servings: 2,
    imageUrl:
        'https://coresg-normal.trae.ai/api/ide/v1/text_to_image?prompt=fluffy%20masala%20omelette%20on%20a%20ceramic%20plate%20top%20view%20food%20photography&image_size=landscape_4_3',
    ingredients: <String>[
      '3 eggs',
      '1 small onion, finely chopped',
      '1 green chilli, chopped',
      '1/2 tsp turmeric',
      'Salt and pepper',
    ],
    steps: <String>[
      'Whisk the eggs with salt and pepper until frothy.',
      'Fold in the onion, chilli and turmeric.',
      'Cook on a medium flame for 2 minutes per side.',
      'Serve hot with buttered toast.',
    ],
  ),
  Recipe(
    id: 'seed-002',
    title: 'Lemon Garlic Pasta',
    category: 'Dinner',
    servings: 2,
    imageUrl:
        'https://coresg-normal.trae.ai/api/ide/v1/text_to_image?prompt=lemon%20garlic%20spaghetti%20twirled%20in%20a%20white%20bowl%20with%20parsley%20food%20photography&image_size=landscape_4_3',
    ingredients: <String>[
      '200 g spaghetti',
      '4 garlic cloves, sliced',
      '1 lemon, zest and juice',
      '3 tbsp olive oil',
      'Parmesan to taste',
    ],
    steps: <String>[
      'Boil the spaghetti until al dente.',
      'Gently fry the garlic in olive oil until golden.',
      'Toss the pasta with garlic oil, lemon zest and juice.',
      'Finish with parmesan and black pepper.',
    ],
  ),
  Recipe(
    id: 'seed-003',
    title: 'Chickpea Buddha Bowl',
    category: 'Lunch',
    servings: 2,
    imageUrl:
        'https://coresg-normal.trae.ai/api/ide/v1/text_to_image?prompt=healthy%20chickpea%20buddha%20bowl%20with%20quinoa%20avocado%20and%20greens%20overhead%20food%20photography&image_size=landscape_4_3',
    ingredients: <String>[
      '1 cup cooked quinoa',
      '1 cup roasted chickpeas',
      '1 avocado, sliced',
      '2 cups mixed greens',
      '2 tbsp tahini dressing',
    ],
    steps: <String>[
      'Roast the chickpeas with paprika for 20 minutes.',
      'Layer quinoa and greens in a bowl.',
      'Add chickpeas and avocado.',
      'Drizzle with tahini dressing.',
    ],
  ),
  Recipe(
    id: 'seed-004',
    title: 'Mango Chia Pudding',
    category: 'Dessert',
    servings: 2,
    imageUrl:
        'https://coresg-normal.trae.ai/api/ide/v1/text_to_image?prompt=mango%20chia%20seed%20pudding%20in%20a%20glass%20jar%20with%20mint%20food%20photography&image_size=landscape_4_3',
    ingredients: <String>[
      '3 tbsp chia seeds',
      '1 cup almond milk',
      '1 ripe mango, pureed',
      '1 tsp honey',
    ],
    steps: <String>[
      'Mix chia seeds with almond milk and honey.',
      'Refrigerate for at least 4 hours.',
      'Layer with mango puree before serving.',
    ],
  ),
  Recipe(
    id: 'seed-005',
    title: 'Tomato Basil Soup',
    category: 'Dinner',
    servings: 4,
    imageUrl:
        'https://coresg-normal.trae.ai/api/ide/v1/text_to_image?prompt=creamy%20tomato%20basil%20soup%20in%20a%20rustic%20bowl%20with%20bread%20food%20photography&image_size=landscape_4_3',
    ingredients: <String>[
      '6 ripe tomatoes',
      '1 onion',
      '3 garlic cloves',
      '1/2 cup basil leaves',
      '2 cups vegetable stock',
    ],
    steps: <String>[
      'Sweat the onion and garlic in olive oil.',
      'Add the chopped tomatoes and stock.',
      'Simmer for 25 minutes, then blend.',
      'Stir through fresh basil before serving.',
    ],
  ),
  Recipe(
    id: 'seed-006',
    title: 'Banana Oat Pancakes',
    category: 'Breakfast',
    servings: 3,
    imageUrl:
        'https://coresg-normal.trae.ai/api/ide/v1/text_to_image?prompt=stack%20of%20banana%20oat%20pancakes%20with%20berries%20and%20honey%20food%20photography&image_size=landscape_4_3',
    ingredients: <String>[
      '2 ripe bananas',
      '1 cup rolled oats',
      '2 eggs',
      '1 tsp baking powder',
      '1/2 cup berries to serve',
    ],
    steps: <String>[
      'Blend the bananas, oats, eggs and baking powder.',
      'Rest the batter for 10 minutes.',
      'Cook small pancakes on a non-stick pan.',
      'Top with berries and honey.',
    ],
  ),
  Recipe(
    id: 'seed-007',
    title: 'Grilled Chicken Salad',
    category: 'Lunch',
    dietType: DietType.nonVegetarian,
    servings: 2,
    imageUrl:
        'https://coresg-normal.trae.ai/api/ide/v1/text_to_image?prompt=grilled%20chicken%20salad%20bowl%20with%20cherry%20tomatoes%20and%20feta%20overhead%20food%20photography&image_size=landscape_4_3',
    ingredients: <String>[
      '2 chicken breasts',
      '4 cups salad leaves',
      '1 cup cherry tomatoes',
      '1 tbsp olive oil',
      '1/2 lemon, juiced',
    ],
    steps: <String>[
      'Season and grill the chicken for 6 minutes per side.',
      'Rest, then slice into strips.',
      'Toss the leaves and tomatoes with oil and lemon.',
      'Top with the warm chicken.',
    ],
  ),
];
