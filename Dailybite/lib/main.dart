import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes.dart';
import 'screens/main_shell.dart';
import 'services/firebase_bootstrap.dart';
import 'state/app_settings_controller.dart';
import 'state/recipe_store.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseBootstrap.init();

  runApp(const DailyBiteApp());
}

/// App root: installs the shared [RecipeStore] (recipes + favourites) and the
/// [AppSettingsController] (theme mode), then wires the named routes declared
/// in [onGenerateRoute].
class DailyBiteApp extends StatelessWidget {
  const DailyBiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RecipeStore>(
          create: (_) => RecipeStore()..load(),
        ),
        ChangeNotifierProvider<AppSettingsController>(
          create: (_) => AppSettingsController(),
        ),
      ],
      child: Consumer<AppSettingsController>(
        builder: (BuildContext context, AppSettingsController settings, _) {
          return MaterialApp(
            title: 'DailyBite',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.themeMode,
            onGenerateRoute: onGenerateRoute,
            home: const MainShell(),
          );
        },
      ),
    );
  }
}
