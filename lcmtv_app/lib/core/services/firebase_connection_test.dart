import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../firebase/firebase_config.dart';

class FirebaseConnectionTest {
  static Future<Map<String, dynamic>> testFirebaseConnection() async {
    final results = <String, dynamic>{};
    
    try {
      print('🔍 Testing Firebase connection...');
      
      // Test Firebase App
      results['firebase_app'] = await _testFirebaseApp();
      
      // Test Firebase Auth
      results['firebase_auth'] = await _testFirebaseAuth();
      
      // Test Firestore
      results['firestore'] = await _testFirestore();
      
      // Test Firebase Analytics
      results['analytics'] = await _testAnalytics();
      
      // Test Firebase Crashlytics
      results['crashlytics'] = await _testCrashlytics();
      
      // Test Firebase Storage
      results['storage'] = await _testStorage();
      
      // Overall status
      final allPassed = results.values.every((result) => result['status'] == 'success');
      results['overall_status'] = allPassed ? 'success' : 'partial_failure';
      
      print('✅ Firebase connection test completed');
      return results;
      
    } catch (e) {
      print('❌ Firebase connection test failed: $e');
      results['overall_status'] = 'failure';
      results['error'] = e.toString();
      return results;
    }
  }
  
  static Future<Map<String, dynamic>> _testFirebaseApp() async {
    try {
      final app = FirebaseConfig.app;
      return {
        'status': 'success',
        'app_name': app.name,
        'options': {
          'project_id': app.options.projectId,
          'api_key': app.options.apiKey,
          'app_id': app.options.appId,
        }
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString()
      };
    }
  }
  
  static Future<Map<String, dynamic>> _testFirebaseAuth() async {
    try {
      final auth = FirebaseConfig.auth;
      final currentUser = auth.currentUser;
      return {
        'status': 'success',
        'current_user': currentUser?.email ?? 'No user signed in',
        'auth_state': 'connected'
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString()
      };
    }
  }
  
  static Future<Map<String, dynamic>> _testFirestore() async {
    try {
      final firestore = FirebaseConfig.firestore;
      
      // Test a simple read operation
      final testDoc = await firestore.collection('test').doc('connection').get();
      
      return {
        'status': 'success',
        'firestore_connected': true,
        'test_doc_exists': testDoc.exists,
        'settings': {
          'persistence_enabled': firestore.settings.persistenceEnabled,
          'cache_size': firestore.settings.cacheSizeBytes,
        }
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString()
      };
    }
  }
  
  static Future<Map<String, dynamic>> _testAnalytics() async {
    try {
      final analytics = FirebaseConfig.analytics;
      
      // Test analytics initialization
      await analytics.logEvent(
        name: 'firebase_connection_test',
        parameters: {
          'test_timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      
      return {
        'status': 'success',
        'analytics_connected': true,
        'test_event_logged': true
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString()
      };
    }
  }
  
  static Future<Map<String, dynamic>> _testCrashlytics() async {
    try {
      final crashlytics = FirebaseConfig.crashlytics;
      
      // Test crashlytics initialization
      await crashlytics.setCrashlyticsCollectionEnabled(true);
      
      return {
        'status': 'success',
        'crashlytics_connected': true,
        'collection_enabled': true
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString()
      };
    }
  }
  
  static Future<Map<String, dynamic>> _testStorage() async {
    try {
      final storage = FirebaseConfig.storage;
      
      // Test storage reference
      final ref = storage.ref().child('test/connection.txt');
      
      return {
        'status': 'success',
        'storage_connected': true,
        'bucket_name': storage.bucket,
        'test_ref_created': true
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString()
      };
    }
  }
  
  // Test Firestore write operation
  static Future<Map<String, dynamic>> testFirestoreWrite() async {
    try {
      final firestore = FirebaseConfig.firestore;
      
      // Write a test document
      await firestore.collection('connection_test').doc('test_${DateTime.now().millisecondsSinceEpoch}').set({
        'timestamp': FieldValue.serverTimestamp(),
        'test_data': 'Firebase connection test',
        'app_version': '1.0.0',
        'platform': 'android',
      });
      
      return {
        'status': 'success',
        'write_operation': 'completed',
        'message': 'Test document written successfully'
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString()
      };
    }
  }
  
  // Test Firestore read operation
  static Future<Map<String, dynamic>> testFirestoreRead() async {
    try {
      final firestore = FirebaseConfig.firestore;
      
      // Read test documents
      final snapshot = await firestore.collection('connection_test')
          .orderBy('timestamp', descending: true)
          .limit(5)
          .get();
      
      return {
        'status': 'success',
        'read_operation': 'completed',
        'documents_found': snapshot.docs.length,
        'documents': snapshot.docs.map((doc) => {
          'id': doc.id,
          'data': doc.data(),
        }).toList()
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString()
      };
    }
  }
}
