import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/video_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  bool _isSearching = false;
  String _selectedFilter = 'All';
  String _selectedSort = 'Relevance';

  final List<String> _filters = ['All', 'Videos', 'Channels', 'Playlists'];
  final List<String> _sortOptions = ['Relevance', 'Upload Date', 'View Count', 'Rating'];

  // Sample search history
  final List<String> _searchHistory = [
    'Flutter tutorials',
    'Dart programming',
    'Mobile development',
    'UI/UX design',
  ];

  // Sample search suggestions
  final List<String> _suggestions = [
    'Flutter tutorial for beginners',
    'Dart programming language',
    'Mobile app development',
    'UI design principles',
    'UX best practices',
  ];

  // Sample search results
  final List<Map<String, dynamic>> _searchResults = [
    {
      'thumbnailUrl': 'https://via.placeholder.com/400x225/6B46C1/FFFFFF?text=Search+Result+1',
      'title': 'Flutter Tutorial for Beginners - Complete Guide',
      'channelName': 'Flutter Channel',
      'duration': '45:30',
      'views': '125K',
      'uploadTime': '1 week ago',
    },
    {
      'thumbnailUrl': 'https://via.placeholder.com/400x225/8B5CF6/FFFFFF?text=Search+Result+2',
      'title': 'Advanced Dart Programming Techniques',
      'channelName': 'Dart Masters',
      'duration': '32:15',
      'views': '89K',
      'uploadTime': '3 days ago',
    },
    {
      'thumbnailUrl': 'https://via.placeholder.com/400x225/A78BFA/FFFFFF?text=Search+Result+3',
      'title': 'Mobile App UI/UX Design Best Practices',
      'channelName': 'Design Studio',
      'duration': '28:45',
      'views': '156K',
      'uploadTime': '5 days ago',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  void _performSearch() {
    if (_searchQuery.trim().isNotEmpty) {
      setState(() {
        _isSearching = true;
      });

      // Simulate search
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isSearching = false;
          });
        }
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  void _selectFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _selectSort(String sort) {
    setState(() {
      _selectedSort = sort;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Search videos, channels, playlists...',
            border: InputBorder.none,
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  )
                : null,
          ),
          onSubmitted: (value) => _performSearch(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _performSearch,
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_searchQuery.isEmpty) {
      return _buildSearchSuggestions();
    } else if (_isSearching) {
      return _buildLoadingState();
    } else {
      return _buildSearchResults();
    }
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search History
          if (_searchHistory.isNotEmpty) ...[
            Text(
              'Recent Searches',
              style: AppTheme.headingSmall.copyWith(
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            Wrap(
              spacing: AppTheme.spacingS,
              runSpacing: AppTheme.spacingS,
              children: _searchHistory.map((query) {
                return ActionChip(
                  label: Text(query),
                  onPressed: () {
                    _searchController.text = query;
                    _performSearch();
                  },
                  backgroundColor: AppTheme.lightGray,
                  labelStyle: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textDark,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppTheme.spacingXL),
          ],

          // Search Suggestions
          Text(
            'Popular Searches',
            style: AppTheme.headingSmall.copyWith(
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          ..._suggestions.map((suggestion) {
            return ListTile(
              leading: const Icon(
                Icons.search,
                color: AppTheme.textLight,
              ),
              title: Text(
                suggestion,
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.textDark,
                ),
              ),
              onTap: () {
                _searchController.text = suggestion;
                _performSearch();
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.primaryPurple,
            ),
          ),
          SizedBox(height: AppTheme.spacingL),
          Text(
            'Searching...',
            style: AppTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Column(
      children: [
        // Filter and Sort Bar
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingM,
            vertical: AppTheme.spacingS,
          ),
          decoration: const BoxDecoration(
            color: AppTheme.lightGray,
            border: Border(
              bottom: BorderSide(
                color: AppTheme.lightGray,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Filter
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedFilter,
                    isExpanded: true,
                    items: _filters.map((filter) {
                      return DropdownMenuItem(
                        value: filter,
                        child: Text(filter),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _selectFilter(value);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              // Sort
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSort,
                    isExpanded: true,
                    items: _sortOptions.map((sort) {
                      return DropdownMenuItem(
                        value: sort,
                        child: Text(sort),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _selectSort(value);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // Search Results
        Expanded(
          child: ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final video = _searchResults[index];
              return VideoCard(
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
              );
            },
          ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet() {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            
            Text(
              'Filters',
              style: AppTheme.headingSmall.copyWith(
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            
            // Duration Filter
            Text(
              'Duration',
              style: AppTheme.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Wrap(
              spacing: AppTheme.spacingS,
              children: ['Any', 'Under 4 minutes', '4-20 minutes', 'Over 20 minutes']
                  .map((duration) {
                return FilterChip(
                  label: Text(duration),
                  selected: false,
                  onSelected: (selected) {
                    // Handle duration filter
                  },
                );
              }).toList(),
            ),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Upload Date Filter
            Text(
              'Upload Date',
              style: AppTheme.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Wrap(
              spacing: AppTheme.spacingS,
              children: ['Any time', 'Today', 'This week', 'This month', 'This year']
                  .map((date) {
                return FilterChip(
                  label: Text(date),
                  selected: false,
                  onSelected: (selected) {
                    // Handle date filter
                  },
                );
              }).toList(),
            ),
            
            const SizedBox(height: AppTheme.spacingXL),
            
            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Apply filters
                },
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
