import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'video_card.dart';

class VideoList extends StatelessWidget {
  final List<Map<String, dynamic>> videos;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsets? padding;
  final VoidCallback? onVideoTap;
  final VoidCallback? onChannelTap;
  final VoidCallback? onLoadMore;
  final bool isLoading;
  final bool hasMore;
  final String? emptyMessage;
  final Widget? emptyWidget;

  const VideoList({
    super.key,
    required this.videos,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
    this.onVideoTap,
    this.onChannelTap,
    this.onLoadMore,
    this.isLoading = false,
    this.hasMore = true,
    this.emptyMessage,
    this.emptyWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      scrollDirection: scrollDirection,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      itemCount: videos.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == videos.length) {
          return _buildLoadingIndicator();
        }

        final video = videos[index];
        return VideoCard(
          thumbnailUrl: video['thumbnailUrl'] ?? '',
          title: video['title'] ?? '',
          channelName: video['channelName'] ?? '',
          duration: video['duration'] ?? '',
          views: video['views'] ?? '',
          uploadTime: video['uploadTime'] ?? '',
          onTap: onVideoTap,
          onChannelTap: onChannelTap,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    if (emptyWidget != null) {
      return emptyWidget!;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 64,
              color: AppTheme.textLight,
            ),
            const SizedBox(height: AppTheme.spacingL),
            Text(
              emptyMessage ?? 'No videos found',
              style: AppTheme.headingSmall.copyWith(
                color: AppTheme.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              'Check back later for new content',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    if (!isLoading) {
      return const SizedBox.shrink();
    }

    return const Padding(
      padding: EdgeInsets.all(AppTheme.spacingL),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            AppTheme.primaryPurple,
          ),
        ),
      ),
    );
  }
}

// Horizontal video list
class HorizontalVideoList extends StatelessWidget {
  final List<Map<String, dynamic>> videos;
  final EdgeInsets? padding;
  final VoidCallback? onVideoTap;
  final VoidCallback? onChannelTap;
  final String? title;
  final VoidCallback? onSeeAll;

  const HorizontalVideoList({
    super.key,
    required this.videos,
    this.padding,
    this.onVideoTap,
    this.onChannelTap,
    this.title,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title!,
                  style: AppTheme.headingMedium.copyWith(
                    color: AppTheme.textDark,
                  ),
                ),
                if (onSeeAll != null)
                  TextButton(
                    onPressed: onSeeAll,
                    child: const Text('See All'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
        ],
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return Container(
                width: 300,
                margin: const EdgeInsets.only(right: AppTheme.spacingM),
                child: VideoCard(
                  thumbnailUrl: video['thumbnailUrl'] ?? '',
                  title: video['title'] ?? '',
                  channelName: video['channelName'] ?? '',
                  duration: video['duration'] ?? '',
                  views: video['views'] ?? '',
                  uploadTime: video['uploadTime'] ?? '',
                  onTap: onVideoTap,
                  onChannelTap: onChannelTap,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Grid video list
class VideoGrid extends StatelessWidget {
  final List<Map<String, dynamic>> videos;
  final int crossAxisCount;
  final double childAspectRatio;
  final EdgeInsets? padding;
  final VoidCallback? onVideoTap;
  final VoidCallback? onChannelTap;
  final bool isLoading;
  final VoidCallback? onLoadMore;

  const VideoGrid({
    super.key,
    required this.videos,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.8,
    this.padding,
    this.onVideoTap,
    this.onChannelTap,
    this.isLoading = false,
    this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding ?? const EdgeInsets.all(AppTheme.spacingM),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: AppTheme.spacingM,
        mainAxisSpacing: AppTheme.spacingM,
      ),
      itemCount: videos.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == videos.length) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.primaryPurple,
              ),
            ),
          );
        }

        final video = videos[index];
        return VideoCard(
          thumbnailUrl: video['thumbnailUrl'] ?? '',
          title: video['title'] ?? '',
          channelName: video['channelName'] ?? '',
          duration: video['duration'] ?? '',
          views: video['views'] ?? '',
          uploadTime: video['uploadTime'] ?? '',
          onTap: onVideoTap,
          onChannelTap: onChannelTap,
        );
      },
    );
  }
}

// Compact video list for sidebars
class CompactVideoList extends StatelessWidget {
  final List<Map<String, dynamic>> videos;
  final EdgeInsets? padding;
  final VoidCallback? onVideoTap;
  final VoidCallback? onChannelTap;

  const CompactVideoList({
    super.key,
    required this.videos,
    this.padding,
    this.onVideoTap,
    this.onChannelTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
                child: Image.network(
                  video['thumbnailUrl'] ?? '',
                  width: 120,
                  height: 68,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 68,
                      color: AppTheme.lightGray,
                      child: const Icon(
                        Icons.video_library,
                        color: AppTheme.textLight,
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(width: AppTheme.spacingM),
              
              // Video Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video['title'] ?? '',
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    Text(
                      video['channelName'] ?? '',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    Text(
                      '${video['views'] ?? ''} views • ${video['uploadTime'] ?? ''}',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
