import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/video_card.dart';
import '../../../../shared/widgets/category_chip.dart';
import '../../../../shared/widgets/logo_widget.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _categories = [
    'All',
    'Music',
    'Gaming',
    'News',
    'Sports',
    'Education',
    'Entertainment',
    'Science',
    'Technology',
    'Lifestyle',
  ];

  // Trending statistics
  final Map<String, dynamic> _trendingStats = {
    'totalViews': '125.6M',
    'totalVideos': '2,847',
    'topCategory': 'Music',
    'trendingGrowth': '+23.5%',
  };

  // Sample trending videos data
  final Map<String, List<Map<String, dynamic>>> _trendingVideos = {
    'All': [
      {
        'thumbnailUrl': 'https://via.placeholder.com/400x225/6B46C1/FFFFFF?text=Trending+1',
        'title': 'Amazing Trending Video That Everyone is Watching',
        'channelName': 'Trending Channel',
        'duration': '12:30',
        'views': '2.5M',
        'uploadTime': '2 hours ago',
        'trendingRank': 1,
      },
      {
        'thumbnailUrl': 'https://via.placeholder.com/400x225/8B5CF6/FFFFFF?text=Trending+2',
        'title': 'Viral Content That Broke the Internet',
        'channelName': 'Viral Hub',
        'duration': '8:45',
        'views': '1.8M',
        'uploadTime': '5 hours ago',
        'trendingRank': 2,
      },
      {
        'thumbnailUrl': 'https://via.placeholder.com/400x225/A78BFA/FFFFFF?text=Trending+3',
        'title': 'Educational Content That Everyone Should Watch',
        'channelName': 'Edu Channel',
        'duration': '15:20',
        'views': '1.2M',
        'uploadTime': '1 day ago',
        'trendingRank': 3,
      },
    ],
    'Music': [
      {
        'thumbnailUrl': 'https://via.placeholder.com/400x225/6B46C1/FFFFFF?text=Music+1',
        'title': 'Latest Hit Song Music Video',
        'channelName': 'Music Channel',
        'duration': '3:45',
        'views': '5.2M',
        'uploadTime': '1 hour ago',
        'trendingRank': 1,
      },
    ],
    'Gaming': [
      {
        'thumbnailUrl': 'https://via.placeholder.com/400x225/8B5CF6/FFFFFF?text=Gaming+1',
        'title': 'Epic Gaming Moment That Went Viral',
        'channelName': 'Gaming Pro',
        'duration': '10:15',
        'views': '3.1M',
        'uploadTime': '3 hours ago',
        'trendingRank': 1,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: _buildAppBar(),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              slivers: [
                // Trending Hero Section
                SliverToBoxAdapter(
                  child: _buildTrendingHero(),
                ),
                
                // Categories Section
                SliverToBoxAdapter(
                  child: _buildCategoriesSection(),
                ),
                
                // Trending Content
                SliverToBoxAdapter(
                  child: _buildTrendingContent(_selectedCategory),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.backgroundWhite,
      elevation: 0,
      title: const LogoWidget(
        width: 32,
        height: 32,
        showText: true,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppTheme.textDark),
          onPressed: () {
            // Navigate to search
          },
        ),
        IconButton(
          icon: const Icon(Icons.filter_list, color: AppTheme.textDark),
          onPressed: () {
            _showFilterOptions();
          },
        ),
      ],
    );
  }

  Widget _buildTrendingHero() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryPurple,
            AppTheme.secondaryPurple,
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingS),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundWhite.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: AppTheme.backgroundWhite,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trending Now',
                      style: AppTheme.headingMedium.copyWith(
                        color: AppTheme.backgroundWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_trendingStats['totalViews']} total views today',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.backgroundWhite.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingS,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundWhite.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppTheme.radiusL),
                ),
                child: Text(
                  _trendingStats['trendingGrowth'],
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.backgroundWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // Stats Row
          Row(
            children: [
              _buildStatItem(
                'Videos',
                _trendingStats['totalVideos'],
                Icons.video_library,
              ),
              const SizedBox(width: AppTheme.spacingL),
              _buildStatItem(
                'Top Category',
                _trendingStats['topCategory'],
                Icons.category,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: AppTheme.backgroundWhite.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.backgroundWhite,
              size: 20,
            ),
            const SizedBox(width: AppTheme.spacingS),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.backgroundWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    label,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.backgroundWhite.withValues(alpha: 0.8),
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

  Widget _buildCategoriesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: AppTheme.headingMedium.copyWith(
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                
                return Padding(
                  padding: const EdgeInsets.only(right: AppTheme.spacingS),
                  child: CategoryChip(
                    label: category,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    icon: _getCategoryIcon(category),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Music':
        return Icons.music_note;
      case 'Gaming':
        return Icons.games;
      case 'News':
        return Icons.newspaper;
      case 'Sports':
        return Icons.sports;
      case 'Education':
        return Icons.school;
      case 'Entertainment':
        return Icons.movie;
      case 'Science':
        return Icons.science;
      case 'Technology':
        return Icons.computer;
      case 'Lifestyle':
        return Icons.favorite;
      default:
        return Icons.trending_up;
    }
  }

  Widget _buildTrendingContent(String category) {
    final videos = _trendingVideos[category] ?? [];

    if (videos.isEmpty) {
      return _buildEmptyState(category);
    }

    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trending in $category',
                style: AppTheme.headingMedium.copyWith(
                  color: AppTheme.textDark,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // Navigate to all trending
                },
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          ...videos.asMap().entries.map((entry) {
            final index = entry.key;
            final video = entry.value;
            return _buildModernTrendingCard(video, index + 1);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildModernTrendingCard(Map<String, dynamic> video, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to video player
          },
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Row(
              children: [
                // Ranking Badge
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _getRankGradient(rank),
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                    boxShadow: [
                      BoxShadow(
                        color: _getRankColor(rank).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '#$rank',
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.backgroundWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: AppTheme.spacingM),
                
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  child: Stack(
                    children: [
                      Image.network(
                        video['thumbnailUrl'],
                        width: 140,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 140,
                            height: 80,
                            color: AppTheme.lightGray,
                            child: const Icon(
                              Icons.video_library,
                              color: AppTheme.textLight,
                              size: 32,
                            ),
                          );
                        },
                      ),
                      // Duration overlay
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            video['duration'],
                            style: const TextStyle(
                              color: AppTheme.backgroundWhite,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: AppTheme.spacingM),
                
                // Video Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video['title'],
                        style: AppTheme.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: AppTheme.spacingXS),
                      
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppTheme.primaryPurple.withValues(alpha: 0.1),
                            child: Text(
                              video['channelName'][0].toUpperCase(),
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.primaryPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Expanded(
                            child: Text(
                              video['channelName'],
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textLight,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppTheme.spacingXS),
                      
                      Row(
                        children: [
                          Icon(
                            Icons.visibility,
                            size: 14,
                            color: AppTheme.textLight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${video['views']} views',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textLight,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Text(
                            '•',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textLight,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Text(
                            video['uploadTime'],
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // More Options
                PopupMenuButton<String>(
                  onSelected: (value) {
                    _handleMenuAction(value, video);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'watch_later',
                      child: Row(
                        children: [
                          Icon(Icons.watch_later, size: 20),
                          SizedBox(width: 8),
                          Text('Watch Later'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'playlist',
                      child: Row(
                        children: [
                          Icon(Icons.playlist_add, size: 20),
                          SizedBox(width: 8),
                          Text('Add to Playlist'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          Icon(Icons.share, size: 20),
                          SizedBox(width: 8),
                          Text('Share'),
                        ],
                      ),
                    ),
                  ],
                  child: const Icon(
                    Icons.more_vert,
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _getRankGradient(int rank) {
    switch (rank) {
      case 1:
        return [const Color(0xFFFFD700), const Color(0xFFFFA500)]; // Gold
      case 2:
        return [const Color(0xFFC0C0C0), const Color(0xFFA0A0A0)]; // Silver
      case 3:
        return [const Color(0xFFCD7F32), const Color(0xFFB8860B)]; // Bronze
      default:
        return [AppTheme.primaryPurple, AppTheme.secondaryPurple];
    }
  }

  void _handleMenuAction(String action, Map<String, dynamic> video) {
    switch (action) {
      case 'watch_later':
        // Handle watch later
        break;
      case 'playlist':
        // Handle add to playlist
        break;
      case 'share':
        // Handle share
        break;
    }
  }

  void _showFilterOptions() {
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
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            Text(
              'Filter Options',
              style: AppTheme.headingMedium.copyWith(
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            // Add filter options here
            const Text('Filter options will be implemented here'),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String category) {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingXL),
            decoration: BoxDecoration(
              color: AppTheme.lightGray,
              borderRadius: BorderRadius.circular(AppTheme.radiusL),
            ),
            child: Icon(
              Icons.trending_up,
              size: 64,
              color: AppTheme.textLight,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          Text(
            'No trending videos in $category',
            style: AppTheme.headingMedium.copyWith(
              color: AppTheme.textDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Check back later for trending content in this category',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingL),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _selectedCategory = 'All';
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('View All Trending'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: AppTheme.backgroundWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppTheme.primaryPurple;
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate refresh
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
        // Refresh data here
      });
    }
  }
}
