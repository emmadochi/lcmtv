import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/video_card.dart';
import '../../../../shared/widgets/logo_widget.dart';

class WatchHistoryScreen extends StatefulWidget {
  const WatchHistoryScreen({super.key});

  @override
  State<WatchHistoryScreen> createState() => _WatchHistoryScreenState();
}

class _WatchHistoryScreenState extends State<WatchHistoryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String _selectedFilter = 'All';
  
  final List<String> _filters = ['All', 'Today', 'This Week', 'This Month'];
  
  // Sample watch history data
  final List<Map<String, dynamic>> _watchHistory = [
    {
      'thumbnailUrl': 'https://via.placeholder.com/400x225/6B46C1/FFFFFF?text=Video+1',
      'title': 'Complete Flutter Development Course',
      'channelName': 'Flutter Masters',
      'duration': '2:30:45',
      'views': '125K',
      'uploadTime': '1 day ago',
      'watchTime': '2:15:30',
      'watchDate': DateTime.now().subtract(const Duration(hours: 2)),
      'category': 'Education',
    },
    {
      'thumbnailUrl': 'https://via.placeholder.com/400x225/8B5CF6/FFFFFF?text=Video+2',
      'title': 'Building Modern Mobile Apps',
      'channelName': 'Mobile Dev Hub',
      'duration': '1:45:20',
      'views': '89K',
      'uploadTime': '3 days ago',
      'watchTime': '1:30:15',
      'watchDate': DateTime.now().subtract(const Duration(hours: 5)),
      'category': 'Technology',
    },
    {
      'thumbnailUrl': 'https://via.placeholder.com/400x225/A78BFA/FFFFFF?text=Video+3',
      'title': 'UI/UX Design Masterclass',
      'channelName': 'Design Studio',
      'duration': '3:15:30',
      'views': '156K',
      'uploadTime': '1 week ago',
      'watchTime': '2:45:20',
      'watchDate': DateTime.now().subtract(const Duration(days: 1)),
      'category': 'Design',
    },
    {
      'thumbnailUrl': 'https://via.placeholder.com/400x225/6B46C1/FFFFFF?text=Video+4',
      'title': 'JavaScript Fundamentals',
      'channelName': 'Code Academy',
      'duration': '1:20:15',
      'views': '234K',
      'uploadTime': '2 days ago',
      'watchTime': '1:20:15',
      'watchDate': DateTime.now().subtract(const Duration(days: 2)),
      'category': 'Programming',
    },
    {
      'thumbnailUrl': 'https://via.placeholder.com/400x225/8B5CF6/FFFFFF?text=Video+5',
      'title': 'React Native Tutorial',
      'channelName': 'React Pro',
      'duration': '2:10:45',
      'views': '178K',
      'uploadTime': '4 days ago',
      'watchTime': '1:45:30',
      'watchDate': DateTime.now().subtract(const Duration(days: 3)),
      'category': 'Mobile Development',
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
        'Watch History',
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
              value: 'clear_history',
              child: Row(
                children: [
                  Icon(Icons.clear_all, size: 20),
                  SizedBox(width: 8),
                  Text('Clear All History'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'pause_history',
              child: Row(
                children: [
                  Icon(Icons.pause, size: 20),
                  SizedBox(width: 8),
                  Text('Pause History'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'export_history',
              child: Row(
                children: [
                  Icon(Icons.download, size: 20),
                  SizedBox(width: 8),
                  Text('Export History'),
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
    final filteredHistory = _getFilteredHistory();
    
    if (filteredHistory.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppTheme.primaryPurple,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        itemCount: filteredHistory.length,
        itemBuilder: (context, index) {
          final video = filteredHistory[index];
          return _buildHistoryCard(video);
        },
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> video) {
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
                // Thumbnail with watch progress
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
                    // Watch progress bar
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(AppTheme.radiusM),
                            bottomRight: Radius.circular(AppTheme.radiusM),
                          ),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.8, // 80% watched
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.primaryPurple,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(AppTheme.radiusM),
                                bottomRight: Radius.circular(AppTheme.radiusM),
                              ),
                            ),
                          ),
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
                            Icons.watch_later,
                            size: 14,
                            color: AppTheme.textLight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Watched ${video['watchTime']}',
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
                            _formatWatchDate(video['watchDate']),
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
                      value: 'remove',
                      child: Row(
                        children: [
                          Icon(Icons.remove_circle_outline, size: 20),
                          SizedBox(width: 8),
                          Text('Remove from History'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'watch_again',
                      child: Row(
                        children: [
                          Icon(Icons.replay, size: 20),
                          SizedBox(width: 8),
                          Text('Watch Again'),
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
              Icons.history,
              size: 64,
              color: AppTheme.textLight,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          Text(
            'No watch history',
            style: AppTheme.headingMedium.copyWith(
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Videos you watch will appear here',
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

  List<Map<String, dynamic>> _getFilteredHistory() {
    if (_selectedFilter == 'All') {
      return _watchHistory;
    }
    
    final now = DateTime.now();
    DateTime filterDate;
    
    switch (_selectedFilter) {
      case 'Today':
        filterDate = DateTime(now.year, now.month, now.day);
        break;
      case 'This Week':
        filterDate = now.subtract(const Duration(days: 7));
        break;
      case 'This Month':
        filterDate = DateTime(now.year, now.month, 1);
        break;
      default:
        return _watchHistory;
    }
    
    return _watchHistory.where((video) {
      final watchDate = video['watchDate'] as DateTime;
      return watchDate.isAfter(filterDate);
    }).toList();
  }

  String _formatWatchDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'clear_history':
        _showClearHistoryDialog();
        break;
      case 'pause_history':
        _pauseHistory();
        break;
      case 'export_history':
        _exportHistory();
        break;
    }
  }

  void _handleVideoMenuAction(String action, Map<String, dynamic> video) {
    switch (action) {
      case 'remove':
        _removeFromHistory(video);
        break;
      case 'watch_again':
        // Navigate to video player
        break;
      case 'add_to_playlist':
        // Add to playlist
        break;
    }
  }

  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Watch History'),
        content: const Text('Are you sure you want to clear all your watch history? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Clear history
              setState(() {
                // _watchHistory.clear();
              });
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppTheme.errorRed),
            ),
          ),
        ],
      ),
    );
  }

  void _pauseHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Watch history paused'),
        backgroundColor: AppTheme.primaryPurple,
      ),
    );
  }

  void _exportHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Watch history exported'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _removeFromHistory(Map<String, dynamic> video) {
    setState(() {
      // _watchHistory.remove(video);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from history'),
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
