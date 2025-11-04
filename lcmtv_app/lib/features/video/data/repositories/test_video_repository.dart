import '../../../../core/models/youtube_video_model.dart';
import '../../../../core/models/category_model.dart';
import '../../../../core/services/test_data_service.dart';
import '../../domain/repositories/video_repository.dart';

class TestVideoRepository implements VideoRepository {
  final TestDataService _testDataService = TestDataService();

  @override
  Future<List<YouTubeVideoModel>> getTrendingVideos({
    String? categoryId,
    int maxResults = 25,
  }) async {
    print('🔵 TestVideoRepository.getTrendingVideos called');
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final videos = _testDataService.trendingVideos.take(maxResults).map((video) => 
      YouTubeVideoModel(
        id: video.id,
        title: video.title,
        description: video.description,
        channelId: video.channelId,
        channelTitle: video.channelTitle,
        thumbnailUrl: video.thumbnailUrl,
        publishedAt: video.publishedAt,
        duration: video.duration,
        viewCount: video.viewCount,
        likeCount: (video.viewCount * 0.05).round(), // Simulate likes
        commentCount: (video.viewCount * 0.01).round(), // Simulate comments
        categoryId: video.categoryId,
        isLive: video.isLive,
        tags: video.tags,
      )
    ).toList();
    
    print('🔵 Returning ${videos.length} trending videos');
    return videos;
  }

  @override
  Future<List<YouTubeVideoModel>> getLiveStreams({
    String? categoryId,
    int maxResults = 25,
  }) async {
    print('🔵 TestVideoRepository.getLiveStreams called');
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final streams = _testDataService.liveStreams.take(maxResults).map((stream) => 
      YouTubeVideoModel(
        id: stream.id,
        title: stream.title,
        description: stream.description,
        channelId: stream.channelId,
        channelTitle: stream.channelTitle,
        thumbnailUrl: stream.thumbnailUrl,
        publishedAt: stream.publishedAt,
        duration: stream.duration,
        viewCount: stream.viewCount,
        likeCount: (stream.viewCount * 0.05).round(),
        commentCount: (stream.viewCount * 0.01).round(),
        categoryId: stream.categoryId,
        isLive: stream.isLive,
        tags: stream.tags,
      )
    ).toList();
    
    print('🔵 Returning ${streams.length} live streams');
    return streams;
  }

  @override
  Future<List<YouTubeVideoModel>> searchVideos({
    required String query,
    String? categoryId,
    String? order = 'relevance',
    String? publishedAfter,
    String? publishedBefore,
    int maxResults = 25,
  }) async {
    print('🔵 TestVideoRepository.searchVideos called with query: $query');
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    final searchResults = _testDataService.searchVideos(query).take(maxResults).map((video) => 
      YouTubeVideoModel(
        id: video.id,
        title: video.title,
        description: video.description,
        channelId: video.channelId,
        channelTitle: video.channelTitle,
        thumbnailUrl: video.thumbnailUrl,
        publishedAt: video.publishedAt,
        duration: video.duration,
        viewCount: video.viewCount,
        likeCount: (video.viewCount * 0.05).round(),
        commentCount: (video.viewCount * 0.01).round(),
        categoryId: video.categoryId,
        isLive: video.isLive,
        tags: video.tags,
      )
    ).toList();
    
    print('🔵 Returning ${searchResults.length} search results');
    return searchResults;
  }

  @override
  Future<YouTubeVideoModel> getVideoDetails(String videoId) async {
    print('🔵 TestVideoRepository.getVideoDetails called for: $videoId');
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Find video in test data
    final allVideos = [
      ..._testDataService.trendingVideos,
      ..._testDataService.liveStreams,
      ..._testDataService.featuredVideos,
    ];
    
    final video = allVideos.firstWhere(
      (v) => v.id == videoId,
      orElse: () => allVideos.first,
    );
    
    final result = YouTubeVideoModel(
      id: video.id,
      title: video.title,
      description: video.description,
      channelId: video.channelId,
      channelTitle: video.channelTitle,
      thumbnailUrl: video.thumbnailUrl,
      publishedAt: video.publishedAt,
      duration: video.duration,
      viewCount: video.viewCount,
      likeCount: (video.viewCount * 0.05).round(),
      commentCount: (video.viewCount * 0.01).round(),
      categoryId: video.categoryId,
      isLive: video.isLive,
      tags: video.tags,
    );
    
    print('🔵 Returning video details for: ${result.title}');
    return result;
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    print('🔵 TestVideoRepository.getCategories called');
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    final categories = [
      CategoryModel(
        id: '1',
        title: 'Technology',
        assignable: 'true',
      ),
      CategoryModel(
        id: '2',
        title: 'Gaming',
        assignable: 'true',
      ),
      CategoryModel(
        id: '3',
        title: 'Music',
        assignable: 'true',
      ),
      CategoryModel(
        id: '4',
        title: 'Entertainment',
        assignable: 'true',
      ),
      CategoryModel(
        id: '5',
        title: 'Education',
        assignable: 'true',
      ),
      CategoryModel(
        id: '6',
        title: 'Fitness',
        assignable: 'true',
      ),
      CategoryModel(
        id: '7',
        title: 'Food',
        assignable: 'true',
      ),
      CategoryModel(
        id: '8',
        title: 'Travel',
        assignable: 'true',
      ),
    ];
    
    print('🔵 Returning ${categories.length} categories');
    return categories;
  }

  // Placeholder implementations for other required methods
  @override
  Future<List<YouTubeVideoModel>> getVideosByCategory({
    required String categoryId,
    int maxResults = 25,
  }) async {
    return [];
  }

  @override
  Future<List<YouTubeVideoModel>> getRelatedVideos({
    required String videoId,
    int maxResults = 25,
  }) async {
    return [];
  }

  @override
  Future<List<YouTubeVideoModel>> getChannelVideos({
    required String channelId,
    int maxResults = 25,
  }) async {
    return [];
  }

  @override
  Future<List<YouTubeVideoModel>> getPopularVideos({
    String? regionCode,
    int maxResults = 25,
  }) async {
    return [];
  }

  @override
  Future<void> clearCache() async {
    print('🔵 TestVideoRepository.clearCache called');
  }

  @override
  Future<List<YouTubeVideoModel>> getCachedTrendingVideos() async {
    return [];
  }

  @override
  Future<List<YouTubeVideoModel>> getCachedLiveStreams() async {
    return [];
  }

  @override
  Future<List<CategoryModel>> getCachedCategories() async {
    return [];
  }
}
