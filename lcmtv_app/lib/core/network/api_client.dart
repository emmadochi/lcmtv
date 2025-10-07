import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../config/app_config.dart';
import 'api_interceptors.dart';

class ApiClient {
  late final Dio _dio;
  final Connectivity _connectivity;

  ApiClient({Connectivity? connectivity}) 
      : _connectivity = connectivity ?? Connectivity() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.youtubeBaseUrl,
      connectTimeout: AppConfig.requestTimeout,
      receiveTimeout: AppConfig.requestTimeout,
      sendTimeout: AppConfig.requestTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.addAll([
      AuthInterceptor(apiKey: AppConfig.youtubeApiKey),
      ConnectivityInterceptor(_connectivity),
      LoggingInterceptor(),
      RetryInterceptor(),
      QuotaInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  // Update API key
  void updateApiKey(String apiKey) {
    _dio.interceptors.removeWhere((interceptor) => interceptor is AuthInterceptor);
    _dio.interceptors.insert(0, AuthInterceptor(apiKey: apiKey));
  }

  // Get current quota status
  Map<String, dynamic> getQuotaStatus() {
    return {
      'currentQuota': QuotaInterceptor.currentQuota,
      'quotaLimit': QuotaInterceptor.quotaLimit,
      'quotaPercentage': QuotaInterceptor.quotaPercentage,
      'remainingQuota': QuotaInterceptor.quotaLimit - QuotaInterceptor.currentQuota,
    };
  }

  // Reset quota (for testing or daily reset)
  void resetQuota() {
    QuotaInterceptor.resetQuota();
  }

  // Check if quota is available
  bool get hasQuotaAvailable {
    return QuotaInterceptor.currentQuota < QuotaInterceptor.quotaLimit;
  }

  // Get remaining quota
  int get remainingQuota {
    return QuotaInterceptor.quotaLimit - QuotaInterceptor.currentQuota;
  }
}
