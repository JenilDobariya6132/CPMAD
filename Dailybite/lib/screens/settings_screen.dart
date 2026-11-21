import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_settings_controller.dart';
import '../state/recipe_store.dart';

/// Settings screen reached from the drawer / profile.
///
/// Theme mode is stored in [AppSettingsController]; the favourites section can
/// wipe the persisted favourite ids.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppSettingsController settings =
        context.watch<AppSettingsController>();
    final RecipeStore store = context.watch<RecipeStore>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: <Widget>[
          const _SectionLabel('Appearance'),
          RadioGroup<ThemeMode>(
            groupValue: settings.themeMode,
            onChanged: (ThemeMode? mode) {
              if (mode != null) {
                settings.setThemeMode(mode);
              }
            },
            child: Column(
              children: ThemeMode.values
                  .map(
                    (ThemeMode mode) => RadioListTile<ThemeMode>(
                      value: mode,
                      title: Text(_themeLabel(mode)),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
          const Divider(),
          const _SectionLabel('Favourites'),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Clear all favourites'),
            subtitle: Text('${store.favouriteIds.length} saved'),
            enabled: store.favouriteIds.isNotEmpty,
            onTap: store.favouriteIds.isEmpty
                ? null
                : () async {
                    final RecipeStore recipeStore =
                        context.read<RecipeStore>();
                    final ScaffoldMessengerState messenger =
                        ScaffoldMessenger.of(context);
                    await recipeStore.clearFavourites();
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Favourites cleared.')),
                    );
                  },
          ),
        ],
      ),
    );
  }

  static String _themeLabel(ThemeMode mode) => switch (mode) {
        ThemeMode.system => 'System default',
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
      };
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.primary,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
