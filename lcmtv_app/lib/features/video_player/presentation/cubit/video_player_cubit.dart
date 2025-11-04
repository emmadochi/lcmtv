import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/models/video_metadata_model.dart';
import '../../../../features/video/domain/repositories/video_repository.dart';
import '../../../../core/services/cloud_functions_service.dart';

// ============================================================================
// EVENTS
// ============================================================================

abstract class VideoPlayerEvent extends Equatable {
  const VideoPlayerEvent();

  @override
  List<Object?> get props => [];
}

class PlayerReady extends VideoPlayerEvent {
  const PlayerReady();
}

class VideoPlaying extends VideoPlayerEvent {
  const VideoPlaying();
}

class VideoPaused extends VideoPlayerEvent {
  const VideoPaused();
}

class VideoEnded extends VideoPlayerEvent {
  const VideoEnded();
}

class LikeVideo extends VideoPlayerEvent {
  const LikeVideo();
}

class UnlikeVideo extends VideoPlayerEvent {
  const UnlikeVideo();
}

class AddToWatchHistory extends VideoPlayerEvent {
  final String videoId;
  final Duration watchTime;
  final double completionPercentage;

  const AddToWatchHistory({
    required this.videoId,
    required this.watchTime,
    required this.completionPercentage,
  });

  @override
  List<Object?> get props => [videoId, watchTime, completionPercentage];
}

class LoadVideoDetails extends VideoPlayerEvent {
  final String videoId;

  const LoadVideoDetails({required this.videoId});

  @override
  List<Object?> get props => [videoId];
}

// ============================================================================
// STATES
// ============================================================================

abstract class VideoPlayerState extends Equatable {
  const VideoPlayerState();

  @override
  List<Object?> get props => [];
}

class VideoPlayerInitial extends VideoPlayerState {}

class VideoPlayerLoading extends VideoPlayerState {}

class VideoPlayerLoaded extends VideoPlayerState {
  final VideoMetadata video;
  final bool isLiked;
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;
  final double volume;
  final bool isMuted;

  const VideoPlayerLoaded({
    required this.video,
    this.isLiked = false,
    this.isPlaying = false,
    this.currentPosition = Duration.zero,
    this.totalDuration = Duration.zero,
    this.volume = 1.0,
    this.isMuted = false,
  });

  @override
  List<Object?> get props => [
    video,
    isLiked,
    isPlaying,
    currentPosition,
    totalDuration,
    volume,
    isMuted,
  ];
}

class VideoPlayerError extends VideoPlayerState {
  final String message;

  const VideoPlayerError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ============================================================================
// CUBIT
// ============================================================================

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  final VideoRepository _videoRepository;

  VideoPlayerCubit({VideoRepository? videoRepository})
      : _videoRepository = videoRepository ?? VideoRepositoryImpl(
          remoteDataSource: VideoRemoteDataSourceImpl(
            firestore: FirebaseFirestore.instance,
            auth: FirebaseAuth.instance,
          ),
          localDataSource: VideoLocalDataSourceImpl(
            prefs: SharedPreferences.getInstance(),
          ),
          firestore: FirebaseFirestore.instance,
          auth: FirebaseAuth.instance,
        ),
        super(VideoPlayerInitial());

  // ============================================================================
  // EVENT HANDLERS
  // ============================================================================

  void onPlayerReady() {
    emit(VideoPlayerLoaded(
      video: const VideoMetadata(
        id: '',
        title: '',
        description: '',
        channelId: '',
        channelTitle: '',
        thumbnailUrl: '',
        publishedAt: '',
        duration: Duration.zero,
        categoryId: '0',
        categoryTitle: 'Unknown',
      ),
    ));
  }

  void onVideoPlaying() {
    if (state is VideoPlayerLoaded) {
      final currentState = state as VideoPlayerLoaded;
      emit(currentState.copyWith(isPlaying: true));
    }
  }

  void onVideoPaused() {
    if (state is VideoPlayerLoaded) {
      final currentState = state as VideoPlayerLoaded;
      emit(currentState.copyWith(isPlaying: false));
    }
  }

