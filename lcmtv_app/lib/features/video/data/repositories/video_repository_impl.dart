import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/youtube_service.dart';
import '../../../../core/models/video_metadata_model.dart';
import '../../../../core/models/category_model.dart';
import '../../../../core/models/youtube_video_model.dart';
import '../datasources/video_remote_datasource.dart';
import '../datasources/video_local_datasource.dart';
import '../../domain/repositories/video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoRemoteDataSource _remoteDataSource;
  final VideoLocalDataSource _localDataSource;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  
  VideoRepositoryImpl({
    required VideoRemoteDataSource remoteDataSource,
    required VideoLocalDataSource localDataSource,
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _firestore = firestore,
       _auth = auth;

  // ============================================================================
  // VIDEO SEARCH & DISCOVERY
  // ============================================================================
  
  @override
  Future<List<YouTubeVideoModel>> searchVideos({
    required String query,
    String? categoryId,
    String? order = 'relevance',
    String? publishedAfter,
    String? publishedBefore,
    int maxResults = 25,
  }) async {
      try {
      // Search YouTube API
      final youtubeResults = await YouTubeService.searchVideos(
        query: query,
          categoryId: categoryId,
          maxResults: maxResults,
        order: order ?? 'relevance',
      );

      // Convert to YouTubeVideoModel objects
      final videos = youtubeResults.map((data) => YouTubeVideoModel(
        id: data['id'] ?? '',
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        channelId: data['channelId'] ?? '',
        channelTitle: data['channelTitle'] ?? '',
        thumbnailUrl: data['thumbnailUrl'] ?? '',
        publishedAt: data['publishedAt'] ?? '',
        duration: _parseDuration(data['duration'] ?? 'PT0S'),
        viewCount: int.tryParse(data['viewCount']?.toString() ?? '0') ?? 0,
        likeCount: int.tryParse(data['likeCount']?.toString() ?? '0') ?? 0,
        commentCount: int.tryParse(data['commentCount']?.toString() ?? '0') ?? 0,
        categoryId: data['categoryId']?.toString() ?? '0',
        isLive: false,
        tags: (data['tags'] as List<dynamic>?)?.map((tag) => tag.toString()).toList() ?? [],
      )).toList();

      // Cache results locally - convert to VideoMetadata
      final videoMetadataList = await _convertToVideoMetadataList(videos);
      await _localDataSource.cacheSearchResults(query, videoMetadataList);

        return videos;
      } catch (e) {
      print('❌ Error searching videos: $e');
      // Return cached results if available
      final cachedResults = await _localDataSource.getCachedSearchResults(query);
      return cachedResults.map((video) => YouTubeVideoModel(
        id: video.id,
        title: video.title,
        description: video.description,
        channelId: video.channelId,
        channelTitle: video.channelTitle,
        thumbnailUrl: video.thumbnailUrl,
        publishedAt: video.publishedAt,
        duration: video.duration,
        viewCount: 0,
        likeCount: 0,
        commentCount: 0,
        categoryId: video.categoryId,
        isLive: video.isLive,
        tags: video.tags,
      )).toList();
    }
  }
  
  @override
  Future<List<YouTubeVideoModel>> getTrendingVideos({
    String? categoryId,
    int maxResults = 25,
  }) async {
      try {
      // Get from YouTube API
      final youtubeResults = await YouTubeService.getTrendingVideos(
          categoryId: categoryId,
          maxResults: maxResults,
        );

      // Convert to YouTubeVideoModel objects
      final videos = youtubeResults.map((data) => YouTubeVideoModel(
        id: data['id'] ?? '',
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        channelId: data['channelId'] ?? '',
        channelTitle: data['channelTitle'] ?? '',
        thumbnailUrl: data['thumbnailUrl'] ?? '',
        publishedAt: data['publishedAt'] ?? '',
        duration: _parseDuration(data['duration'] ?? 'PT0S'),
        viewCount: int.tryParse(data['viewCount']?.toString() ?? '0') ?? 0,
        likeCount: int.tryParse(data['likeCount']?.toString() ?? '0') ?? 0,
        commentCount: int.tryParse(data['commentCount']?.toString() ?? '0') ?? 0,
        categoryId: data['categoryId']?.toString() ?? '0',
        isLive: false,
        tags: (data['tags'] as List<dynamic>?)?.map((tag) => tag.toString()).toList() ?? [],
      )).toList();

      // Cache trending videos - convert to VideoMetadata
      final videoMetadataList = await _convertToVideoMetadataList(videos);
      await _localDataSource.cacheTrendingVideos(videoMetadataList);

      return videos;
      } catch (e) {
      print('❌ Error getting trending videos: $e');
      // Return cached results if available
      final cachedResults = await _localDataSource.getCachedTrendingVideos();
      return cachedResults.map((video) => YouTubeVideoModel(
        id: video.id,
        title: video.title,
        description: video.description,
        channelId: video.channelId,
        channelTitle: video.channelTitle,
        thumbnailUrl: video.thumbnailUrl,
        publishedAt: video.publishedAt,
        duration: video.duration,
        viewCount: 0,
        likeCount: 0,
        commentCount: 0,
        categoryId: video.categoryId,
        isLive: video.isLive,
        tags: video.tags,
      )).toList();
    }
  }
  
  @override
  Future<List<YouTubeVideoModel>> getLiveStreams({
    String? categoryId,
    int maxResults = 25,
  }) async {
      try {
      // Get live streams from YouTube API
      final youtubeResults = await YouTubeService.getLiveStreams(
          categoryId: categoryId,
          maxResults: maxResults,
        );

      // Convert to YouTubeVideoModel objects
      final videos = youtubeResults.map((data) => YouTubeVideoModel(
        id: data['id'] ?? '',
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        channelId: data['channelId'] ?? '',
        channelTitle: data['channelTitle'] ?? '',
        thumbnailUrl: data['thumbnailUrl'] ?? '',
        publishedAt: data['publishedAt'] ?? '',
        duration: const Duration(seconds: 0), // Live streams have no duration
        viewCount: int.tryParse(data['viewCount']?.toString() ?? '0') ?? 0,
        likeCount: int.tryParse(data['likeCount']?.toString() ?? '0') ?? 0,
        commentCount: int.tryParse(data['commentCount']?.toString() ?? '0') ?? 0,
        categoryId: data['categoryId']?.toString() ?? '0',
        isLive: true,
        liveViewerCount: int.tryParse(data['liveViewerCount']?.toString() ?? '0'),
        tags: (data['tags'] as List<dynamic>?)?.map((tag) => tag.toString()).toList() ?? [],
      )).toList();

        return videos;
      } catch (e) {
      print('❌ Error getting live streams: $e');
      return [];
    }
  }

  // ============================================================================
  // VIDEO DETAILS
  // ============================================================================
  
  @override
  Future<YouTubeVideoModel> getVideoDetails(String videoId) async {
    try {
      // Try to get from cache first
      final cachedVideo = await _localDataSource.getCachedVideo(videoId);
      if (cachedVideo != null) {
        return YouTubeVideoModel(
          id: cachedVideo.id,
          title: cachedVideo.title,
          description: cachedVideo.description,
          channelId: cachedVideo.channelId,
          channelTitle: cachedVideo.channelTitle,
          thumbnailUrl: cachedVideo.thumbnailUrl,
          publishedAt: cachedVideo.publishedAt,
          duration: cachedVideo.duration,
          viewCount: 0,
          likeCount: 0,
          commentCount: 0,
          categoryId: cachedVideo.categoryId,
          isLive: cachedVideo.isLive,
          tags: cachedVideo.tags,
        );
      }

      // Get from YouTube API
      final youtubeData = await YouTubeService.getVideoDetails(videoId);
      if (youtubeData == null) {
        throw Exception('Video not found');
      }

      // Convert to YouTubeVideoModel
      final video = YouTubeVideoModel(
        id: youtubeData['id'] ?? '',
        title: youtubeData['title'] ?? '',
        description: youtubeData['description'] ?? '',
        channelId: youtubeData['channelId'] ?? '',
        channelTitle: youtubeData['channelTitle'] ?? '',
        thumbnailUrl: youtubeData['thumbnailUrl'] ?? '',
        publishedAt: youtubeData['publishedAt'] ?? '',
        duration: _parseDuration(youtubeData['duration'] ?? 'PT0S'),
        viewCount: int.tryParse(youtubeData['viewCount']?.toString() ?? '0') ?? 0,
        likeCount: int.tryParse(youtubeData['likeCount']?.toString() ?? '0') ?? 0,
        commentCount: int.tryParse(youtubeData['commentCount']?.toString() ?? '0') ?? 0,
        categoryId: youtubeData['categoryId']?.toString() ?? '0',
        isLive: false,
        tags: (youtubeData['tags'] as List<dynamic>?)?.map((tag) => tag.toString()).toList() ?? [],
      );

      // Cache the video - convert to VideoMetadata
      final videoMetadata = await _convertToVideoMetadata(video);
      await _localDataSource.cacheVideo(videoMetadata);

      return video;
      } catch (e) {
      print('❌ Error getting video details: $e');
      throw Exception('Failed to get video details: $e');
    }
  }

  // ============================================================================
  // CATEGORIES
  // ============================================================================
  
  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      // Try to get from cache first
      final cachedCategories = await _localDataSource.getCachedCategories();
      if (cachedCategories.isNotEmpty) {
        return cachedCategories;
      }

      // Get from YouTube API
      final youtubeCategories = await YouTubeService.getVideoCategories();
      
      final categories = youtubeCategories.map((data) => CategoryModel(
        id: data['id'],
        title: data['title'],
        assignable: data['assignable'] ?? true,
      )).toList();

      // Cache categories
      await _localDataSource.cacheCategories(categories);

        return categories;
      } catch (e) {
      print('❌ Error getting categories: $e');
      return [];
    }
  }


  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  Duration _parseDuration(String iso8601Duration) {
    // Parse ISO 8601 duration (e.g., "PT1H2M3S")
    final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
    final match = regex.firstMatch(iso8601Duration);
    
    if (match == null) return Duration.zero;
    
    final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
    final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
    final seconds = int.tryParse(match.group(3) ?? '0') ?? 0;
    
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  Future<String> _getCategoryTitle(String? categoryId) async {
    if (categoryId == null) return 'Unknown';
    
    try {
      final categories = await getCategories();
      final category = categories.firstWhere(
        (cat) => cat.id == categoryId,
        orElse: () => CategoryModel(id: categoryId, title: 'Unknown', assignable: 'true'),
      );
      return category.title;
    } catch (e) {
      return 'Unknown';
    }
  }

  // ============================================================================
  // MISSING IMPLEMENTATIONS
  // ============================================================================

  @override
  Future<List<YouTubeVideoModel>> getVideosByCategory({
    required String categoryId,
    int maxResults = 25,
  }) async {
    // Implementation for getting videos by category
    return [];
  }

  @override
  Future<List<YouTubeVideoModel>> getRelatedVideos({
    required String videoId,
    int maxResults = 25,
  }) async {
    // Implementation for getting related videos
    return [];
  }

  @override
  Future<List<YouTubeVideoModel>> getChannelVideos({
    required String channelId,
    int maxResults = 25,
  }) async {
    // Implementation for getting channel videos
    return [];
  }

  @override
  Future<List<YouTubeVideoModel>> getPopularVideos({
    String? regionCode,
    int maxResults = 25,
  }) async {
    // Implementation for getting popular videos
    return [];
  }

  @override
  Future<void> clearCache() async {
    // Implementation for clearing cache
  }

  @override
  Future<List<YouTubeVideoModel>?> getCachedTrendingVideos() async {
    // Implementation for getting cached trending videos
    return null;
  }

  @override
  Future<List<YouTubeVideoModel>?> getCachedLiveStreams() async {
    // Implementation for getting cached live streams
    return null;
  }

  @override
  Future<List<CategoryModel>?> getCachedCategories() async {
    // Implementation for getting cached categories
    return null;
  }

  // ============================================================================
  // HELPER METHODS FOR CONVERSION
  // ============================================================================

  Future<List<VideoMetadata>> _convertToVideoMetadataList(List<YouTubeVideoModel> videos) async {
    final List<VideoMetadata> videoMetadataList = [];
    for (final video in videos) {
      final categoryTitle = await _getCategoryTitle(video.categoryId);
      videoMetadataList.add(VideoMetadata(
        id: video.id,
        title: video.title,
        description: video.description,
        channelId: video.channelId,
        channelTitle: video.channelTitle,
        thumbnailUrl: video.thumbnailUrl,
        publishedAt: video.publishedAt,
        duration: video.duration,
        categoryId: video.categoryId,
        categoryTitle: categoryTitle,
        tags: video.tags,
        isLive: video.isLive,
        viewCount: video.viewCount,
      ));
    }
    return videoMetadataList;
  }

  Future<VideoMetadata> _convertToVideoMetadata(YouTubeVideoModel video) async {
    final categoryTitle = await _getCategoryTitle(video.categoryId);
    return VideoMetadata(
      id: video.id,
      title: video.title,
      description: video.description,
      channelId: video.channelId,
      channelTitle: video.channelTitle,
      thumbnailUrl: video.thumbnailUrl,
      publishedAt: video.publishedAt,
      duration: video.duration,
      categoryId: video.categoryId,
      categoryTitle: categoryTitle,
      tags: video.tags,
      isLive: video.isLive,
      viewCount: video.viewCount,
    );
  }
}