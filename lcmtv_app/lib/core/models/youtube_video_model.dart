import 'package:json_annotation/json_annotation.dart';

part 'youtube_video_model.g.dart';

@JsonSerializable()
class YouTubeVideoModel {
  final String id;
  final String title;
  final String description;
  final String channelId;
  final String channelTitle;
  final String thumbnailUrl;
  final String publishedAt;
  final Duration duration;
  final int viewCount;
  final int likeCount;
  final int commentCount;
  final String categoryId;
  final bool isLive;
  final int? liveViewerCount;
  final List<String> tags;
  
  const YouTubeVideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.channelId,
    required this.channelTitle,
    required this.thumbnailUrl,
    required this.publishedAt,
    required this.duration,
    required this.viewCount,
    required this.likeCount,
    required this.commentCount,
    required this.categoryId,
    required this.isLive,
    this.liveViewerCount,
    required this.tags,
  });
  
  factory YouTubeVideoModel.fromJson(Map<String, dynamic> json) {
    // Parse snippet data
    final snippet = json['snippet'] ?? {};
    final statistics = json['statistics'] ?? {};
    final contentDetails = json['contentDetails'] ?? {};
    
    // Parse duration from ISO 8601 format (PT4M13S)
    final durationStr = contentDetails['duration'] ?? 'PT0S';
    final duration = _parseDuration(durationStr);
    
    // Parse published date
    final publishedAt = snippet['publishedAt'] ?? '';
    
    // Parse thumbnail URL (prefer high quality)
    final thumbnails = snippet['thumbnails'] ?? {};
    final highThumbnail = thumbnails['high'] ?? thumbnails['medium'] ?? thumbnails['default'];
    final thumbnailUrl = highThumbnail?['url'] ?? '';
    
    // Parse tags
    final tagsList = snippet['tags'] as List<dynamic>? ?? [];
    final tags = tagsList.map((tag) => tag.toString()).toList();
    
    return YouTubeVideoModel(
      id: json['id'] ?? '',
      title: snippet['title'] ?? '',
      description: snippet['description'] ?? '',
      channelId: snippet['channelId'] ?? '',
      channelTitle: snippet['channelTitle'] ?? '',
      thumbnailUrl: thumbnailUrl,
      publishedAt: publishedAt,
      duration: duration,
      viewCount: int.tryParse(statistics['viewCount']?.toString() ?? '0') ?? 0,
      likeCount: int.tryParse(statistics['likeCount']?.toString() ?? '0') ?? 0,
      commentCount: int.tryParse(statistics['commentCount']?.toString() ?? '0') ?? 0,
      categoryId: snippet['categoryId']?.toString() ?? '',
      isLive: snippet['liveBroadcastContent'] == 'live',
      liveViewerCount: statistics['concurrentViewers'] != null 
          ? int.tryParse(statistics['concurrentViewers'].toString()) 
          : null,
      tags: tags,
    );
  }
  
  Map<String, dynamic> toJson() => _$YouTubeVideoModelToJson(this);
  
  // Parse ISO 8601 duration format (PT4M13S)
  static Duration _parseDuration(String duration) {
    if (duration.isEmpty || !duration.startsWith('PT')) {
      return Duration.zero;
    }
    
    final durationStr = duration.substring(2); // Remove 'PT' prefix
    int totalSeconds = 0;
    
    // Parse hours
    final hoursMatch = RegExp(r'(\d+)H').firstMatch(durationStr);
    if (hoursMatch != null) {
      totalSeconds += int.parse(hoursMatch.group(1)!) * 3600;
    }
    
    // Parse minutes
    final minutesMatch = RegExp(r'(\d+)M').firstMatch(durationStr);
    if (minutesMatch != null) {
      totalSeconds += int.parse(minutesMatch.group(1)!) * 60;
    }
    
    // Parse seconds
    final secondsMatch = RegExp(r'(\d+)S').firstMatch(durationStr);
    if (secondsMatch != null) {
      totalSeconds += int.parse(secondsMatch.group(1)!);
    }
    
    return Duration(seconds: totalSeconds);
  }
  
  // Format duration for display (e.g., "4:13")
  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
  
  // Format view count for display (e.g., "1.2M views")
  String get formattedViewCount {
    if (viewCount >= 1000000) {
      return '${(viewCount / 1000000).toStringAsFixed(1)}M views';
    } else if (viewCount >= 1000) {
      return '${(viewCount / 1000).toStringAsFixed(1)}K views';
    } else {
      return '$viewCount views';
    }
  }
  
  // Format like count for display
  String get formattedLikeCount {
    if (likeCount >= 1000000) {
      return '${(likeCount / 1000000).toStringAsFixed(1)}M';
    } else if (likeCount >= 1000) {
      return '${(likeCount / 1000).toStringAsFixed(1)}K';
    } else {
      return likeCount.toString();
    }
  }
  
  // Check if video is recent (published within last 7 days)
  bool get isRecent {
    try {
      final publishedDate = DateTime.parse(publishedAt);
      final now = DateTime.now();
      return now.difference(publishedDate).inDays <= 7;
    } catch (e) {
      return false;
    }
  }
  
  // Check if video is trending (high view count relative to age)
  bool get isTrending {
    try {
      final publishedDate = DateTime.parse(publishedAt);
      final ageInDays = DateTime.now().difference(publishedDate).inDays;
      if (ageInDays == 0) return false; // Don't consider same-day videos as trending
      
      final viewsPerDay = viewCount / ageInDays;
      return viewsPerDay > 10000; // Threshold for trending
    } catch (e) {
      return false;
    }
  }
}
