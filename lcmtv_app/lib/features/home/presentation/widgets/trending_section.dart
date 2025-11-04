import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'video_card_modern.dart';

class TrendingSection extends StatelessWidget {
  const TrendingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Trending Now',
                style: AppTheme.headingMedium.copyWith(
                  color: AppTheme.textDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Handle see all
                },
                child: Text(
                  'See All',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: AppTheme.spacingM),
                  child: VideoCardModern(
                    title: 'Trending Video ${index + 1}',
                    channel: 'Trending Channel',
                    views: '${(index + 1) * 500}K views',
                    duration: '${(index + 1) * 3}:45',
                    thumbnailUrl: 'https://picsum.photos/seed/trending$index/300/200',
                    onTap: () {
                      // Handle video tap
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
