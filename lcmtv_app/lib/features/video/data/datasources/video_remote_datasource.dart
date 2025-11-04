import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/models/video_metadata_model.dart';
import '../../../../core/models/category_model.dart';

abstract class VideoRemoteDataSource {
  Future<List<VideoMetadata>> searchVideos({
    required String query,
    String? categoryId,
    int maxResults = 25,
    String order = 'relevance',
  });

  Future<List<VideoMetadata>> getTrendingVideos({
    String? categoryId,
    int maxResults = 25,
  });

  Future<List<VideoMetadata>> getLiveStreams({
    String? categoryId,
    int maxResults = 25,
  });

  Future<VideoMetadata?> getVideoDetails(String videoId);
  Future<List<CategoryModel>> getCategories();
  Future<bool> likeVideo(String videoId);
  Future<bool> unlikeVideo(String videoId);
  Future<bool> isVideoLiked(String videoId);
  Future<List<VideoMetadata>> getLikedVideos();
  Future<bool> addToWatchHistory({
    required String videoId,
    required Duration watchTime,
    required double completionPercentage,
  });
  Future<List<VideoMetadata>> getWatchHistory();
}

class VideoRemoteDataSourceImpl implements VideoRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  VideoRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  @override
  Future<List<VideoMetadata>> searchVideos({
    required String query,
    String? categoryId,
    int maxResults = 25,
    String order = 'relevance',
  }) async {
    // This would typically call YouTube API or your backend service
    // For now, return empty list as this is handled by the repository
    return [];
  }

  @override
  Future<List<VideoMetadata>> getTrendingVideos({
    String? categoryId,
    int maxResults = 25,
  }) async {
    // This would typically call YouTube API or your backend service
    // For now, return empty list as this is handled by the repository
    return [];
  }

  @override
  Future<List<VideoMetadata>> getLiveStreams({
    String? categoryId,
    int maxResults = 25,
  }) async {
    // This would typically call YouTube API or your backend service
    // For now, return empty list as this is handled by the repository
    return [];
  }

  @override
  Future<VideoMetadata?> getVideoDetails(String videoId) async {
    // This would typically call YouTube API or your backend service
    // For now, return null as this is handled by the repository
    return null;
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    // This would typically call YouTube API or your backend service
    // For now, return empty list as this is handled by the repository
    return [];
  }

  @override
  Future<bool> likeVideo(String videoId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('likedVideos')
          .doc(videoId)
          .set({
        'videoId': videoId,
        'likedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('❌ Error liking video: $e');
      return false;
    }
  }

  @override
  Future<bool> unlikeVideo(String videoId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('likedVideos')
          .doc(videoId)
          .delete();

      return true;
    } catch (e) {
      print('❌ Error unliking video: $e');
      return false;
    }
  }

  @override
  Future<bool> isVideoLiked(String videoId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('likedVideos')
          .doc(videoId)
          .get();

      return doc.exists;
    } catch (e) {
      print('❌ Error checking if video is liked: $e');
      return false;
    }
  }

  @override
  Future<List<VideoMetadata>> getLikedVideos() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('likedVideos')
          .orderBy('likedAt', descending: true)
          .get();

      final List<VideoMetadata> likedVideos = [];
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        // Convert Firestore data to VideoMetadata
        // This is a simplified version - you'd need to fetch full video details
        likedVideos.add(VideoMetadata(
          id: data['videoId'],
          title: 'Loading...', // Would need to fetch from YouTube API
          description: '',
          channelId: '',
          channelTitle: '',
          thumbnailUrl: '',
          publishedAt: '',
          duration: Duration.zero,
          categoryId: '0',
          categoryTitle: 'Unknown',
        ));
      }

      return likedVideos;
    } catch (e) {
      print('❌ Error getting liked videos: $e');
      return [];
    }
  }

  @override
  Future<bool> addToWatchHistory({
    required String videoId,
    required Duration watchTime,
    required double completionPercentage,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('watchHistory')
          .add({
        'videoId': videoId,
        'watchTime': watchTime.inSeconds,
        'completionPercentage': completionPercentage,
        'watchedAt': FieldValue.serverTimestamp(),
        'deviceType': 'mobile',
      });

      return true;
    } catch (e) {
      print('❌ Error adding to watch history: $e');
      return false;
    }
  }

  @override
  Future<List<VideoMetadata>> getWatchHistory() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('watchHistory')
          .orderBy('watchedAt', descending: true)
          .limit(50)
          .get();

      final List<VideoMetadata> history = [];
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        // Convert Firestore data to VideoMetadata
        // This is a simplified version - you'd need to fetch full video details
        history.add(VideoMetadata(
          id: data['videoId'],
          title: 'Loading...', // Would need to fetch from YouTube API
          description: '',
          channelId: '',
          channelTitle: '',
          thumbnailUrl: '',
          publishedAt: '',
          duration: Duration.zero,
          categoryId: '0',
          categoryTitle: 'Unknown',
        ));
      }

      return history;
    } catch (e) {
      print('❌ Error getting watch history: $e');
      return [];
    }
  }
}
