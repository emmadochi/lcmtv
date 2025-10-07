class AppConfig {
  // Environment variables
  static const String _apiKey = String.fromEnvironment('YOUTUBE_API_KEY');
  static const String _firebaseProjectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const bool _isProduction = bool.fromEnvironment('PRODUCTION');
  
  // API Configuration
  static String get youtubeApiKey => _apiKey.isNotEmpty ? _apiKey : 'YOUR_YOUTUBE_API_KEY';
  static String get firebaseProjectId => _firebaseProjectId.isNotEmpty ? _firebaseProjectId : 'LCTV';
  static bool get isProduction => _isProduction;
  
  // YouTube API Configuration
  static const String youtubeBaseUrl = 'https://www.googleapis.com/youtube/v3';
  static const int maxResultsPerRequest = 50;
  static const int quotaLimit = 10000;
  
  // Cache Configuration
  static const Duration cacheExpiry = Duration(hours: 6);
  static const Duration trendingCacheExpiry = Duration(hours: 1);
  static const Duration liveStreamsCacheExpiry = Duration(minutes: 15);
  
  // Firebase Configuration
  static const String firebaseRegion = 'us-central1';
  static const Duration firebaseTimeout = Duration(seconds: 30);
  
  // Performance Configuration
  static const int maxConcurrentRequests = 5;
  static const Duration requestTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;
  
  // Security Configuration
  static const String encryptionKey = 'lcmtv_encryption_key_2024';
  static const bool enableApiKeyEncryption = true;
  
  // Analytics Configuration
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const Duration analyticsBatchInterval = Duration(minutes: 5);
  
  // Video Configuration
  static const List<String> supportedVideoFormats = ['mp4', 'webm', '3gp'];
  static const int maxVideoDuration = 3600; // 1 hour in seconds
  static const int minVideoDuration = 1; // 1 second
  
  // Trending Configuration
  static const int trendingVideosLimit = 25;
  static const int liveStreamsLimit = 10;
  static const Duration trendingUpdateInterval = Duration(hours: 6);
  static const Duration liveStreamsUpdateInterval = Duration(minutes: 15);
  
  // Search Configuration
  static const int searchResultsLimit = 25;
  static const List<String> searchOrderOptions = [
    'relevance',
    'date',
    'rating',
    'viewCount',
    'title'
  ];
  
  // UI Configuration
  static const int gridColumns = 2;
  static const int listItemsPerPage = 20;
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  // Error Handling Configuration
  static const bool enableErrorReporting = true;
  static const Duration errorRetryDelay = Duration(seconds: 2);
  static const int maxErrorRetries = 3;
  
  // Development Configuration
  static bool get enableDebugLogging => !isProduction;
  static const bool enablePerformanceMonitoring = true;
  static bool get enableNetworkLogging => !isProduction;
  
  // Validation
  static bool get isConfigured => 
      youtubeApiKey.isNotEmpty && 
      youtubeApiKey != 'YOUR_YOUTUBE_API_KEY';
  
  // Get API endpoint URLs
  static String get trendingVideosUrl => '$youtubeBaseUrl/videos';
  static String get searchVideosUrl => '$youtubeBaseUrl/search';
  static String get videoDetailsUrl => '$youtubeBaseUrl/videos';
  static String get categoriesUrl => '$youtubeBaseUrl/videoCategories';
  
  // Get Firebase collection paths
  static String get usersCollection => 'users';
  static String get videosCollection => 'videos';
  static String get categoriesCollection => 'categories';
  static String get trendingCollection => 'trending';
  static String get liveStreamsCollection => 'liveStreams';
  static String get analyticsCollection => 'analytics';
  
  // Get cache keys
  static String get trendingCacheKey => 'trending_videos';
  static String get categoriesCacheKey => 'video_categories';
  static String get liveStreamsCacheKey => 'live_streams';
  static String get searchCacheKey => 'search_results';
  
  // Get user preferences keys
  static String get userPreferencesKey => 'user_preferences';
  static String get watchHistoryKey => 'watch_history';
  static String get likedVideosKey => 'liked_videos';
  static String get playlistsKey => 'playlists';
}
