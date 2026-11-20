import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/recipe.dart';
import '../utils/seed_recipes.dart';
import 'firebase_bootstrap.dart';

/// Reads the community recipe collection from Firestore.
///
/// The service degrades gracefully: while Firebase is not configured (see
/// [FirebaseBootstrap]) or when the remote read fails, the bundled
/// [kSeedRecipes] are returned so the UI always has something to render.
class RecipeService {
  const RecipeService();

  static const String collectionName = 'recipes';

  /// True when a real Firestore connection is available.
  bool get isCommunityLive => FirebaseBootstrap.isReady;

  Future<List<Recipe>> fetchCommunityRecipes() async {
    if (!isCommunityLive) {
      return kSeedRecipes;
    }

    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection(collectionName)
              .limit(50)
              .get();

      if (snapshot.docs.isEmpty) {
        return kSeedRecipes;
      }

      return snapshot.docs
          .map(
            (QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                Recipe.fromJson(<String, dynamic>{
              ...doc.data(),
              // The document id is authoritative, even if the payload has one.
              'id': doc.id,
            }),
          )
          .toList(growable: false);
    } catch (error) {
      debugPrint('[RecipeService] Firestore read failed, using seeds: $error');
      return kSeedRecipes;
    }
  }
}
