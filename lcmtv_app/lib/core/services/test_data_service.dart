import 'dart:async';
import 'dart:math';
import '../../core/models/video_metadata_model.dart';

class TestDataService {
  static final TestDataService _instance = TestDataService._internal();
  factory TestDataService() => _instance;
  TestDataService._internal();

  final List<VideoMetadata> _trendingVideos = [];
  final List<VideoMetadata> _liveStreams = [];
  final List<VideoMetadata> _featuredVideos = [];
  
  Timer? _updateTimer;
  final Random _random = Random();
  
  // Sample video data
  final List<Map<String, dynamic>> _sampleVideos = [
    {
      'title': 'Amazing Tech Review - Latest iPhone Features',
      'channel': 'TechReviewer',
      'views': 1250000,
      'duration': Duration(minutes: 12, seconds: 34),
      'thumbnail': 'https://picsum.photos/320/180?random=1',
      'category': 'Technology',
    },
    {
      'title': 'Cooking Masterclass - Italian Pasta Secrets',
      'channel': 'ChefMaster',
      'views': 890000,
      'duration': Duration(minutes: 18, seconds: 45),
      'thumbnail': 'https://picsum.photos/320/180?random=2',
      'category': 'Food',
    },
    {
      'title': 'Gaming Highlights - Epic Battle Royale',
      'channel': 'GamePro',
      'views': 2100000,
      'duration': Duration(minutes: 8, seconds: 12),
      'thumbnail': 'https://picsum.photos/320/180?random=3',
      'category': 'Gaming',
    },
    {
      'title': 'Fitness Workout - 30 Minute HIIT Session',
      'channel': 'FitLife',
      'views': 650000,
      'duration': Duration(minutes: 30, seconds: 0),
      'thumbnail': 'https://picsum.photos/320/180?random=4',
      'category': 'Fitness',
    },
    {
      'title': 'Music Production Tutorial - Beat Making',
      'channel': 'MusicMaker',
      'views': 420000,
      'duration': Duration(minutes: 25, seconds: 30),
      'thumbnail': 'https://picsum.photos/320/180?random=5',
      'category': 'Music',
    },
    {
      'title': 'Travel Vlog - Exploring Tokyo Streets',
      'channel': 'Wanderlust',
      'views': 1800000,
      'duration': Duration(minutes: 15, seconds: 20),
      'thumbnail': 'https://picsum.photos/320/180?random=6',
      'category': 'Travel',
    },
    {
      'title': 'Educational Content - Space Exploration',
      'channel': 'ScienceChannel',
      'views': 950000,
      'duration': Duration(minutes: 22, seconds: 15),
      'thumbnail': 'https://picsum.photos/320/180?random=7',
      'category': 'Education',
    },
    {
      'title': 'Comedy Skit - Office Life Parody',
      'channel': 'ComedyCentral',
      'views': 3200000,
      'duration': Duration(minutes: 6, seconds: 45),
      'thumbnail': 'https://picsum.photos/320/180?random=8',
      'category': 'Entertainment',
    },
  ];

  // Sample YouTube IDs for reliable playback
  final List<String> _sampleYouTubeIds = const [
    'dQw4w9WgXcQ', // music
    'M7lc1UVf-VE', // YouTube API demo
    'jNQXAC9IVRw', // Me at the zoo
    'kXYiU_JCYtU', // music
    '9bZkp7q19f0', // music
    'e-ORhEE9VVg', // music
    '3JZ_D3ELwOQ', // music
    'oHg5SJYRHA0', // alt
  ];

  // Public 24/7 live streams (may change over time)
  final List<String> _sampleLiveYouTubeIds = const [
    '21X5lGlDOfg', // NASA Live
    '5qap5aO4i9A', // Lofi live (often running)
  ];

