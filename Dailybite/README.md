# DailyBite

A clean recipe discovery + personal meal planner app with local favourites,
simple search, and Firebase-backed community recipes.

## Milestone 1 — Project setup, Dart foundations & basic structure

### Folder structure

```
lib/
├── main.dart                     # DailyBiteApp (MultiProvider + onGenerateRoute)
├── app_routes.dart               # Route name constants
├── routes.dart                   # onGenerateRoute factory (passes Recipe arguments)
├── models/
│   ├── diet_type.dart            # DietType enum + DietFilter (All/Veg/Non-Veg)
│   └── recipe.dart               # Recipe model + heroTag for the Hero animation
├── screens/
│   ├── main_shell.dart           # BottomNavigationBar + Drawer host
│   ├── home_screen.dart          # Search + diet / category filters over RecipeStore
│   ├── favourites_screen.dart    # Favourites tab
│   ├── profile_screen.dart       # Profile tab
│   ├── recipe_detail_screen.dart # Named-route detail screen (Hero + adjuster)
│   ├── add_edit_recipe_screen.dart    # Form: validation, dropdowns, controllers
│   ├── about_screen.dart         # Static About screen
│   └── settings_screen.dart      # Theme mode + clear favourites
├── services/
│   ├── firebase_bootstrap.dart   # Safe Firebase.initializeApp() wrapper
│   ├── local_favourites_service.dart  # shared_preferences persistence
│   ├── personal_recipes_store.dart    # path_provider + dart:io JSON file
│   └── recipe_service.dart       # Firestore community feed (+ offline fallback)
├── state/
│   ├── recipe_store.dart         # ChangeNotifier: recipes + favourite ids
│   └── app_settings_controller.dart   # App-wide ThemeMode
├── utils/
│   ├── app_theme.dart            # AppTheme.light / AppTheme.dark
│   ├── quantity_scaler.dart      # Pure ingredient-scaling helpers
│   ├── recipe_filters.dart       # Pure filterByCategory / searchByTitle / filterByDiet
│   ├── recipe_form_flow.dart     # Shared Add/Edit navigation + persistence
│   └── seed_recipes.dart         # Bundled sample recipes (veg + non-veg)
└── widgets/
    ├── recipe_card.dart          # Hero-wrapped recipe tile
    ├── recipe_grid.dart          # Shared grid that opens the detail route
    └── serving_size_adjuster.dart # Slider + −/+ serving control
```

### Packages

| Package | Why |
| --- | --- |
| `http` | Available for future REST/image work |
| `shared_preferences` | Persists favourite recipe ids on the device |
| `path_provider` | Resolves the device documents directory for the personal-recipes JSON file |
| `cloud_firestore` + `firebase_core` | Community recipe feed |
| `provider` | App-wide state (`RecipeStore`, `AppSettingsController`) |
| `flutter_lints` (dev) | Recommended lint set |

State is handled with `setState` for transient UI state and `provider` for the
shared recipe / favourite store.

### Running

```bash
flutter pub get
flutter test        # 46 tests: pure Dart filters + scaler + JSON store + widget flows
flutter run
```

### Firebase is optional right now

`FirebaseBootstrap.init()` swallows the "not configured" error, so the app starts
even though `google-services.json` / `GoogleService-Info.plist` do not exist yet.
`RecipeService` then falls back to `kSeedRecipes`. To switch to the real
community feed:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

and create a Firestore collection named `recipes` whose documents match
`Recipe.toJson()`.

---

## Milestone 2 — Core widgets, forms & state management (CO3)

