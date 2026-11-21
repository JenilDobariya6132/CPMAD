import 'package:flutter/material.dart';

/// App-wide preferences that are not recipe data — currently just the theme
/// mode. Shared through `provider` so the shell AppBar and the Settings screen
/// both read and update the same value.
class AppSettingsController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    if (mode == _themeMode) {
      return;
    }
    _themeMode = mode;
    notifyListeners();
  }

  /// Flips between light and dark; anything else resolves to dark first.
  void toggleDarkLight() {
    setThemeMode(
      _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
    );
  }
}
