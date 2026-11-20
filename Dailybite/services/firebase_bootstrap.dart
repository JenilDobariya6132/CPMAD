import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Wraps [Firebase.initializeApp] so the rest of the app can run even when the
/// platform config files (`google-services.json`, `GoogleService-Info.plist`)
/// have not been added to the project yet.
///
/// Until the FlutterFire project is generated with
/// `flutterfire configure`, [isReady] stays `false` and the community feed
/// silently falls back to bundled sample data instead of crashing on start-up.
class FirebaseBootstrap {
  const FirebaseBootstrap._();

  static bool _isReady = false;

  static bool get isReady => _isReady;

  static Future<void> init() async {
    try {
      await Firebase.initializeApp();
      _isReady = true;
      debugPrint('[FirebaseBootstrap] Firebase initialised successfully.');
    } catch (error) {
      _isReady = false;
      debugPrint(
        '[FirebaseBootstrap] Firebase is not configured yet, running in '
        'offline mode. Reason: $error',
      );
    }
  }
}
