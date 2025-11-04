import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/logo_widget.dart';
import '../../../../core/models/video_metadata_model.dart';
import '../cubit/home_cubit.dart';
import '../../../../core/services/youtube_service.dart';

class HomeScreenWithData extends StatefulWidget {
  const HomeScreenWithData({super.key});

  @override
  State<HomeScreenWithData> createState() => _HomeScreenWithDataState();
}

class _HomeScreenWithDataState extends State<HomeScreenWithData> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    context.read<HomeCubit>().loadTrendingVideos();
    context.read<HomeCubit>().loadLiveStreams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        title: const LargeLogoWidget(
          width: 40,
          height: 40,
          showText: true,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed('/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading videos...'),
                ],
              ),
            );
          }

          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppTheme.errorRed,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading videos',
                    style: AppTheme.headingMedium.copyWith(
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeCubit>().loadTrendingVideos();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<HomeCubit>().loadTrendingVideos();
                await context.read<HomeCubit>().loadLiveStreams();
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome section
                    Text(
                      'Welcome to LCMTV',
                      style: AppTheme.headingLarge.copyWith(
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    Text(
                      'Discover amazing videos and live streams',
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.textLight,
                      ),
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXXL),
                    
                    // Trending videos section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Trending Videos',
                          style: AppTheme.headingMedium.copyWith(
                            color: AppTheme.textDark,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/trending');
                          },
                          child: const Text('See All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Trending videos grid
                    if (state.trendingVideos.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 16 / 9,
                          crossAxisSpacing: AppTheme.spacingM,
                          mainAxisSpacing: AppTheme.spacingM,
                        ),
                        itemCount: state.trendingVideos.length > 4 ? 4 : state.trendingVideos.length,
                        itemBuilder: (context, index) {
                          final video = state.trendingVideos[index];
                          return _buildVideoCard(video);
                        },
                      )
                    else
                      _buildEmptyState('No trending videos available'),
                    
                    const SizedBox(height: AppTheme.spacingXXL),
                    
                    // Live streams section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Live Streams',
                          style: AppTheme.headingMedium.copyWith(
                            color: AppTheme.textDark,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to live streams
                          },
                          child: const Text('See All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Live streams list
                    if (state.liveStreams.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.liveStreams.length > 3 ? 3 : state.liveStreams.length,
                        itemBuilder: (context, index) {
                          final stream = state.liveStreams[index];
                          return _buildLiveStreamCard(stream);
                        },
                      )
                    else
                      _buildEmptyState('No live streams available'),
                    
                    const SizedBox(height: AppTheme.spacingXXL),
                    
                    // Featured videos section
                    Text(
                      'Featured Videos',
                      style: AppTheme.headingMedium.copyWith(
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Featured videos list
                    if (state.featuredVideos.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.featuredVideos.length > 3 ? 3 : state.featuredVideos.length,
                        itemBuilder: (context, index) {
                          final video = state.featuredVideos[index];
                          return _buildVideoListItem(video);
                        },
                      )
                    else
                      _buildEmptyState('No featured videos available'),
                  ],
                ),
              ),
            );
          }

          return const Center(
            child: Text('Unknown state'),
          );
        },
      ),
    );
  }

  Widget _buildVideoCard(VideoMetadata video) {
    return GestureDetector(
      onTap: () {
        // Navigate to video player
        print('🔵 Video tapped: ${video.title}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightGray,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.textLight,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppTheme.radiusM),
                    topRight: Radius.circular(AppTheme.radiusM),
                  ),
                ),
                child: video.thumbnailUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppTheme.radiusM),
                          topRight: Radius.circular(AppTheme.radiusM),
                        ),
                        child: Image.network(
                          video.thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.play_circle_outline,
                              size: 48,
                              color: AppTheme.backgroundWhite,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.play_circle_outline,
                        size: 48,
                        color: AppTheme.backgroundWhite,
                      ),
              ),
            ),
            // Video info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingS),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video.channelTitle,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 12,
                          color: AppTheme.textLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatViewCount(video.viewCount),
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveStreamCard(VideoMetadata stream) {
    return GestureDetector(
      onTap: () {
        print('🔵 Live stream tapped: ${stream.title}');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: AppTheme.lightGray,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(
            color: AppTheme.errorRed,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Live indicator
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppTheme.errorRed,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppTheme.spacingS),
            Text(
              'LIVE',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.errorRed,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            // Stream thumbnail
            Container(
              width: 80,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.textLight,
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
              ),
              child: stream.thumbnailUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      child: Image.network(
                        stream.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.live_tv,
                            color: AppTheme.backgroundWhite,
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.live_tv,
                      color: AppTheme.backgroundWhite,
                    ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            // Stream info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stream.title,
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stream.channelTitle,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoListItem(VideoMetadata video) {
    return GestureDetector(
      onTap: () {
        print('🔵 Featured video tapped: ${video.title}');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: AppTheme.lightGray,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        child: Row(
          children: [
            // Video thumbnail
            Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.textLight,
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
              ),
              child: video.thumbnailUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      child: Image.network(
                        video.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.play_circle_outline,
                            color: AppTheme.backgroundWhite,
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.play_circle_outline,
                      color: AppTheme.backgroundWhite,
                    ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            // Video info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    video.channelTitle,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.visibility,
                        size: 14,
                        color: AppTheme.textLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatViewCount(video.viewCount),
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textLight,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppTheme.textLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDuration(video.duration),
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      decoration: BoxDecoration(
        color: AppTheme.lightGray,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.video_library_outlined,
            size: 48,
            color: AppTheme.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatViewCount(int viewCount) {
    if (viewCount >= 1000000) {
      return '${(viewCount / 1000000).toStringAsFixed(1)}M views';
    } else if (viewCount >= 1000) {
      return '${(viewCount / 1000).toStringAsFixed(1)}K views';
    } else {
      return '$viewCount views';
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}
