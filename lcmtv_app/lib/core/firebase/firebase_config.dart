import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../config/app_config.dart';

class FirebaseConfig {
  static FirebaseApp? _app;
  static FirebaseAuth? _auth;
  static FirebaseFirestore? _firestore;
  static FirebaseAnalytics? _analytics;
  static FirebaseCrashlytics? _crashlytics;
  static FirebaseStorage? _storage;

  static FirebaseApp get app {
    if (_app == null) {
      throw Exception('Firebase not initialized. Call initialize() first.');
    }
    return _app!;
  }

  static FirebaseAuth get auth {
    if (_auth == null) {
      _auth = FirebaseAuth.instance;
    }
    return _auth!;
  }

  static FirebaseFirestore get firestore {
    if (_firestore == null) {
      _firestore = FirebaseFirestore.instance;
    }
    return _firestore!;
  }

  static FirebaseAnalytics get analytics {
    if (_analytics == null) {
      _analytics = FirebaseAnalytics.instance;
    }
    return _analytics!;
  }

  static FirebaseCrashlytics get crashlytics {
    if (_crashlytics == null) {
      _crashlytics = FirebaseCrashlytics.instance;
    }
    return _crashlytics!;
  }

  static FirebaseStorage get storage {
    if (_storage == null) {
      _storage = FirebaseStorage.instance;
    }
    return _storage!;
  }

  static Future<void> initialize() async {
    try {
      _app = await Firebase.initializeApp(
        name: 'LCTV',
        options: const FirebaseOptions(
          apiKey: 'AIzaSyD40EuLRhosdphGnUfQOaQWmMRUkOk-V-E',
          appId: '1:679833147395:android:fe55390bb1e61019a35636',
          messagingSenderId: 'YOUR_SENDER_ID',
          projectId: 'LCTV',
          storageBucket: 'LCTV.appspot.com',
        ),
      );

      // Initialize services
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;
      _storage = FirebaseStorage.instance;

      // Configure services
      await _configureFirestore();
      await _configureCrashlytics();
      await _configureAnalytics();

      print('✅ Firebase initialized successfully');
    } catch (e) {
      print('❌ Firebase initialization failed: $e');
      rethrow;
    }
  }

  static Future<void> _configureFirestore() async {
    if (_firestore != null) {
      // Configure Firestore settings
      _firestore!.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      // Enable offline persistence
      await _firestore!.enablePersistence();
    }
  }

  static Future<void> _configureCrashlytics() async {
    if (_crashlytics != null && AppConfig.enableCrashReporting) {
      // Enable crashlytics collection
      await _crashlytics!.setCrashlyticsCollectionEnabled(true);
      
      // Set user identifier
      final user = _auth?.currentUser;
      if (user != null) {
        await _crashlytics!.setUserIdentifier(user.uid);
      }
    }
  }

  static Future<void> _configureAnalytics() async {
    if (_analytics != null && AppConfig.enableAnalytics) {
      // Set analytics collection enabled
      await _analytics!.setAnalyticsCollectionEnabled(true);
      
      // Set user properties
      final user = _auth?.currentUser;
      if (user != null) {
        await _analytics!.setUserId(id: user.uid);
        await _analytics!.setUserProperty(
          name: 'email',
          value: user.email,
        );
      }
    }
  }

  static Future<void> signOut() async {
    try {
      await auth.signOut();
      await analytics.resetAnalyticsData();
      print('✅ User signed out successfully');
    } catch (e) {
      print('❌ Sign out failed: $e');
      rethrow;
    }
  }

  static Future<void> deleteUser() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await user.delete();
        await analytics.resetAnalyticsData();
        print('✅ User account deleted successfully');
      }
    } catch (e) {
      print('❌ User deletion failed: $e');
      rethrow;
    }
  }

  static Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoURL);
        print('✅ User profile updated successfully');
      }
    } catch (e) {
      print('❌ Profile update failed: $e');
      rethrow;
    }
  }

  static Future<void> sendEmailVerification() async {
    try {
      final user = auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print('✅ Email verification sent');
      }
    } catch (e) {
      print('❌ Email verification failed: $e');
      rethrow;
    }
  }

  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      print('✅ Password reset email sent');
    } catch (e) {
      print('❌ Password reset failed: $e');
      rethrow;
    }
  }

  static Future<void> reauthenticateUser(String password) async {
    try {
      final user = auth.currentUser;
      if (user != null && user.email != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
        print('✅ User reauthenticated successfully');
      }
    } catch (e) {
      print('❌ Reauthentication failed: $e');
      rethrow;
    }
  }
}
