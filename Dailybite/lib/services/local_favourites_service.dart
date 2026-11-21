import 'package:shared_preferences/shared_preferences.dart';

/// Persists the set of favourite recipe ids on the device.
///
/// Favourites are intentionally local-only: `shared_preferences` gives us
/// instant, offline-capable reads, while the community recipes in Firestore
/// stay read-only.
class LocalFavouritesService {
  const LocalFavouritesService();

  static const String _storageKey = 'daily_bite.favourite_ids';

  Future<Set<String>> loadFavouriteIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_storageKey) ?? const <String>[]).toSet();
  }

  Future<void> saveFavouriteIds(Set<String> ids) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, ids.toList(growable: false));
  }
}