| Requirement | Where it lives |
| --- | --- |
| Reusable, **stateless** `RecipeCard` showing image, title, category + favourite icon | [recipe_card.dart](lib/widgets/recipe_card.dart) |
| **Add / Edit** form with `Form`, `TextFormField`, `DropdownButton`, validation & `TextEditingController` | [add_edit_recipe_screen.dart](lib/screens/add_edit_recipe_screen.dart) |
| Calculator-style **serving adjuster** (slider + −/+ buttons) updating quantities via `setState` | [serving_size_adjuster.dart](lib/widgets/serving_size_adjuster.dart), [recipe_detail_screen.dart](lib/screens/recipe_detail_screen.dart), [quantity_scaler.dart](lib/utils/quantity_scaler.dart) |
| **Stateful** home screen managing the recipe list with add / toggle-favourite | [home_screen.dart](lib/screens/home_screen.dart) |
| **Radio** diet filter (All / Vegetarian / Non-Veg) that updates the visible list immediately | `_DietFilterBar` in [home_screen.dart](lib/screens/home_screen.dart) + `filterByDiet` in [recipe_filters.dart](lib/utils/recipe_filters.dart) |

### How it works

- **`RecipeCard`** is a pure `StatelessWidget`: all state (favourited or not) is
  passed in, and tapping the heart calls the `onToggleFavourite` callback that
  the parent owns. It renders through `Image.network` with a loader / error
  placeholder and shows a small green/red dot next to the diet label.
- **`AddEditRecipeScreen`** uses a `GlobalKey<FormState>` and one
  `TextEditingController` per field. Title, servings and image URL are validated
  by validators; ingredients and steps are dynamic rows (add / remove). On save
  it returns a `Recipe` through `Navigator.pop`, and the home screen merges it
  (prepend when new, replace-by-id when editing).
- **Serving adjuster** — `scaleIngredients()` parses each ingredient's leading
  quantity (mixed numbers, fractions, decimals, integers) and multiplies it by
  `target / base` servings; lines with no leading number (e.g. *Salt to taste*)
  pass through untouched. `RecipeDetailScreen` owns the selected serving count,
  so moving the slider calls `setState` and the ingredient list re-renders.
- **Diet filter** — `_HomeScreenState` holds a `DietFilter` value; the
  `RadioGroup` under `_DietFilterBar` reports changes back through `onChanged`,
  which calls `setState` and immediately re-runs the pure `applyFilters` helper
  (diet → category → search), so the grid updates on the same frame.

---

## Milestone 3 — Navigation, Hero & local persistence (CO3, CO4, CO5)

| Requirement | Where it lives |
| --- | --- |
| **Named routes** with a full `Recipe` passed as the route argument to a Detail screen | [routes.dart](lib/routes.dart), [app_routes.dart](lib/app_routes.dart), [recipe_detail_screen.dart](lib/screens/recipe_detail_screen.dart) |
| **Hero** animation on the recipe image between list and detail | [recipe_card.dart](lib/widgets/recipe_card.dart) → `Hero(tag: recipe.heroTag)`, [recipe_detail_screen.dart](lib/screens/recipe_detail_screen.dart) |
| `BottomNavigationBar` (Home / Favourites / Profile) + `Drawer` with About & Settings | [main_shell.dart](lib/screens/main_shell.dart), [favourites_screen.dart](lib/screens/favourites_screen.dart), [profile_screen.dart](lib/screens/profile_screen.dart), [about_screen.dart](lib/screens/about_screen.dart), [settings_screen.dart](lib/screens/settings_screen.dart) |
| Favourite recipe ids persisted with `shared_preferences` and restored on start | [local_favourites_service.dart](lib/services/local_favourites_service.dart), [recipe_store.dart](lib/state/recipe_store.dart) |
| Personal recipes written to / read back from a JSON file (`path_provider` + `dart:io`) | [personal_recipes_store.dart](lib/services/personal_recipes_store.dart) |

### How it works

- **Named routes** — route names live in `AppRoutes`; `onGenerateRoute` in
  [routes.dart](lib/routes.dart) turns them into screens. The detail route reads
  the whole `Recipe` object straight out of `RouteSettings.arguments`:

  ```dart
  Navigator.of(context).pushNamed(AppRoutes.recipeDetail, arguments: recipe);
  ```

- **Hero** — `Recipe.heroTag` (`recipe-image-<id>`) is shared by the image in
  `RecipeCard` and the one at the top of `RecipeDetailScreen`, so the image morphs
  across the route transition. Only the active tab is built in `MainShell` (see
  below), which keeps every tag unique.
