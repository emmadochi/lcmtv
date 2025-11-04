class AppConfig {
  // ============================================================================
  // API CONFIGURATION
  // ============================================================================
  
  static const String youtubeApiKey = 'AIzaSyBuX9TPzImZ2G3MqXHd__CGVQu9__15lTw';
  static const String youtubeBaseUrl = 'https://www.googleapis.com/youtube/v3';
  
  // ============================================================================
  // FIREBASE CONFIGURATION
  // ============================================================================
  
  static const String firebaseProjectId = 'lctv-dea2d';
  static const String firebaseStorageBucket = 'lctv-dea2d.firebasestorage.app';
  
  // ============================================================================
  // APP CONFIGURATION
  // ============================================================================
  
  static const String appName = 'LCMTV';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  
  // ============================================================================
  // FEATURE FLAGS
  // ============================================================================
  
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enableOfflineMode = true;
  static const bool enablePushNotifications = true;
  static const bool enableLiveStreaming = true;
  static const bool enableUserGeneratedContent = false;
  
  // ============================================================================
  // CACHE CONFIGURATION
  // ============================================================================
  
  static const Duration searchCacheExpiry = Duration(hours: 1);
  static const Duration trendingCacheExpiry = Duration(minutes: 30);
  static const Duration liveStreamCacheExpiry = Duration(minutes: 5);
  static const Duration videoCacheExpiry = Duration(hours: 24);
  static const Duration categoryCacheExpiry = Duration(days: 7);
  
  // ============================================================================
  // PAGINATION CONFIGURATION
  // ============================================================================
  
  static const int defaultPageSize = 25;
  static const int maxPageSize = 50;
  static const int trendingPageSize = 20;
  static const int liveStreamPageSize = 10;
  static const int searchPageSize = 25;
  
  // ============================================================================
  // VIDEO CONFIGURATION
  // ============================================================================
  
  static const String defaultVideoQuality = 'auto';
  static const List<String> supportedVideoQualities = [
    'auto',
    '144p',
    '240p',
    '360p',
    '480p',
    '720p',
    '1080p',
  ];
  
  static const Duration maxVideoDuration = Duration(hours: 10);
  static const Duration minVideoDuration = Duration(seconds: 1);
  
  // ============================================================================
  // ANALYTICS CONFIGURATION
  // ============================================================================
  
  static const Duration analyticsBatchInterval = Duration(minutes: 5);
  static const int maxAnalyticsEventsPerBatch = 100;
  static const Duration sessionTimeout = Duration(minutes: 30);
  
  // ============================================================================
  // SECURITY CONFIGURATION
  // ============================================================================
  
  static const Duration tokenExpiry = Duration(hours: 24);
  static const int maxLoginAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);
  
  // ============================================================================
  // PERFORMANCE CONFIGURATION
  // ============================================================================
  
  static const int maxConcurrentRequests = 5;
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration retryDelay = Duration(seconds: 2);
  static const int maxRetryAttempts = 3;
  
  // ============================================================================
  // UI CONFIGURATION
  // ============================================================================
  
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashScreenDuration = Duration(seconds: 3);
  static const Duration toastDuration = Duration(seconds: 3);
  
  // ============================================================================
  // ENVIRONMENT CONFIGURATION
  // ============================================================================
  
  static const String environment = 'development'; // development, staging, production
  
  static bool get isDevelopment => environment == 'development';
  static bool get isStaging => environment == 'staging';
  static bool get isProduction => environment == 'production';
  
  // ============================================================================
  // DEBUG CONFIGURATION
  // ============================================================================
  
  static const bool enableDebugLogs = true;
  static const bool enablePerformanceLogs = true;
  static const bool enableNetworkLogs = true;
  static const bool enableAnalyticsLogs = true;

  // Firestore test-data seeding (for developers only)
  static const bool seedFirestoreOnStartup = false;
  
  // ============================================================================
  // VALIDATION METHODS
  // ============================================================================
  
  static bool isValidApiKey(String apiKey) {
    return apiKey.isNotEmpty && apiKey != 'YOUR_YOUTUBE_API_KEY_HERE';
  }
  
  static bool isValidVideoId(String videoId) {
    return videoId.isNotEmpty && videoId.length >= 11;
  }
  
  static bool isValidSearchQuery(String query) {
    return query.isNotEmpty && query.length >= 2;
  }
  
  // ============================================================================
  // CONFIGURATION GETTERS
  // ============================================================================
  
  static Map<String, dynamic> get allConfig => {
    'appName': appName,
    'appVersion': appVersion,
    'appBuildNumber': appBuildNumber,
    'environment': environment,
    'enableAnalytics': enableAnalytics,
    'enableCrashReporting': enableCrashReporting,
    'enableOfflineMode': enableOfflineMode,
    'enablePushNotifications': enablePushNotifications,
    'enableLiveStreaming': enableLiveStreaming,
    'enableUserGeneratedContent': enableUserGeneratedContent,
    'defaultPageSize': defaultPageSize,
    'maxPageSize': maxPageSize,
    'defaultVideoQuality': defaultVideoQuality,
    'maxConcurrentRequests': maxConcurrentRequests,
    'requestTimeout': requestTimeout.inSeconds,
    'maxRetryAttempts': maxRetryAttempts,
  };
}