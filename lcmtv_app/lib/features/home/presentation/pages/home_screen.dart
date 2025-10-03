import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/video_card.dart';
import '../../../../shared/widgets/program_card.dart';
import '../../../../shared/widgets/category_chip.dart';
import '../../../../shared/widgets/navigation_components.dart';
import '../../../../shared/widgets/logo_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  String _selectedCategory = 'All';
  late AnimationController _livestreamAnimationController;
  late Animation<double> _livestreamPulseAnimation;

  // Categories for filtering
  final List<String> _categories = [
    'All',
    'Live',
    'Gaming',
    'Music',
    'Education',
    'Entertainment',
    'Sports',
    'News',
  ];

  // Livestream Hero Data
  final Map<String, dynamic> _livestreamData = {
    'thumbnailUrl': 'https://via.placeholder.com/400x225/6B46C1/FFFFFF?text=LIVE+STREAM',
    'title': 'Tech Talk Live: Future of AI in 2024',
    'channelName': 'TechLive Channel',
    'viewerCount': '2.5K',
    'isLive': true,
    'category': 'Technology',
    'description': 'Join us for an exciting discussion about the future of artificial intelligence',
  };

  // Featured Videos Data
  final List<Map<String, dynamic>> _featuredVideos = [
    {
      'thumbnailUrl': 'https://via.placeholder.com/400x225/6B46C1/FFFFFF?text=Featured+1',
      'title': 'Complete Flutter Development Course',
      'channelName': 'Flutter Masters',
      'duration': '2:30:45',
      'views': '125K',
      'uploadTime': '1 day ago',
      'category': 'Education',
    },
    {
      'thumbnailUrl': 'https://via.placeholder.com/400x225/8B5CF6/FFFFFF?text=Featured+2',
      'title': 'Building Modern Mobile Apps',
      'channelName': 'Mobile Dev Hub',
      'duration': '1:45:20',
      'views': '89K',
      'uploadTime': '3 days ago',
      'category': 'Technology',
    },
    {
      'thumbnailUrl': 'https://via.placeholder.com/400x225/A78BFA/FFFFFF?text=Featured+3',
      'title': 'UI/UX Design Masterclass',
      'channelName': 'Design Studio',
      'duration': '3:15:30',
      'views': '156K',
      'uploadTime': '1 week ago',
      'category': 'Design',
    },
  ];

  // Programs Data
  final List<Map<String, dynamic>> _programs = [
    {
      'imageUrl': 'https://via.placeholder.com/280x160/6B46C1/FFFFFF?text=Tech+Program',
      'title': 'Tech Tutorials',
      'description': 'Learn the latest in technology and programming',
      'videoCount': 24,
      'category': 'Technology',
      'subscribers': '45K',
    },
    {
      'imageUrl': 'https://via.placeholder.com/280x160/8B5CF6/FFFFFF?text=Creative+Program',
      'title': 'Creative Arts',
      'description': 'Explore your creative side with amazing tutorials',
      'videoCount': 18,
      'category': 'Arts',
      'subscribers': '32K',
    },
    {
      'imageUrl': 'https://via.placeholder.com/280x160/A78BFA/FFFFFF?text=Business+Program',
      'title': 'Business Insights',
      'description': 'Grow your business with expert strategies',
      'videoCount': 32,
      'category': 'Business',
      'subscribers': '67K',
    },
    {
      'imageUrl': 'https://via.placeholder.com/280x160/6B46C1/FFFFFF?text=Science+Program',
      'title': 'Science & Discovery',
      'description': 'Explore the wonders of science and discovery',
      'videoCount': 28,
      'category': 'Science',
      'subscribers': '89K',
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Initialize livestream animation
    _livestreamAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _livestreamPulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _livestreamAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _livestreamAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _livestreamAnimationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreVideos();
    }
  }

  void _loadMoreVideos() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      // Simulate loading more videos
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  Future<void> _onRefresh() async {
    // Simulate refresh
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        // Refresh data here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppTheme.primaryPurple,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Livestream Hero Section
            SliverToBoxAdapter(
              child: _buildLivestreamHero(),
            ),
            
            // Categories Section
            SliverToBoxAdapter(
              child: _buildCategoriesSection(),
            ),
            
            // Featured Videos Section
            SliverToBoxAdapter(
              child: _buildFeaturedSection(),
            ),
            
            // Programs Section
            SliverToBoxAdapter(
              child: _buildProgramsSection(),
            ),
            
            // Loading Indicator
            if (_isLoading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppTheme.spacingL),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryPurple,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        icon: Icons.add,
        tooltip: 'Create Content',
        onPressed: () {
          // Navigate to create content
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
            // Navigate to search screen
          },
        ),
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined, color: AppTheme.textDark),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.errorRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            // Navigate to notifications
          },
        ),
      ],
    );
  }

  Widget _buildLivestreamHero() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        child: Stack(
          children: [
            // Thumbnail
            Container(
              width: double.infinity,
              height: 250,
              decoration: const BoxDecoration(
                color: AppTheme.lightGray,
              ),
              child: Image.network(
                _livestreamData['thumbnailUrl'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.lightGray,
                    child: const Icon(
                      Icons.live_tv,
                      size: 64,
                      color: AppTheme.primaryPurple,
                    ),
                  );
                },
              ),
            ),
            
            // Gradient Overlay
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            
            // Live Indicator
            Positioned(
              top: AppTheme.spacingM,
              left: AppTheme.spacingM,
              child: AnimatedBuilder(
                animation: _livestreamPulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _livestreamPulseAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                        vertical: AppTheme.spacingS,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.errorRed,
                        borderRadius: BorderRadius.circular(AppTheme.radiusL),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.backgroundWhite,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          const Text(
                            'LIVE',
                            style: TextStyle(
                              color: AppTheme.backgroundWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Viewer Count
            Positioned(
              top: AppTheme.spacingM,
              right: AppTheme.spacingM,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingS,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(AppTheme.radiusL),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.visibility,
                      color: AppTheme.backgroundWhite,
                      size: 16,
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    Text(
                      _livestreamData['viewerCount'],
                      style: const TextStyle(
                        color: AppTheme.backgroundWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Content Info
            Positioned(
              bottom: AppTheme.spacingM,
              left: AppTheme.spacingM,
              right: AppTheme.spacingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _livestreamData['title'],
                    style: AppTheme.headingMedium.copyWith(
                      color: AppTheme.backgroundWhite,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Row(
                    children: [
                      Text(
                        _livestreamData['channelName'],
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.backgroundWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingS,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple,
                          borderRadius: BorderRadius.circular(AppTheme.radiusS),
                        ),
                        child: Text(
                          _livestreamData['category'],
                          style: const TextStyle(
                            color: AppTheme.backgroundWhite,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
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
                    icon: category == 'Live' ? Icons.live_tv : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Videos',
                style: AppTheme.headingMedium.copyWith(
                  color: AppTheme.textDark,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to featured videos
                },
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          ..._featuredVideos.map((video) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
              child: VideoCard(
                thumbnailUrl: video['thumbnailUrl'],
                title: video['title'],
                channelName: video['channelName'],
                duration: video['duration'],
                views: video['views'],
                uploadTime: video['uploadTime'],
                onTap: () {
                  // Navigate to video player
                },
                onChannelTap: () {
                  // Navigate to channel
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildProgramsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Programs',
                style: AppTheme.headingMedium.copyWith(
                  color: AppTheme.textDark,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all programs
                },
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _programs.length,
              itemBuilder: (context, index) {
                final program = _programs[index];
                return ProgramCard(
                  imageUrl: program['imageUrl'],
                  title: program['title'],
                  description: program['description'],
                  videoCount: program['videoCount'],
                  onTap: () {
                    // Navigate to program detail
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
