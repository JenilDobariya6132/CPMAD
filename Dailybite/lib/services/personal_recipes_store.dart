import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/recipe.dart';

/// Reads / writes the recipes the user created in the app to a JSON file in the
/// device documents directory (`path_provider` + `dart:io`).
///
/// The directory provider is injectable so the store can be exercised in tests
/// against a temporary folder instead of a real device file system. When no
/// directory can be resolved (e.g. on platforms without a documents directory)
/// the store degrades to a no-op instead of throwing.
class PersonalRecipesStore {
  PersonalRecipesStore({Future<Directory> Function()? directoryProvider})
      : _directoryProvider =
            directoryProvider ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _directoryProvider;

  static const String fileName = 'daily_bite_personal_recipes.json';

  Future<File?> _resolveFile() async {
    try {
      final Directory directory = await _directoryProvider();
      return File('${directory.path}${Platform.pathSeparator}$fileName');
    } catch (_) {
      return null;
    }
  }

  /// Reads the personal recipes back. Returns an empty list when the file does
  /// not exist yet, is empty, or holds malformed JSON.
  ///
  /// The reads / writes are synchronous `dart:io` calls: the payload is a small
  /// JSON file, and staying synchronous keeps the store deterministic inside
  /// `flutter test` where real async file I/O never completes in the fake clock.
  Future<List<Recipe>> load() async {
    final File? file = await _resolveFile();
    if (file == null || !file.existsSync()) {
      return const <Recipe>[];
    }

    try {
      final String raw = file.readAsStringSync();
      if (raw.trim().isEmpty) {
        return const <Recipe>[];
      }
      final Object? decoded = jsonDecode(raw);
      if (decoded is! List) {
        return const <Recipe>[];
      }
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(Recipe.fromJson)
          .toList(growable: false);
    } on FormatException {
      return const <Recipe>[];
    } on FileSystemException {
      return const <Recipe>[];
    }
  }

  /// Overwrites the JSON file with [recipes].
  Future<void> save(List<Recipe> recipes) async {
    final File? file = await _resolveFile();
    if (file == null) {
      return;
    }

    try {
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(
        jsonEncode(
          recipes
              .map((Recipe recipe) => recipe.toJson(includeFavourite: false))
              .toList(growable: false),
        ),
      );
    } on FileSystemException {
      // Persisting is best-effort; the in-memory list stays authoritative.
    }
  }
}
