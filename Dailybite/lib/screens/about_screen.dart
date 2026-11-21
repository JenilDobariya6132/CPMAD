import 'package:flutter/material.dart';

/// Static informational screen reached from the drawer / profile.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Icon(
            Icons.restaurant_menu,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'DailyBite',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Version 1.0.0',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'A clean recipe discovery and personal meal planner with local '
            'favourites, simple search and a Firebase-backed community feed.',
          ),
          const SizedBox(height: 24),
          Text('Features', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            '• Search recipes by title\n'
            '• Filter by diet (veg / non-veg) and category\n'
            '• Save favourites on the device\n'
            '• Add your own recipes and scale the servings\n'
            '• Sync community recipes from Firestore',
          ),
        ],
      ),
    );
  }
}
