import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudFunctionsService {
  static final FirebaseFunctions _functions = FirebaseFunctions.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // ============================================================================
  // VIDEO ANALYTICS
  // ============================================================================

  /// Tracks video view and updates analytics
  static Future<bool> trackVideoView({
    required String videoId,
    required int watchTime,
    required double completionPercentage,
    String deviceType = 'mobile',
  }) async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('User must be authenticated');
      }

      final callable = _functions.httpsCallable('trackVideoView');
      final result = await callable.call({
        'videoId': videoId,
        'watchTime': watchTime,
        'completionPercentage': completionPercentage,
        'deviceType': deviceType,
      });

      return result.data['success'] == true;
    } catch (e) {
      print('❌ Error tracking video view: $e');
      return false;
    }
  }

  /// Tracks user engagement events
  static Future<bool> trackUserEngagement({
    required String action,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('User must be authenticated');
      }

      final callable = _functions.httpsCallable('trackUserEngagement');
      final result = await callable.call({
        'action': action,
        'parameters': parameters ?? {},
      });

      return result.data['success'] == true;
    } catch (e) {
      print('❌ Error tracking user engagement: $e');
      return false;
    }
  }

  // ============================================================================
  // CONTENT MANAGEMENT
  // ============================================================================

  /// Adds video to user's liked videos
  static Future<bool> addLikedVideo({
    required String videoId,
    String? note,
  }) async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('User must be authenticated');
      }

      final callable = _functions.httpsCallable('addLikedVideo');
      final result = await callable.call({
        'videoId': videoId,
        'note': note,
      });

      return result.data['success'] == true;
    } catch (e) {
      print('❌ Error adding liked video: $e');
      return false;
    }
  }

  /// Removes video from user's liked videos
  static Future<bool> removeLikedVideo({
    required String videoId,
  }) async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('User must be authenticated');
      }

      final callable = _functions.httpsCallable('removeLikedVideo');
      final result = await callable.call({
        'videoId': videoId,
      });

      return result.data['success'] == true;
    } catch (e) {
      print('❌ Error removing liked video: $e');
      return false;
    }
  }

  // ============================================================================
  // PLAYLIST MANAGEMENT
  // ============================================================================

  /// Creates a new playlist
  static Future<String?> createPlaylist({
    required String name,
    String? description,
    bool isPublic = false,
    String? thumbnailUrl,
  }) async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('User must be authenticated');
      }

      final callable = _functions.httpsCallable('createPlaylist');
      final result = await callable.call({
        'name': name,
        'description': description,
        'isPublic': isPublic,
        'thumbnailUrl': thumbnailUrl,
      });

      if (result.data['success'] == true) {
        return result.data['playlistId'];
      }
      return null;
    } catch (e) {
      print('❌ Error creating playlist: $e');
      return null;
    }
  }

  /// Adds video to playlist
  static Future<bool> addVideoToPlaylist({
    required String playlistId,
    required String videoId,
  }) async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('User must be authenticated');
      }

      final callable = _functions.httpsCallable('addVideoToPlaylist');
      final result = await callable.call({
        'playlistId': playlistId,
        'videoId': videoId,
      });

      return result.data['success'] == true;
    } catch (e) {
      print('❌ Error adding video to playlist: $e');
      return false;
    }
  }

  /// Removes video from playlist
  static Future<bool> removeVideoFromPlaylist({
    required String playlistId,
    required String videoId,
  }) async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('User must be authenticated');
      }

      final callable = _functions.httpsCallable('removeVideoFromPlaylist');
      final result = await callable.call({
        'playlistId': playlistId,
        'videoId': videoId,
      });

      return result.data['success'] == true;
    } catch (e) {
      print('❌ Error removing video from playlist: $e');
      return false;
    }
  }

  /// Updates playlist details
  static Future<bool> updatePlaylist({
    required String playlistId,
    String? name,
    String? description,
    bool? isPublic,
    String? thumbnailUrl,
  }) async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('User must be authenticated');
      }

      final callable = _functions.httpsCallable('updatePlaylist');
      final result = await callable.call({
        'playlistId': playlistId,
        'name': name,
        'description': description,
        'isPublic': isPublic,
        'thumbnailUrl': thumbnailUrl,
      });

      return result.data['success'] == true;
    } catch (e) {
      print('❌ Error updating playlist: $e');
      return false;
    }
  }

  /// Deletes playlist
  static Future<bool> deletePlaylist({
    required String playlistId,
  }) async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('User must be authenticated');
      }

      final callable = _functions.httpsCallable('deletePlaylist');
      final result = await callable.call({
        'playlistId': playlistId,
      });

      return result.data['success'] == true;
    } catch (e) {
      print('❌ Error deleting playlist: $e');
      return false;
    }
  }

  // ============================================================================
  // TRENDING VIDEOS
  // ============================================================================

  /// Manually triggers trending videos aggregation
  static Future<bool> triggerTrendingVideosAggregation() async {
    try {
      final callable = _functions.httpsCallable('aggregateTrendingVideos');
      final result = await callable.call();

      return result.data['success'] == true;
    } catch (e) {
      print('❌ Error triggering trending videos aggregation: $e');
      return false;
    }
  }

  /// Manually triggers live streams detection
  static Future<bool> triggerLiveStreamsDetection() async {
    try {
      final callable = _functions.httpsCallable('detectLiveStreams');
      final result = await callable.call();

      return result.data['success'] == true;
    } catch (e) {
      print('❌ Error triggering live streams detection: $e');
      return false;
    }
  }

  // ============================================================================
  // HEALTH CHECK
  // ============================================================================

  /// Checks if Cloud Functions are healthy
  static Future<Map<String, dynamic>?> healthCheck() async {
    try {
      final callable = _functions.httpsCallable('healthCheck');
      final result = await callable.call();

      return result.data;
    } catch (e) {
      print('❌ Error checking health: $e');
      return null;
    }
  }

  // ============================================================================
  // USER ANALYTICS
  // ============================================================================

  /// Tracks user login
  static Future<bool> trackUserLogin() async {
    return await trackUserEngagement(
      action: 'user_login',
      parameters: {
        'timestamp': DateTime.now().toIso8601String(),
        'platform': 'mobile',
      },
    );
  }

  /// Tracks user logout
  static Future<bool> trackUserLogout() async {
    return await trackUserEngagement(
      action: 'user_logout',
      parameters: {
        'timestamp': DateTime.now().toIso8601String(),
        'platform': 'mobile',
      },
    );
  }

  /// Tracks video search
  static Future<bool> trackVideoSearch({
    required String query,
    String? categoryId,
    int resultCount = 0,
  }) async {
    return await trackUserEngagement(
      action: 'video_search',
      parameters: {
        'query': query,
        'categoryId': categoryId,
        'resultCount': resultCount,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Tracks video share
  static Future<bool> trackVideoShare({
    required String videoId,
    required String shareMethod,
  }) async {
    return await trackUserEngagement(
      action: 'video_share',
      parameters: {
        'videoId': videoId,
        'shareMethod': shareMethod,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Tracks playlist creation
  static Future<bool> trackPlaylistCreation({
    required String playlistId,
    required String playlistName,
  }) async {
    return await trackUserEngagement(
      action: 'playlist_created',
      parameters: {
        'playlistId': playlistId,
        'playlistName': playlistName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Tracks app usage session
  static Future<bool> trackAppSession({
    required Duration sessionDuration,
    required int videosWatched,
    required int searchesPerformed,
  }) async {
    return await trackUserEngagement(
      action: 'app_session',
      parameters: {
        'sessionDuration': sessionDuration.inSeconds,
        'videosWatched': videosWatched,
        'searchesPerformed': searchesPerformed,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // ============================================================================
  // ERROR HANDLING
  // ============================================================================

  /// Handles Cloud Functions errors
  static String _handleError(dynamic error) {
    if (error is FirebaseFunctionsException) {
      switch (error.code) {
        case 'unauthenticated':
          return 'User must be authenticated';
        case 'permission-denied':
          return 'Permission denied';
        case 'invalid-argument':
          return 'Invalid argument provided';
        case 'not-found':
          return 'Resource not found';
        case 'already-exists':
          return 'Resource already exists';
        case 'resource-exhausted':
          return 'Resource exhausted';
        case 'failed-precondition':
          return 'Precondition failed';
        case 'aborted':
          return 'Operation aborted';
        case 'out-of-range':
          return 'Value out of range';
        case 'unimplemented':
          return 'Operation not implemented';
        case 'internal':
          return 'Internal server error';
        case 'unavailable':
          return 'Service unavailable';
        case 'data-loss':
          return 'Data loss error';
        default:
          return 'Unknown error: ${error.message}';
      }
    }
    return 'Unknown error: $error';
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Sets Cloud Functions region
  static void setRegion(String region) {
    _functions.useFunctionsEmulator('localhost', 5001);
    // Note: In production, region is set in the function definition
  }

  /// Enables local emulator for testing
  static void useEmulator() {
    _functions.useFunctionsEmulator('localhost', 5001);
  }

  /// Disables local emulator
  static void useProduction() {
    // This is the default behavior
  }
}