  void startRealTimeUpdates() {
    _generateInitialData();
    
    // Update data every 30 seconds to simulate real-time updates
    _updateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _updateData();
    });
  }

  void stopRealTimeUpdates() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }

  void _generateInitialData() {
    _trendingVideos.clear();
    _liveStreams.clear();
    _featuredVideos.clear();

    // Generate trending videos
    for (int i = 0; i < 8; i++) {
      final videoData = _sampleVideos[i];
      _trendingVideos.add(_createVideoMetadata(
        id: 'trending_$i',
        data: videoData,
        isLive: false,
      ));
    }

    // Generate live streams
    for (int i = 0; i < 3; i++) {
      final videoData = _sampleVideos[i + 2];
      _liveStreams.add(_createVideoMetadata(
        id: 'live_$i',
        data: videoData,
        isLive: true,
      ));
    }

    // Generate featured videos
    for (int i = 0; i < 5; i++) {
      final videoData = _sampleVideos[i + 3];
      _featuredVideos.add(_createVideoMetadata(
        id: 'featured_$i',
        data: videoData,
        isLive: false,
      ));
    }
  }

  void _updateData() {
    print('🔄 Updating real-time data...');
    
    // Simulate view count updates
    for (final video in _trendingVideos) {
      final newViews = video.viewCount + _random.nextInt(1000) + 100;
      // Update view count (this would be done through a copyWith method)
    }
    
    // Simulate new videos being added occasionally
    if (_random.nextDouble() < 0.3) { // 30% chance
      final newVideoData = _sampleVideos[_random.nextInt(_sampleVideos.length)];
      final newVideo = _createVideoMetadata(
        id: 'new_${DateTime.now().millisecondsSinceEpoch}',
        data: newVideoData,
        isLive: false,
      );
      _trendingVideos.insert(0, newVideo);
      if (_trendingVideos.length > 10) {
        _trendingVideos.removeLast();
      }
    }
    
    print('✅ Real-time data updated');
  }

  VideoMetadata _createVideoMetadata({
    required String id,
    required Map<String, dynamic> data,
    required bool isLive,
  }) {
    // Map our synthetic IDs to real YouTube IDs so the player can load
    final mappedId = isLive
        ? _sampleLiveYouTubeIds[(_random.nextInt(_sampleLiveYouTubeIds.length))]
        : _sampleYouTubeIds[int.parse(RegExp(r'_(\d+)$').firstMatch(id)?.group(1) ?? '0') % _sampleYouTubeIds.length];

    return VideoMetadata(
      id: mappedId,
      title: data['title'] as String,
      description: 'This is a sample video description for ${data['title']}.',
      channelId: 'channel_${id}',
      channelTitle: data['channel'] as String,
      thumbnailUrl: data['thumbnail'] as String,
      publishedAt: DateTime.now().subtract(Duration(days: _random.nextInt(30))).toIso8601String(),
      duration: data['duration'] as Duration,
      categoryId: '${_random.nextInt(20) + 1}',
      categoryTitle: data['category'] as String,
      tags: ['sample', 'test', 'demo', data['category'].toString().toLowerCase()],
      isLive: isLive,
      viewCount: data['views'] as int,
    );
  }

  // Getters for current data
  List<VideoMetadata> get trendingVideos => List.unmodifiable(_trendingVideos);
  List<VideoMetadata> get liveStreams => List.unmodifiable(_liveStreams);
  List<VideoMetadata> get featuredVideos => List.unmodifiable(_featuredVideos);

  // Simulate search functionality
  List<VideoMetadata> searchVideos(String query) {
    final allVideos = [..._trendingVideos, ..._featuredVideos];
    return allVideos.where((video) => 
      video.title.toLowerCase().contains(query.toLowerCase()) ||
      video.channelTitle.toLowerCase().contains(query.toLowerCase()) ||
      video.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()))
    ).toList();
  }

  // Simulate category filtering
  List<VideoMetadata> getVideosByCategory(String category) {
    return _trendingVideos.where((video) => 
      video.categoryTitle.toLowerCase() == category.toLowerCase()
    ).toList();
  }

  // Simulate getting related videos
  List<VideoMetadata> getRelatedVideos(String videoId) {
    final allVideos = [..._trendingVideos, ..._featuredVideos];
    return allVideos.where((video) => video.id != videoId).take(5).toList();
  }
}
