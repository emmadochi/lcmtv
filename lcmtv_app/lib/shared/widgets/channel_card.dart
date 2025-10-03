import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ChannelCard extends StatelessWidget {
  final String avatarUrl;
  final String channelName;
  final String subscriberCount;
  final bool isVerified;
  final bool isSubscribed;
  final VoidCallback? onTap;
  final VoidCallback? onSubscribe;
  final VoidCallback? onMoreOptions;

  const ChannelCard({
    super.key,
    required this.avatarUrl,
    required this.channelName,
    required this.subscriberCount,
    this.isVerified = false,
    this.isSubscribed = false,
    this.onTap,
    this.onSubscribe,
    this.onMoreOptions,
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
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            children: [
              // Channel Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppTheme.primaryPurple,
                    backgroundImage: NetworkImage(avatarUrl),
                    onBackgroundImageError: (exception, stackTrace) {
                      // Handle image error
                    },
                    child: const Icon(
                      Icons.person,
                      size: 24,
                      color: AppTheme.backgroundWhite,
                    ),
                  ),
                  if (isVerified)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: AppTheme.successGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 10,
                          color: AppTheme.backgroundWhite,
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(width: AppTheme.spacingM),
              
              // Channel Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            channelName,
                            style: AppTheme.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isVerified)
                          const Icon(
                            Icons.verified,
                            size: 16,
                            color: AppTheme.successGreen,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    Text(
                      '$subscriberCount subscribers',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Subscribe Button
              if (onSubscribe != null)
                Container(
                  margin: const EdgeInsets.only(left: AppTheme.spacingS),
                  child: ElevatedButton(
                    onPressed: onSubscribe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSubscribed 
                          ? AppTheme.lightGray 
                          : AppTheme.primaryPurple,
                      foregroundColor: isSubscribed 
                          ? AppTheme.textDark 
                          : AppTheme.backgroundWhite,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                        vertical: AppTheme.spacingS,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusL),
                      ),
                    ),
                    child: Text(
                      isSubscribed ? 'Subscribed' : 'Subscribe',
                      style: AppTheme.bodySmall.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              
              // More Options
              if (onMoreOptions != null)
                IconButton(
                  onPressed: onMoreOptions,
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
        ),
      ),
    );
  }
}

// Compact version for lists
class ChannelCardCompact extends StatelessWidget {
  final String avatarUrl;
  final String channelName;
  final String subscriberCount;
  final bool isVerified;
  final VoidCallback? onTap;

  const ChannelCardCompact({
    super.key,
    required this.avatarUrl,
    required this.channelName,
    required this.subscriberCount,
    this.isVerified = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        ),
        child: Row(
          children: [
            // Channel Avatar
            CircleAvatar(
              radius: 20,
              backgroundColor: AppTheme.primaryPurple,
              backgroundImage: NetworkImage(avatarUrl),
              onBackgroundImageError: (exception, stackTrace) {
                // Handle image error
              },
              child: const Icon(
                Icons.person,
                size: 20,
                color: AppTheme.backgroundWhite,
              ),
            ),
            
            const SizedBox(width: AppTheme.spacingM),
            
            // Channel Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          channelName,
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isVerified)
                        const Icon(
                          Icons.verified,
                          size: 14,
                          color: AppTheme.successGreen,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingXS),
                  Text(
                    subscriberCount,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