- **Shell** — `MainShell` owns the `AppBar`, the `BottomNavigationBar` and the
  navigation `Drawer` (Home / Favourites / Profile + About / Settings). The body
  switches on the selected index; the Add-Recipe FAB shows on the Home tab only.
- **State** — a single `RecipeStore` (`ChangeNotifier`, provided in
  [main.dart](lib/main.dart)) holds the community feed, the personal recipes and
  the favourite ids. `Home`, `Favourites` and the detail screen all `watch` it, so
  a favourite toggled anywhere is reflected everywhere. `AppSettingsController`
  holds the app-wide `ThemeMode` used by both the AppBar and the Settings screen.
- **Favourites** — `LocalFavouritesService` stores the ids under the
  `daily_bite.favourite_ids` key in `shared_preferences`; `RecipeStore.load()`
  reads them back on start and re-applies the favourite flag to the merged list.
- **Personal recipes JSON** — `PersonalRecipesStore` writes the `local-…` recipes
  to `daily_bite_personal_recipes.json` in the application documents directory
  (resolved with `path_provider`) using `dart:io`, and reads them back on start.
  The favourite flag is excluded from the file because it is device-local. The
  directory is injectable (`directoryProvider`) so the round-trip is unit-tested
  against a temp folder.

### Tests added in this milestone

`test/personal_recipes_store_test.dart` covers the JSON round-trip, the empty /
missing file case and malformed JSON. `test/widget_test.dart` additionally
verifies the named-route detail navigation + Hero, favourites restored from
`shared_preferences`, the bottom-navigation tabs and the drawer's About screen.
Because `path_provider` has no platform implementation under `flutter test`, the
widget tests mock its `plugins.flutter.io/path_provider` channel with a throw-away
temp directory.

---

## Hot Reload vs Hot Restart

Both are triggered from the terminal running `flutter run`:

| Key | Command | What it does |
| --- | --- | --- |
| `r` | Hot **Reload** | Rebuilds the widget tree after recompiling changed code. Preserves the current `State` objects, so scroll position, `TextEditingController` contents, open routes, and loaded network data all survive. |
| `R` | Hot **Restart** | Recompiles and tears the app down to the root, then rebuilds from `main()`. All `State` is lost — scroll position resets, text fields clear, and every `initState()` runs again. |

| | Hot Reload (`r`) | Hot Restart (`R`) |
| --- | --- | --- |
| Re-runs `main()` | No | Yes |
| Keeps widget `State` | Yes | No |
| Keeps variables / in-memory data | Yes | No |
| Applies changes to top-level `const`/`final` initialisers | No | Yes |
| Applies changes to `enum` values or generic signatures | No | Yes |
| Speed | Sub-second | A few seconds |

**Rule of thumb:** use `r` while iterating on UI, use `R` when you change static
initialisers, `main()`, global state, or when a reload leaves the app in a
strange intermediate state.

### Live demo for this project

1. Start the app: `flutter run`
2. Open [app_theme.dart](lib/utils/app_theme.dart) and change `_seed`
   from `Color(0xFFEF6C00)` to `Color(0xFF00897B)`.
3. Save → press `r`. The whole app re-colours **instantly** and your search text
   and scroll position are still there. That state preservation is the point of
   Hot Reload.
4. Now change the `MaterialApp` title in [main.dart](lib/main.dart) from
   `'DailyBite'` to `'DailyBite Recipes'`.
5. Save → press `R`. The title only takes effect after a full restart, because
   it is read once outside the widget rebuild path.

A quick way to *see* the difference: type something into the search field, press
`r`, and the text stays. Press `R`, and the field is empty.

---

## Notes

- `flutter analyze` currently reports `Undefined name 'override'` false positives
  for every file in this project. This is a toolchain quirk of the installed
  Dart 3.12.2 SDK — a freshly generated `flutter create` project shows the exact
  same errors, and `flutter test` compiles and passes cleanly.
