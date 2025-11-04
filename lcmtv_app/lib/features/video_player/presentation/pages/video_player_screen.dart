import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/video_metadata_model.dart';
import '../../../../core/services/cloud_functions_service.dart';
import '../../../../core/firebase/firebase_config.dart';
import '../cubit/video_player_cubit.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoMetadata video;
  final bool autoPlay;

  const VideoPlayerScreen({
    super.key,
    required this.video,
    this.autoPlay = true,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with WidgetsBindingObserver {
  late YoutubePlayerController _youtubeController;
  late VideoPlayerCubit _cubit;
  bool _isFullScreen = false;
  bool _isControlsVisible = true;
  Duration _watchTime = Duration.zero;
  DateTime _startTime = DateTime.now();
  bool _hasPlaybackError = false;
  bool _stalled = false;
  Timer? _startupTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    _cubit = VideoPlayerCubit();
    
    // Initialize YouTube player
    _youtubeController = YoutubePlayerController(
      initialVideoId: widget.video.id,
      flags: YoutubePlayerFlags(
        autoPlay: widget.autoPlay,
        mute: false,
        isLive: widget.video.isLive,
        forceHD: true,
        enableCaption: true,
        showLiveFullscreenButton: widget.video.isLive,
        useHybridComposition: true,
      ),
    );

    _startTime = DateTime.now();
    
    // Listen to player state changes
    _youtubeController.addListener(_onPlayerStateChange);

    // Startup watchdog: if still not playing after 6s, mark stalled
    _startupTimer = Timer(const Duration(seconds: 6), () {
      if (!mounted) return;
      final state = _youtubeController.value.playerState;
      if (state != PlayerState.playing) {
        setState(() {
          _stalled = true;
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _youtubeController.removeListener(_onPlayerStateChange);
    _youtubeController.dispose();
    _cubit.close();
    _startupTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.paused:
        _trackVideoView();
        break;
      case AppLifecycleState.resumed:
        _startTime = DateTime.now();
        break;
      default:
        break;
    }
  }

  void _onPlayerStateChange() {
    final value = _youtubeController.value;
    final playerState = value.playerState;
    if (value.errorCode != 0) {
      setState(() {
        _hasPlaybackError = true;
      });
    }
    
    switch (playerState) {
      case PlayerState.playing:
        _cubit.onVideoPlaying();
        if (_stalled) {
          setState(() {
            _stalled = false;
          });
        }
        break;
      case PlayerState.paused:
        _cubit.onVideoPaused();
        break;
      case PlayerState.ended:
        _cubit.onVideoEnded();
        _trackVideoView();
        break;
      default:
        break;
    }
  }

  void _trackVideoView() async {
    final currentTime = DateTime.now();
    final sessionDuration = currentTime.difference(_startTime);
    _watchTime += sessionDuration;
    
    // Calculate completion percentage
    final totalDuration = _youtubeController.metadata.duration;
    final completionPercentage = totalDuration.inSeconds > 0
        ? (_watchTime.inSeconds / totalDuration.inSeconds * 100).clamp(0.0, 100.0)
        : 0.0;

    // Track video view
    await CloudFunctionsService.trackVideoView(
      videoId: widget.video.id,
      watchTime: _watchTime.inSeconds,
      completionPercentage: completionPercentage,
      deviceType: 'mobile',
    );

    // Add to watch history
    await _cubit.addToWatchHistory(
      videoId: widget.video.id,
      watchTime: _watchTime,
      completionPercentage: completionPercentage,
    );
  }

  Future<void> _openInYouTube() async {
    final url = Uri.parse('https://www.youtube.com/watch?v=${widget.video.id}');
    try {
      // Use url_launcher without importing at top to avoid extra deps in this snippet
      // ignore: deprecated_member_use
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocProvider(
        create: (context) => _cubit,
        child: BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
          builder: (context, state) {
            return Stack(
              children: [
                // Video Player
                Center(
                  child: YoutubePlayer(
                    controller: _youtubeController,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: AppTheme.primaryPurple,
                    onReady: () {
                      _cubit.onPlayerReady();
                    },
                    onEnded: (data) {
                      _cubit.onVideoEnded();
                      _trackVideoView();
                    },
                  ),
                ),

                // Error / Fallback UI
                if (_hasPlaybackError || _stalled)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.4),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.wifi_tethering_error_rounded, color: Colors.white, size: 48),
                            const SizedBox(height: 12),
                            Text(
                              _hasPlaybackError ? 'Playback error' : 'Starting stream…',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _hasPlaybackError = false;
                                      _stalled = false;
                                    });
                                    _youtubeController.reload();
                                  },
                                  child: const Text('Retry'),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton(
                                  onPressed: _openInYouTube,
                                  child: const Text('Open in YouTube'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Custom Controls Overlay
                if (_isControlsVisible)
                  _buildControlsOverlay(),

                // Video Info Panel
                if (!_isFullScreen)
                  _buildVideoInfoPanel(),

                // Back Button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  child: _buildBackButton(),
                ),

                // Full Screen Toggle
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  right: 16,
                  child: _buildFullScreenButton(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildControlsOverlay() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isControlsVisible = !_isControlsVisible;
        });
      },
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: AnimatedOpacity(
            opacity: _isControlsVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Play/Pause Button
                  IconButton(
                    onPressed: () {
                      if (_youtubeController.value.isPlaying) {
                        _youtubeController.pause();
                      } else {
                        _youtubeController.play();
                      }
                    },
                    icon: Icon(
                      _youtubeController.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Like Button
                  BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
                    builder: (context, state) {
                      return IconButton(
                        onPressed: () {
                          if (state.isLiked) {
                            _cubit.unlikeVideo();
                          } else {
                            _cubit.likeVideo();
                          }
                        },
                        icon: Icon(
                          state.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: state.isLiked ? Colors.red : Colors.white,
                          size: 32,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoInfoPanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Video Title
            Text(
              widget.video.title,
              style: AppTheme.headingMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 8),
            
            // Channel Info
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.primaryPurple,
                  child: Text(
                    widget.video.channelTitle.isNotEmpty
                        ? widget.video.channelTitle[0].toUpperCase()
                        : 'C',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.video.channelTitle,
                        style: AppTheme.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${_formatViewCount(widget.video.viewCount)} views',
                        style: AppTheme.bodySmall.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Subscribe Button
                ElevatedButton(
                  onPressed: () {
                    // Handle subscribe
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Subscribe'),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Video Description
            Text(
              widget.video.description,
              style: AppTheme.bodyMedium.copyWith(
                color: Colors.white70,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {
          _trackVideoView();
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFullScreenButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {
          setState(() {
            _isFullScreen = !_isFullScreen;
          });
          
          if (_isFullScreen) {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
          } else {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          }
        },
        icon: Icon(
          _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
          color: Colors.white,
        ),
      ),
    );
  }

  String _formatViewCount(int viewCount) {
    if (viewCount >= 1000000) {
      return '${(viewCount / 1000000).toStringAsFixed(1)}M';
    } else if (viewCount >= 1000) {
      return '${(viewCount / 1000).toStringAsFixed(1)}K';
    } else {
      return viewCount.toString();
    }
  }
}
