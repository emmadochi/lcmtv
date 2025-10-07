import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../config/app_config.dart';

class AuthInterceptor extends Interceptor {
  final String? _apiKey;

  AuthInterceptor({String? apiKey}) : _apiKey = apiKey;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_apiKey != null && _apiKey!.isNotEmpty) {
      options.queryParameters['key'] = _apiKey!;
    }
    super.onRequest(options, handler);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('🚀 REQUEST[${options.method}] => PATH: ${options.path}');
    print('Query Parameters: ${options.queryParameters}');
    if (options.data != null) {
      print('Request Data: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print('Response Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    print('Error Message: ${err.message}');
    if (err.response?.data != null) {
      print('Error Data: ${err.response?.data}');
    }
    super.onError(err, handler);
  }
}

class ConnectivityInterceptor extends Interceptor {
  final Connectivity _connectivity;

  ConnectivityInterceptor(this._connectivity);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      handler.reject(DioException(
        requestOptions: options,
        error: 'No internet connection',
        type: DioExceptionType.connectionError,
      ));
      return;
    }
    super.onRequest(options, handler);
  }
}

class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    this.maxRetries = AppConfig.maxRetryAttempts,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] ?? 0;
      
      if (retryCount < maxRetries) {
        err.requestOptions.extra['retryCount'] = retryCount + 1;
        
        await Future.delayed(retryDelay * (retryCount + 1));
        
        try {
          final response = await Dio().fetch(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (e) {
          // Continue to retry or fail
        }
      }
    }
    
    super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           err.type == DioExceptionType.connectionError ||
           (err.response?.statusCode != null && 
            err.response!.statusCode! >= 500);
  }
}

class QuotaInterceptor extends Interceptor {
  static int _currentQuota = 0;
  static const int _quotaLimit = AppConfig.quotaLimit;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_currentQuota >= _quotaLimit) {
      handler.reject(DioException(
        requestOptions: options,
        error: 'API quota exceeded',
        type: DioExceptionType.cancel,
      ));
      return;
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _updateQuotaUsage(response.requestOptions);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _updateQuotaUsage(err.requestOptions);
    super.onError(err, handler);
  }

  void _updateQuotaUsage(RequestOptions options) {
    // Estimate quota usage based on endpoint
    final path = options.path;
    if (path.contains('/videos') && path.contains('list')) {
      _currentQuota += 1; // videos.list costs 1 unit
    } else if (path.contains('/search')) {
      _currentQuota += 100; // search.list costs 100 units
    } else if (path.contains('/videoCategories')) {
      _currentQuota += 1; // videoCategories.list costs 1 unit
    }
  }

  static int get currentQuota => _currentQuota;
  static int get quotaLimit => _quotaLimit;
  static double get quotaPercentage => (_currentQuota / _quotaLimit) * 100;
  
  static void resetQuota() {
    _currentQuota = 0;
  }
}
