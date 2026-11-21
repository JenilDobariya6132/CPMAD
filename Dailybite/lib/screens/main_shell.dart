import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../state/app_settings_controller.dart';
import '../state/recipe_store.dart';
import '../utils/recipe_form_flow.dart';
import 'favourites_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

/// Root shell: hosts the three tabs through a [BottomNavigationBar], the
/// navigation [Drawer] and the AppBar actions.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _selectTab(int index) {
    if (index == _index) {
      return;
    }
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    final RecipeStore store = context.watch<RecipeStore>();
    final AppSettingsController settings =
        context.watch<AppSettingsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('DailyBite'),
        actions: <Widget>[
          IconButton(
            tooltip: store.isCommunityLive
                ? 'Community feed connected'
                : 'Offline mode - showing bundled recipes',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    store.isCommunityLive
                        ? 'Connected to the Firestore community feed.'
                        : 'Offline mode - showing bundled recipes.',
                  ),
                ),
              );
            },
            icon: Icon(
              store.isCommunityLive
                  ? Icons.cloud_done_outlined
                  : Icons.cloud_off_outlined,
            ),
          ),
          IconButton(
            tooltip: settings.themeMode == ThemeMode.dark
                ? 'Switch to light theme'
                : 'Switch to dark theme',
            onPressed: settings.toggleDarkLight,
            icon: Icon(
              settings.themeMode == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
        ],
      ),
      drawer: _AppDrawer(selectedIndex: _index, onSelectTab: _selectTab),
      // Only the active tab is built, which also keeps `Hero` tags unique.
      body: switch (_index) {
        0 => const HomeScreen(),
        1 => const FavouritesScreen(),
        _ => const ProfileScreen(),
      },
      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
              onPressed: () => openRecipeForm(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Recipe'),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: _selectTab,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// Navigation drawer with the three tabs plus About and Settings.
class _AppDrawer extends StatelessWidget {
  const _AppDrawer({required this.selectedIndex, required this.onSelectTab});

  final int selectedIndex;
  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.restaurant_menu,
                    color: theme.colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Text('DailyBite', style: theme.textTheme.headlineSmall),
                ],
              ),
            ),
            const Divider(),
            _navTile(
              context,
              index: 0,
              icon: Icons.home_outlined,
              label: 'Home',
            ),
            _navTile(
              context,
              index: 1,
              icon: Icons.favorite_border,
              label: 'Favourites',
            ),
            _navTile(
              context,
              index: 2,
              icon: Icons.person_outline,
              label: 'Profile',
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () => _openRoute(context, AppRoutes.about),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () => _openRoute(context, AppRoutes.settings),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _navTile(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: selectedIndex == index,
      onTap: () {
        Navigator.of(context).pop();
        onSelectTab(index);
      },
    );
  }

  void _openRoute(BuildContext context, String routeName) {
    final NavigatorState navigator = Navigator.of(context);
    navigator.pop();
    navigator.pushNamed(routeName);
  }
}