  void onVideoEnded() {
    if (state is VideoPlayerLoaded) {
      final currentState = state as VideoPlayerLoaded;
      emit(currentState.copyWith(isPlaying: false));
    }
  }

  Future<void> likeVideo() async {
    if (state is VideoPlayerLoaded) {
      final currentState = state as VideoPlayerLoaded;
      
      try {
        final success = await _videoRepository.likeVideo(currentState.video.id);
        if (success) {
          emit(currentState.copyWith(isLiked: true));
          
          // Track engagement
          await CloudFunctionsService.trackUserEngagement(
            action: 'video_liked',
            parameters: {
              'videoId': currentState.video.id,
              'videoTitle': currentState.video.title,
            },
          );
        }
      } catch (e) {
        emit(VideoPlayerError(message: 'Failed to like video: $e'));
      }
    }
  }

  Future<void> unlikeVideo() async {
    if (state is VideoPlayerLoaded) {
      final currentState = state as VideoPlayerLoaded;
      
      try {
        final success = await _videoRepository.unlikeVideo(currentState.video.id);
        if (success) {
          emit(currentState.copyWith(isLiked: false));
          
          // Track engagement
          await CloudFunctionsService.trackUserEngagement(
            action: 'video_unliked',
            parameters: {
              'videoId': currentState.video.id,
              'videoTitle': currentState.video.title,
            },
          );
        }
      } catch (e) {
        emit(VideoPlayerError(message: 'Failed to unlike video: $e'));
      }
    }
  }

  Future<void> addToWatchHistory({
    required String videoId,
    required Duration watchTime,
    required double completionPercentage,
  }) async {
    try {
      await _videoRepository.addToWatchHistory(
        videoId: videoId,
        watchTime: watchTime,
        completionPercentage: completionPercentage,
      );
    } catch (e) {
      print('❌ Error adding to watch history: $e');
    }
  }

  Future<void> loadVideoDetails(String videoId) async {
    emit(VideoPlayerLoading());
    
    try {
      final video = await _videoRepository.getVideoDetails(videoId);
      if (video != null) {
        final isLiked = await _videoRepository.isVideoLiked(videoId);
        emit(VideoPlayerLoaded(
          video: video,
          isLiked: isLiked,
        ));
      } else {
        emit(const VideoPlayerError(message: 'Video not found'));
      }
    } catch (e) {
      emit(VideoPlayerError(message: 'Failed to load video: $e'));
    }
  }

  void updateCurrentPosition(Duration position) {
    if (state is VideoPlayerLoaded) {
      final currentState = state as VideoPlayerLoaded;
      emit(currentState.copyWith(currentPosition: position));
    }
  }

  void updateTotalDuration(Duration duration) {
    if (state is VideoPlayerLoaded) {
      final currentState = state as VideoPlayerLoaded;
      emit(currentState.copyWith(totalDuration: duration));
    }
  }

  void updateVolume(double volume) {
    if (state is VideoPlayerLoaded) {
      final currentState = state as VideoPlayerLoaded;
      emit(currentState.copyWith(volume: volume));
    }
  }

  void toggleMute() {
    if (state is VideoPlayerLoaded) {
      final currentState = state as VideoPlayerLoaded;
      emit(currentState.copyWith(isMuted: !currentState.isMuted));
    }
  }
}

// ============================================================================
// EXTENSIONS
// ============================================================================

extension VideoPlayerLoadedCopyWith on VideoPlayerLoaded {
  VideoPlayerLoaded copyWith({
    VideoMetadata? video,
    bool? isLiked,
    bool? isPlaying,
    Duration? currentPosition,
    Duration? totalDuration,
    double? volume,
    bool? isMuted,
  }) {
    return VideoPlayerLoaded(
      video: video ?? this.video,
      isLiked: isLiked ?? this.isLiked,
      isPlaying: isPlaying ?? this.isPlaying,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      volume: volume ?? this.volume,
      isMuted: isMuted ?? this.isMuted,
    );
  }
}
