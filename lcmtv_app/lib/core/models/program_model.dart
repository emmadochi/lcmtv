import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'program_model.g.dart';

@JsonSerializable()
class Program {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final String thumbnailUrl;
  final String bannerUrl;
  final List<String> videoIds;
  final List<String> tags;
  final bool isActive;
  final bool isFeatured;
  final int priority;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final ProgramSchedule? schedule;
  final ProgramStats stats;

  const Program({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.thumbnailUrl,
    required this.bannerUrl,
    this.videoIds = const [],
    this.tags = const [],
    this.isActive = true,
    this.isFeatured = false,
    this.priority = 0,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.schedule,
    required this.stats,
  });

  factory Program.fromJson(Map<String, dynamic> json) => _$ProgramFromJson(json);
  Map<String, dynamic> toJson() => _$ProgramToJson(this);

  factory Program.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Program.fromJson({
      'id': doc.id,
      ...data,
      'createdAt': (data['createdAt'] as Timestamp).toDate(),
      'updatedAt': (data['updatedAt'] as Timestamp).toDate(),
    });
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'thumbnailUrl': thumbnailUrl,
      'bannerUrl': bannerUrl,
      'videoIds': videoIds,
      'tags': tags,
      'isActive': isActive,
      'isFeatured': isFeatured,
      'priority': priority,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
      'schedule': schedule?.toJson(),
      'stats': stats.toJson(),
    };
  }

  Program copyWith({
    String? id,
    String? name,
    String? description,
    String? categoryId,
    String? thumbnailUrl,
    String? bannerUrl,
    List<String>? videoIds,
    List<String>? tags,
    bool? isActive,
    bool? isFeatured,
    int? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    ProgramSchedule? schedule,
    ProgramStats? stats,
  }) {
    return Program(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      videoIds: videoIds ?? this.videoIds,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      schedule: schedule ?? this.schedule,
      stats: stats ?? this.stats,
    );
  }
}

@JsonSerializable()
class ProgramSchedule {
  final String timezone;
  final List<ScheduleDay> days;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isRecurring;

  const ProgramSchedule({
    this.timezone = 'UTC',
    this.days = const [],
    this.startDate,
    this.endDate,
    this.isRecurring = false,
  });

  factory ProgramSchedule.fromJson(Map<String, dynamic> json) => _$ProgramScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$ProgramScheduleToJson(this);
}

@JsonSerializable()
class ScheduleDay {
  final int dayOfWeek; // 0 = Sunday, 1 = Monday, etc.
  final String startTime; // HH:mm format
  final String endTime; // HH:mm format
  final bool isActive;

  const ScheduleDay({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.isActive = true,
  });

  factory ScheduleDay.fromJson(Map<String, dynamic> json) => _$ScheduleDayFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleDayToJson(this);
}

@JsonSerializable()
class ProgramStats {
  final int totalViews;
  final int totalLikes;
  final int totalShares;
  final int totalComments;
  final double averageRating;
  final int totalRatings;
  final int subscriberCount;
  final DateTime lastUpdated;

  const ProgramStats({
    this.totalViews = 0,
    this.totalLikes = 0,
    this.totalShares = 0,
    this.totalComments = 0,
    this.averageRating = 0.0,
    this.totalRatings = 0,
    this.subscriberCount = 0,
    required this.lastUpdated,
  });

  factory ProgramStats.fromJson(Map<String, dynamic> json) => _$ProgramStatsFromJson(json);
  Map<String, dynamic> toJson() => _$ProgramStatsToJson(this);

  factory ProgramStats.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProgramStats.fromJson({
      ...data,
      'lastUpdated': (data['lastUpdated'] as Timestamp).toDate(),
    });
  }

  Map<String, dynamic> toFirestore() {
    return {
      'totalViews': totalViews,
      'totalLikes': totalLikes,
      'totalShares': totalShares,
      'totalComments': totalComments,
      'averageRating': averageRating,
      'totalRatings': totalRatings,
      'subscriberCount': subscriberCount,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }
}

@JsonSerializable()
class TrendingVideo {
  final String videoId;
  final int trendingRank;
  final String categoryId;
  final int viewCount;
  final int likeCount;
  final double engagementScore;
  final DateTime timestamp;
  final String region;

  const TrendingVideo({
    required this.videoId,
    required this.trendingRank,
    required this.categoryId,
    required this.viewCount,
    required this.likeCount,
    required this.engagementScore,
    required this.timestamp,
    required this.region,
  });

  factory TrendingVideo.fromJson(Map<String, dynamic> json) => _$TrendingVideoFromJson(json);
  Map<String, dynamic> toJson() => _$TrendingVideoToJson(this);

  factory TrendingVideo.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TrendingVideo.fromJson({
      'id': doc.id,
      ...data,
      'timestamp': (data['timestamp'] as Timestamp).toDate(),
    });
  }

  Map<String, dynamic> toFirestore() {
    return {
      'videoId': videoId,
      'trendingRank': trendingRank,
      'categoryId': categoryId,
      'viewCount': viewCount,
      'likeCount': likeCount,
      'engagementScore': engagementScore,
      'timestamp': Timestamp.fromDate(timestamp),
      'region': region,
    };
  }
}

@JsonSerializable()
class CategoryTrend {
  final String categoryId;
  final String categoryName;
  final int totalVideos;
  final double averageEngagement;
  final int totalViews;
  final DateTime timestamp;

  const CategoryTrend({
    required this.categoryId,
    required this.categoryName,
    required this.totalVideos,
    required this.averageEngagement,
    required this.totalViews,
    required this.timestamp,
  });

  factory CategoryTrend.fromJson(Map<String, dynamic> json) => _$CategoryTrendFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryTrendToJson(this);

  factory CategoryTrend.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryTrend.fromJson({
      'id': doc.id,
      ...data,
      'timestamp': (data['timestamp'] as Timestamp).toDate(),
    });
  }

  Map<String, dynamic> toFirestore() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'totalVideos': totalVideos,
      'averageEngagement': averageEngagement,
      'totalViews': totalViews,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

@JsonSerializable()
class LiveStream {
  final String videoId;
  final String title;
  final String channelId;
  final String channelTitle;
  final String thumbnailUrl;
  final int viewerCount;
  final DateTime startTime;
  final DateTime? endTime;
  final String categoryId;
  final String status; // 'live', 'scheduled', 'ended'
  final String streamUrl;

  const LiveStream({
    required this.videoId,
    required this.title,
    required this.channelId,
    required this.channelTitle,
    required this.thumbnailUrl,
    required this.viewerCount,
    required this.startTime,
    this.endTime,
    required this.categoryId,
    required this.status,
    required this.streamUrl,
  });

  factory LiveStream.fromJson(Map<String, dynamic> json) => _$LiveStreamFromJson(json);
  Map<String, dynamic> toJson() => _$LiveStreamToJson(this);

  factory LiveStream.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LiveStream.fromJson({
      'id': doc.id,
      ...data,
      'startTime': (data['startTime'] as Timestamp).toDate(),
      'endTime': data['endTime'] != null ? (data['endTime'] as Timestamp).toDate() : null,
    });
  }

  Map<String, dynamic> toFirestore() {
    return {
      'videoId': videoId,
      'title': title,
      'channelId': channelId,
      'channelTitle': channelTitle,
      'thumbnailUrl': thumbnailUrl,
      'viewerCount': viewerCount,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'categoryId': categoryId,
      'status': status,
      'streamUrl': streamUrl,
    };
  }
}
