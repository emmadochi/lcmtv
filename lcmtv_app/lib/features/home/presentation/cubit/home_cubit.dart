import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/models/video_metadata_model.dart';
import '../../../../core/models/category_model.dart';
import '../../../../core/models/youtube_video_model.dart';
import '../../../../features/video/domain/repositories/video_repository.dart';

// ============================================================================
// EVENTS
// ============================================================================

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeData extends HomeEvent {
  const LoadHomeData();
}

class LoadTrendingVideos extends HomeEvent {
  final String? categoryId;
  const LoadTrendingVideos({this.categoryId});
}

class LoadLiveStreams extends HomeEvent {
  final String? categoryId;
  const LoadLiveStreams({this.categoryId});
}

class SearchVideos extends HomeEvent {
  final String query;
  final String? categoryId;
  const SearchVideos({required this.query, this.categoryId});
}

class LoadCategories extends HomeEvent {
  const LoadCategories();
}

class RefreshHomeData extends HomeEvent {
  const RefreshHomeData();
}

// ============================================================================
// STATES
// ============================================================================

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<VideoMetadata> trendingVideos;
  final List<VideoMetadata> liveStreams;
  final List<VideoMetadata> featuredVideos;
  final List<CategoryModel> categories;
  final String? selectedCategory;
  final bool hasMoreTrending;
  final bool hasMoreLiveStreams;

  const HomeLoaded({
    required this.trendingVideos,
    required this.liveStreams,
    required this.featuredVideos,
    required this.categories,
    this.selectedCategory,
    this.hasMoreTrending = true,
    this.hasMoreLiveStreams = true,
  });

  @override
  List<Object?> get props => [
    trendingVideos,
    liveStreams,
    featuredVideos,
    categories,
    selectedCategory,
    hasMoreTrending,
    hasMoreLiveStreams,
  ];
}

class HomeError extends HomeState {
  final String message;
  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ============================================================================
// CUBIT
// ============================================================================

class HomeCubit extends Cubit<HomeState> {
  final VideoRepository _videoRepository;

  HomeCubit({required VideoRepository videoRepository})
      : _videoRepository = videoRepository,
        super(HomeInitial());

  // ============================================================================
  // EVENT HANDLERS
  // ============================================================================

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    
    try {
      // Load all home data in parallel
      final results = await Future.wait([
        _videoRepository.getTrendingVideos(maxResults: 20),
        _videoRepository.getLiveStreams(maxResults: 10),
        _videoRepository.getCategories(),
      ]);

      final trendingVideos = results[0] as List<VideoMetadata>;
      final liveStreams = results[1] as List<VideoMetadata>;
      final categories = results[2] as List<CategoryModel>;

      // Get featured videos (top trending)
      final featuredVideos = trendingVideos.take(5).toList();

      emit(HomeLoaded(
        trendingVideos: trendingVideos,
        liveStreams: liveStreams,
        featuredVideos: featuredVideos,
        categories: categories,
      ));
    } catch (e) {
      emit(HomeError(message: 'Failed to load home data: $e'));
    }
  }

  Future<void> loadTrendingVideos({String? categoryId}) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      
      try {
        final trendingVideos = await _videoRepository.getTrendingVideos(
          categoryId: categoryId,
          maxResults: 20,
        );

        // Convert YouTubeVideoModel to VideoMetadata
        final videoMetadataList = await _convertToVideoMetadataList(trendingVideos);
        
        emit(currentState.copyWith(
          trendingVideos: videoMetadataList,
          selectedCategory: categoryId,
        ));
      } catch (e) {
        emit(HomeError(message: 'Failed to load trending videos: $e'));
      }
    }
  }

  Future<void> loadLiveStreams({String? categoryId}) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      
      try {
        final liveStreams = await _videoRepository.getLiveStreams(
          categoryId: categoryId,
          maxResults: 10,
        );

        // Convert YouTubeVideoModel to VideoMetadata
        final videoMetadataList = await _convertToVideoMetadataList(liveStreams);
        
        emit(currentState.copyWith(liveStreams: videoMetadataList));
      } catch (e) {
        emit(HomeError(message: 'Failed to load live streams: $e'));
      }
    }
  }

  Future<void> searchVideos({required String query, String? categoryId}) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      
      try {
        final searchResults = await _videoRepository.searchVideos(
          query: query,
          categoryId: categoryId,
          maxResults: 20,
        );

        // Convert YouTubeVideoModel to VideoMetadata
        final videoMetadataList = await _convertToVideoMetadataList(searchResults);
        
        emit(currentState.copyWith(
          featuredVideos: videoMetadataList,
          selectedCategory: categoryId,
        ));
      } catch (e) {
        emit(HomeError(message: 'Failed to search videos: $e'));
      }
    }
  }

  Future<void> loadCategories() async {
    try {
      final categories = await _videoRepository.getCategories();
      
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(currentState.copyWith(categories: categories));
      } else {
        emit(HomeLoaded(
          trendingVideos: const [],
          liveStreams: const [],
          featuredVideos: const [],
          categories: categories,
        ));
      }
    } catch (e) {
      emit(HomeError(message: 'Failed to load categories: $e'));
    }
  }

  Future<void> refreshHomeData() async {
    await loadHomeData();
  }

  void selectCategory(String? categoryId) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(selectedCategory: categoryId));
    }
  }

  // Helper method to convert YouTubeVideoModel to VideoMetadata
  Future<List<VideoMetadata>> _convertToVideoMetadataList(List<YouTubeVideoModel> videos) async {
    final List<VideoMetadata> videoMetadataList = [];
    for (final video in videos) {
      // Get category title (simplified - you might want to implement proper category lookup)
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

  // Helper method to get category title
  Future<String> _getCategoryTitle(String categoryId) async {
    try {
      final categories = await _videoRepository.getCategories();
      final category = categories.firstWhere(
        (cat) => cat.id == categoryId,
        orElse: () => CategoryModel(id: categoryId, title: 'Unknown', assignable: 'true'),
      );
      return category.title;
    } catch (e) {
      return 'Unknown';
    }
  }
}

// ============================================================================
// EXTENSIONS
// ============================================================================

extension HomeLoadedCopyWith on HomeLoaded {
  HomeLoaded copyWith({
    List<VideoMetadata>? trendingVideos,
    List<VideoMetadata>? liveStreams,
    List<VideoMetadata>? featuredVideos,
    List<CategoryModel>? categories,
    String? selectedCategory,
    bool? hasMoreTrending,
    bool? hasMoreLiveStreams,
  }) {
    return HomeLoaded(
      trendingVideos: trendingVideos ?? this.trendingVideos,
      liveStreams: liveStreams ?? this.liveStreams,
      featuredVideos: featuredVideos ?? this.featuredVideos,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      hasMoreTrending: hasMoreTrending ?? this.hasMoreTrending,
      hasMoreLiveStreams: hasMoreLiveStreams ?? this.hasMoreLiveStreams,
    );
  }

}
