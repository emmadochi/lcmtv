import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase/firebase_config.dart';
import '../models/user_model.dart';
import '../models/video_metadata_model.dart';
import '../models/program_model.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseConfig.firestore;

  // Collection references
  static CollectionReference get _usersCollection => _firestore.collection('users');
  static CollectionReference get _videosCollection => _firestore.collection('videos');
  static CollectionReference get _categoriesCollection => _firestore.collection('categories');
  static CollectionReference get _programsCollection => _firestore.collection('programs');
  static CollectionReference get _trendingCollection => _firestore.collection('trending');
  static CollectionReference get _liveStreamsCollection => _firestore.collection('liveStreams');
  static CollectionReference get _analyticsCollection => _firestore.collection('analytics');

  // User operations
  static Future<void> createUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).set(user.toFirestore());
      print('✅ User created successfully');
    } catch (e) {
      print('❌ User creation failed: $e');
      rethrow;
    }
  }

  static Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('❌ Get user failed: $e');
      rethrow;
    }
  }

  static Future<void> updateUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).update(user.toFirestore());
      print('✅ User updated successfully');
    } catch (e) {
      print('❌ User update failed: $e');
      rethrow;
    }
  }

  static Future<void> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
      print('✅ User deleted successfully');
    } catch (e) {
      print('❌ User deletion failed: $e');
      rethrow;
    }
  }

  static Stream<UserModel?> getUserStream(String userId) {
    return _usersCollection.doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    });
  }

  // Video operations
  static Future<void> createVideo(VideoMetadata video) async {
    try {
      await _videosCollection.doc(video.id).set(video.toFirestore());
      print('✅ Video created successfully');
    } catch (e) {
      print('❌ Video creation failed: $e');
      rethrow;
    }
  }

  static Future<VideoMetadata?> getVideo(String videoId) async {
    try {
      final doc = await _videosCollection.doc(videoId).get();
      if (doc.exists) {
        return VideoMetadata.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('❌ Get video failed: $e');
      rethrow;
    }
  }

  static Future<void> updateVideo(VideoMetadata video) async {
    try {
      await _videosCollection.doc(video.id).update(video.toFirestore());
      print('✅ Video updated successfully');
    } catch (e) {
      print('❌ Video update failed: $e');
      rethrow;
    }
  }

  static Future<void> deleteVideo(String videoId) async {
    try {
      await _videosCollection.doc(videoId).delete();
      print('✅ Video deleted successfully');
    } catch (e) {
      print('❌ Video deletion failed: $e');
      rethrow;
    }
  }

  static Stream<VideoMetadata?> getVideoStream(String videoId) {
    return _videosCollection.doc(videoId).snapshots().map((doc) {
      if (doc.exists) {
        return VideoMetadata.fromFirestore(doc);
      }
      return null;
    });
  }

  // Trending videos operations
  static Future<void> updateTrendingVideos(List<TrendingVideo> videos, String date) async {
    try {
      final batch = _firestore.batch();
      
      for (int i = 0; i < videos.length; i++) {
        final video = videos[i];
        final docRef = _trendingCollection
            .doc('daily')
            .collection(date)
            .doc(video.videoId);
        
        batch.set(docRef, video.toFirestore());
      }
      
      await batch.commit();
      print('✅ Trending videos updated successfully');
    } catch (e) {
      print('❌ Trending videos update failed: $e');
      rethrow;
    }
  }

  static Stream<List<TrendingVideo>> getTrendingVideosStream(String date) {
    return _trendingCollection
        .doc('daily')
        .collection(date)
        .orderBy('trendingRank')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TrendingVideo.fromFirestore(doc))
            .toList());
  }

  // Live streams operations
  static Future<void> updateLiveStreams(List<LiveStream> streams) async {
    try {
      await _liveStreamsCollection.doc('current').set({
        'streams': streams.map((s) => s.toFirestore()).toList(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      print('✅ Live streams updated successfully');
    } catch (e) {
      print('❌ Live streams update failed: $e');
      rethrow;
    }
  }

  static Stream<List<LiveStream>> getLiveStreamsStream() {
    return _liveStreamsCollection.doc('current').snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data != null && data['streams'] != null) {
        return (data['streams'] as List)
            .map((stream) => LiveStream.fromJson(stream))
            .toList();
      }
      return <LiveStream>[];
    });
  }

  // Watch history operations
  static Future<void> addWatchHistory(WatchHistory history) async {
    try {
      await _usersCollection
          .doc(history.userId)
          .collection('watchHistory')
          .add(history.toFirestore());
      print('✅ Watch history added successfully');
    } catch (e) {
      print('❌ Watch history addition failed: $e');
      rethrow;
    }
  }

  static Stream<List<WatchHistory>> getWatchHistoryStream(String userId) {
    return _usersCollection
        .doc(userId)
        .collection('watchHistory')
        .orderBy('watchedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WatchHistory.fromFirestore(doc))
            .toList());
  }

  // Liked videos operations
  static Future<void> addLikedVideo(LikedVideo likedVideo) async {
    try {
      await _usersCollection
          .doc(likedVideo.userId)
          .collection('likedVideos')
          .doc(likedVideo.videoId)
          .set(likedVideo.toFirestore());
      print('✅ Liked video added successfully');
    } catch (e) {
      print('❌ Liked video addition failed: $e');
      rethrow;
    }
  }

  static Future<void> removeLikedVideo(String userId, String videoId) async {
    try {
      await _usersCollection
          .doc(userId)
          .collection('likedVideos')
          .doc(videoId)
          .delete();
      print('✅ Liked video removed successfully');
    } catch (e) {
      print('❌ Liked video removal failed: $e');
      rethrow;
    }
  }

  static Stream<List<LikedVideo>> getLikedVideosStream(String userId) {
    return _usersCollection
        .doc(userId)
        .collection('likedVideos')
        .orderBy('likedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LikedVideo.fromFirestore(doc))
            .toList());
  }

  // Playlist operations
  static Future<void> createPlaylist(Playlist playlist) async {
    try {
      await _usersCollection
          .doc(playlist.userId)
          .collection('playlists')
          .doc(playlist.id)
          .set(playlist.toFirestore());
      print('✅ Playlist created successfully');
    } catch (e) {
      print('❌ Playlist creation failed: $e');
      rethrow;
    }
  }

  static Future<void> updatePlaylist(Playlist playlist) async {
    try {
      await _usersCollection
          .doc(playlist.userId)
          .collection('playlists')
          .doc(playlist.id)
          .update(playlist.toFirestore());
      print('✅ Playlist updated successfully');
    } catch (e) {
      print('❌ Playlist update failed: $e');
      rethrow;
    }
  }

  static Future<void> deletePlaylist(String userId, String playlistId) async {
    try {
      await _usersCollection
          .doc(userId)
          .collection('playlists')
          .doc(playlistId)
          .delete();
      print('✅ Playlist deleted successfully');
    } catch (e) {
      print('❌ Playlist deletion failed: $e');
      rethrow;
    }
  }

  static Stream<List<Playlist>> getPlaylistsStream(String userId) {
    return _usersCollection
        .doc(userId)
        .collection('playlists')
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Playlist.fromFirestore(doc))
            .toList());
  }

  // Analytics operations
  static Future<void> trackVideoView({
    required String videoId,
    required String userId,
    required Duration watchTime,
    required double completionPercentage,
  }) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      await _analyticsCollection
          .doc(today)
          .collection('videoViews')
          .add({
        'videoId': videoId,
        'userId': userId,
        'watchTime': watchTime.inSeconds,
        'completionPercentage': completionPercentage,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('✅ Video view tracked successfully');
    } catch (e) {
      print('❌ Video view tracking failed: $e');
      rethrow;
    }
  }

  static Future<void> trackUserEngagement({
    required String userId,
    required String action,
    required Map<String, dynamic> parameters,
  }) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      await _analyticsCollection
          .doc(today)
          .collection('userEngagement')
          .add({
        'userId': userId,
        'action': action,
        'parameters': parameters,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('✅ User engagement tracked successfully');
    } catch (e) {
      print('❌ User engagement tracking failed: $e');
      rethrow;
    }
  }
}
