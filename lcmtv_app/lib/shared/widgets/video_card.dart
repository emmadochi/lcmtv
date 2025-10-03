import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class VideoCard extends StatelessWidget {
  final String thumbnailUrl;
  final String title;
  final String channelName;
  final String duration;
  final String views;
  final String uploadTime;
  final VoidCallback? onTap;
  final VoidCallback? onChannelTap;

  const VideoCard({
    super.key,
    required this.thumbnailUrl,
    required this.title,
    required this.channelName,
    required this.duration,
    required this.views,
    required this.uploadTime,
    this.onTap,
    this.onChannelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppTheme.radiusM),
                      topRight: Radius.circular(AppTheme.radiusM),
                    ),
                    color: AppTheme.lightGray,
                  ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppTheme.radiusM),
                        topRight: Radius.circular(AppTheme.radiusM),
                      ),
                      child: Image.network(
                        thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppTheme.lightGray,
                            child: const Icon(
                              Icons.video_library,
                              size: 48,
                              color: AppTheme.textLight,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: AppTheme.lightGray,
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryPurple,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ),
                // Duration Badge
                Positioned(
                  bottom: AppTheme.spacingS,
                  right: AppTheme.spacingS,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingS,
                      vertical: AppTheme.spacingXS,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                    child: Text(
                      duration,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.backgroundWhite,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // Play Button Overlay
                const Positioned.fill(
                  child: Center(
                    child: Icon(
                      Icons.play_circle_filled,
                      size: 48,
                      color: AppTheme.backgroundWhite,
                    ),
                  ),
                ),
              ],
            ),
            
            // Video Info
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: AppTheme.spacingS),
                  
                  // Channel Info
                  Row(
                    children: [
                      // Channel Avatar
                      GestureDetector(
                        onTap: onChannelTap,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryPurple,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 18,
                            color: AppTheme.backgroundWhite,
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: AppTheme.spacingS),
                      
                      // Channel Name and Stats
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: onChannelTap,
                              child: Text(
                                channelName,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textDark,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '$views views • $uploadTime',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // More Options
                      IconButton(
                        onPressed: () {
                          _showMoreOptions(context);
                        },
                        icon: const Icon(
                          Icons.more_vert,
                          color: AppTheme.textLight,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
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

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusL),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            
            // Options
            _buildOption(
              icon: Icons.watch_later,
              title: 'Save to Watch Later',
              onTap: () {
                Navigator.pop(context);
                // Handle save to watch later
              },
            ),
            _buildOption(
              icon: Icons.playlist_add,
              title: 'Add to Playlist',
              onTap: () {
                Navigator.pop(context);
                // Handle add to playlist
              },
            ),
            _buildOption(
              icon: Icons.share,
              title: 'Share',
              onTap: () {
                Navigator.pop(context);
                // Handle share
              },
            ),
            _buildOption(
              icon: Icons.report,
              title: 'Report',
              onTap: () {
                Navigator.pop(context);
                // Handle report
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textDark),
      title: Text(
        title,
        style: AppTheme.bodyLarge.copyWith(
          color: AppTheme.textDark,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
