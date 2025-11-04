import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/logo_widget.dart';
import '../../../../core/auth/admin_guard.dart';
import '../widgets/video_card_modern.dart';
import '../widgets/category_chip.dart';
import '../widgets/trending_section.dart';
import '../widgets/live_section.dart';
import '../widgets/featured_section.dart';
import '../widgets/firestore_connection_status.dart';

class ModernHomeScreen extends StatefulWidget {
  const ModernHomeScreen({super.key});

  @override
  State<ModernHomeScreen> createState() => _ModernHomeScreenState();
}

class _ModernHomeScreenState extends State<ModernHomeScreen> {
  final ScrollController _scrollController = ScrollController();
  String _selectedCategory = 'All';
  
  final List<String> _categories = [
    'All',
    'Gaming',
    'Music',
    'Tech',
    'Entertainment',
    'Education',
    'Sports',
    'News',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.backgroundWhite,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryPurple,
                      AppTheme.primaryPurple.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingL),
                    child: Row(
                      children: [
                        const LargeLogoWidget(
                          width: 40,
                          height: 40,
                          showText: true,
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: () {
                            // Handle search
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                          onPressed: () {
                            // Handle notifications
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
                          onPressed: () => navigateToAdminIfAuthorized(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Welcome Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to LCMTV',
                    style: AppTheme.headingLarge.copyWith(
                      color: AppTheme.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    'Discover amazing videos and live streams',
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Firestore Connection Status
          const SliverToBoxAdapter(
            child: FirestoreConnectionStatus(),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppTheme.spacingL),
          ),

          // Categories Section
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: AppTheme.spacingM),
                    child: CategoryChip(
                      label: category,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppTheme.spacingL),
          ),

          // Featured Section
          const SliverToBoxAdapter(
            child: FeaturedSection(),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppTheme.spacingXL),
          ),

          // Trending Section
          const SliverToBoxAdapter(
            child: TrendingSection(),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppTheme.spacingXL),
          ),

          // Live Section
          const SliverToBoxAdapter(
            child: LiveSection(),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppTheme.spacingXL),
          ),

          // Recent Videos Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Recent Videos',
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
                  _buildRecentVideosGrid(),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppTheme.spacingXXL),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentVideosGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 16 / 9,
        crossAxisSpacing: AppTheme.spacingM,
        mainAxisSpacing: AppTheme.spacingM,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return VideoCardModern(
          title: 'Amazing Video ${index + 1}',
          channel: 'Channel ${index + 1}',
          views: '${(index + 1) * 1000}K views',
          duration: '${(index + 1) * 2}:30',
          thumbnailUrl: 'https://picsum.photos/seed/video$index/300/200',
          onTap: () {
            _showVideoPlayer('dQw4w9WgXcQ'); // Sample video ID
          },
        );
      },
    );
  }

  void _showVideoPlayer(String videoId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppTheme.radiusL),
            topRight: Radius.circular(AppTheme.radiusL),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
              decoration: BoxDecoration(
                color: AppTheme.textLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Video Player
            Expanded(
              child: YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: videoId,
                  flags: const YoutubePlayerFlags(
                    autoPlay: true,
                    mute: false,
                    isLive: false,
                  ),
                ),
                showVideoProgressIndicator: true,
                progressIndicatorColor: AppTheme.primaryPurple,
                onReady: () {
                  // Video is ready
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
