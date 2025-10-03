import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/video_card.dart';
import '../../../../shared/widgets/logo_widget.dart';

class LikedVideosScreen extends StatefulWidget {
  const LikedVideosScreen({super.key});

  @override
  State<LikedVideosScreen> createState() => _LikedVideosScreenState();
}

class _LikedVideosScreenState extends State<LikedVideosScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String _selectedFilter = 'All';
  
  final List<String> _filters = ['All', 'Recently Liked', 'Most Liked', 'Playlists'];
  
  // Sample liked videos data
  final List<Map<String, dynamic>> _likedVideos = [
    {
      'thumbnailUrl': 'https://via.placeholder.com/400x225/6B46C1/FFFFFF?text=Liked+1',
      'title': 'Amazing Flutter Tutorial That Changed Everything',
      'channelName': 'Flutter Masters',
      'duration': '2:30:45',
      'views': '125K',
      'uploadTime': '1 day ago',
      'likedDate': DateTime.now().subtract(const Duration(hours: 2)),
      'category': 'Education',
      'isLiked': true,
    },
    {
      'thumbnailUrl': 'https://via.placeholder.com/400x225/8B5CF6/FFFFFF?text=Liked+2',
      'title': 'Building Modern Mobile Apps - Complete Guide',
      'channelName': 'Mobile Dev Hub',
      'duration': '1:45:20',
      'views': '89K',
      'uploadTime': '3 days ago',
      'likedDate': DateTime.now().subtract(const Duration(hours: 5)),
      'category': 'Technology',
      'isLiked': true,
    },
    {
      'thumbnailUrl': 'https://via.placeholder.com/400x225/A78BFA/FFFFFF?text=Liked+3',
      'title': 'UI/UX Design Masterclass - From Beginner to Pro',
      'channelName': 'Design Studio',
      'duration': '3:15:30',
      'views': '156K',
      'uploadTime': '1 week ago',
      'likedDate': DateTime.now().subtract(const Duration(days: 1)),
      'category': 'Design',
      'isLiked': true,
    },
    {
      'thumbnailUrl': 'https://via.placeholder.com/400x225/6B46C1/FFFFFF?text=Liked+4',
      'title': 'JavaScript Fundamentals - Deep Dive',
      'channelName': 'Code Academy',
      'duration': '1:20:15',
      'views': '234K',
      'uploadTime': '2 days ago',
      'likedDate': DateTime.now().subtract(const Duration(days: 2)),
      'category': 'Programming',
      'isLiked': true,
    },
    {
      'thumbnailUrl': 'https://via.placeholder.com/400x225/8B5CF6/FFFFFF?text=Liked+5',
      'title': 'React Native Tutorial - Build Real Apps',
      'channelName': 'React Pro',
      'duration': '2:10:45',
      'views': '178K',
      'uploadTime': '4 days ago',
      'likedDate': DateTime.now().subtract(const Duration(days: 3)),
      'category': 'Mobile Development',
      'isLiked': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filters.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Filter Tabs
          _buildFilterTabs(),
          
          // Content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
                    ),
                  )
                : _buildContent(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.backgroundWhite,
      elevation: 0,
      title: const Text(
        'Liked Videos',
        style: TextStyle(
          color: AppTheme.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppTheme.textDark),
          onPressed: () {
            // Navigate to search
          },
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            _handleMenuAction(value);
          },
          icon: const Icon(Icons.more_vert, color: AppTheme.textDark),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'create_playlist',
              child: Row(
                children: [
                  Icon(Icons.playlist_add, size: 20),
                  SizedBox(width: 8),
                  Text('Create Playlist'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'sort_by',
              child: Row(
                children: [
                  Icon(Icons.sort, size: 20),
                  SizedBox(width: 8),
                  Text('Sort By'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'export_likes',
              child: Row(
                children: [
                  Icon(Icons.download, size: 20),
                  SizedBox(width: 8),
                  Text('Export Liked Videos'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      color: AppTheme.backgroundWhite,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: AppTheme.primaryPurple,
        unselectedLabelColor: AppTheme.textLight,
        indicatorColor: AppTheme.primaryPurple,
        indicatorWeight: 3,
        tabs: _filters.map((filter) {
          return Tab(
            child: Text(
              filter,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          );
        }).toList(),
        onTap: (index) {
          setState(() {
            _selectedFilter = _filters[index];
          });
        },
      ),
    );
  }

  Widget _buildContent() {
    final filteredVideos = _getFilteredVideos();
    
    if (filteredVideos.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppTheme.primaryPurple,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        itemCount: filteredVideos.length,
        itemBuilder: (context, index) {
          final video = filteredVideos[index];
          return _buildLikedVideoCard(video);
        },
      ),
    );
  }

  Widget _buildLikedVideoCard(Map<String, dynamic> video) {
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
                // Thumbnail with like indicator
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      child: Image.network(
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
                    ),
                    // Like indicator
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.errorRed,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: AppTheme.backgroundWhite,
                          size: 12,
                        ),
                      ),
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
                            Icons.favorite,
                            size: 14,
                            color: AppTheme.errorRed,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Liked ${_formatLikedDate(video['likedDate'])}',
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
                            '${video['views']} views',
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
                    _handleVideoMenuAction(value, video);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'unlike',
                      child: Row(
                        children: [
                          Icon(Icons.favorite_border, size: 20),
                          SizedBox(width: 8),
                          Text('Unlike'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'add_to_playlist',
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
                    const PopupMenuItem(
                      value: 'download',
                      child: Row(
                        children: [
                          Icon(Icons.download, size: 20),
                          SizedBox(width: 8),
                          Text('Download'),
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

  Widget _buildEmptyState() {
    return Center(
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
              Icons.favorite_border,
              size: 64,
              color: AppTheme.textLight,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          Text(
            'No liked videos yet',
            style: AppTheme.headingMedium.copyWith(
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Videos you like will appear here',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingL),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to home or trending
            },
            icon: const Icon(Icons.explore),
            label: const Text('Explore Videos'),
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

  List<Map<String, dynamic>> _getFilteredVideos() {
    if (_selectedFilter == 'All') {
      return _likedVideos;
    }
    
    switch (_selectedFilter) {
      case 'Recently Liked':
        return _likedVideos.take(3).toList();
      case 'Most Liked':
        return _likedVideos.take(5).toList();
      case 'Playlists':
        return []; // Empty for now
      default:
        return _likedVideos;
    }
  }

  String _formatLikedDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return 'just now';
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'create_playlist':
        _createPlaylist();
        break;
      case 'sort_by':
        _showSortOptions();
        break;
      case 'export_likes':
        _exportLikes();
        break;
    }
  }

  void _handleVideoMenuAction(String action, Map<String, dynamic> video) {
    switch (action) {
      case 'unlike':
        _unlikeVideo(video);
        break;
      case 'add_to_playlist':
        _addToPlaylist(video);
        break;
      case 'share':
        _shareVideo(video);
        break;
      case 'download':
        _downloadVideo(video);
        break;
    }
  }

  void _createPlaylist() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Playlist'),
        content: const TextField(
          decoration: InputDecoration(
            labelText: 'Playlist Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Playlist created successfully!'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showSortOptions() {
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
              'Sort Liked Videos',
              style: AppTheme.headingMedium.copyWith(
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            // Add sort options here
            const Text('Sort options will be implemented here'),
          ],
        ),
      ),
    );
  }

  void _exportLikes() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Liked videos exported successfully!'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _unlikeVideo(Map<String, dynamic> video) {
    setState(() {
      // _likedVideos.remove(video);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from liked videos'),
        backgroundColor: AppTheme.primaryPurple,
      ),
    );
  }

  void _addToPlaylist(Map<String, dynamic> video) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to playlist'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _shareVideo(Map<String, dynamic> video) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Video shared'),
        backgroundColor: AppTheme.primaryPurple,
      ),
    );
  }

  void _downloadVideo(Map<String, dynamic> video) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Download started'),
        backgroundColor: AppTheme.primaryPurple,
      ),
    );
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
      });
    }
  }
}
