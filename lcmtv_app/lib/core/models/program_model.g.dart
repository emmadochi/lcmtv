// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Program _$ProgramFromJson(Map<String, dynamic> json) => Program(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      categoryId: json['categoryId'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      bannerUrl: json['bannerUrl'] as String,
      videoIds: (json['videoIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isActive: json['isActive'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      priority: (json['priority'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String,
      schedule: json['schedule'] == null
          ? null
          : ProgramSchedule.fromJson(json['schedule'] as Map<String, dynamic>),
      stats: ProgramStats.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProgramToJson(Program instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'thumbnailUrl': instance.thumbnailUrl,
      'bannerUrl': instance.bannerUrl,
      'videoIds': instance.videoIds,
      'tags': instance.tags,
      'isActive': instance.isActive,
      'isFeatured': instance.isFeatured,
      'priority': instance.priority,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'schedule': instance.schedule,
      'stats': instance.stats,
    };

ProgramSchedule _$ProgramScheduleFromJson(Map<String, dynamic> json) =>
    ProgramSchedule(
      timezone: json['timezone'] as String? ?? 'UTC',
      days: (json['days'] as List<dynamic>?)
              ?.map((e) => ScheduleDay.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      isRecurring: json['isRecurring'] as bool? ?? false,
    );

Map<String, dynamic> _$ProgramScheduleToJson(ProgramSchedule instance) =>
    <String, dynamic>{
      'timezone': instance.timezone,
      'days': instance.days,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'isRecurring': instance.isRecurring,
    };

ScheduleDay _$ScheduleDayFromJson(Map<String, dynamic> json) => ScheduleDay(
      dayOfWeek: (json['dayOfWeek'] as num).toInt(),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$ScheduleDayToJson(ScheduleDay instance) =>
    <String, dynamic>{
      'dayOfWeek': instance.dayOfWeek,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isActive': instance.isActive,
    };

ProgramStats _$ProgramStatsFromJson(Map<String, dynamic> json) => ProgramStats(
      totalViews: (json['totalViews'] as num?)?.toInt() ?? 0,
      totalLikes: (json['totalLikes'] as num?)?.toInt() ?? 0,
      totalShares: (json['totalShares'] as num?)?.toInt() ?? 0,
      totalComments: (json['totalComments'] as num?)?.toInt() ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalRatings: (json['totalRatings'] as num?)?.toInt() ?? 0,
      subscriberCount: (json['subscriberCount'] as num?)?.toInt() ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$ProgramStatsToJson(ProgramStats instance) =>
    <String, dynamic>{
      'totalViews': instance.totalViews,
      'totalLikes': instance.totalLikes,
      'totalShares': instance.totalShares,
      'totalComments': instance.totalComments,
      'averageRating': instance.averageRating,
      'totalRatings': instance.totalRatings,
      'subscriberCount': instance.subscriberCount,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

TrendingVideo _$TrendingVideoFromJson(Map<String, dynamic> json) =>
    TrendingVideo(
      videoId: json['videoId'] as String,
      trendingRank: (json['trendingRank'] as num).toInt(),
      categoryId: json['categoryId'] as String,
      viewCount: (json['viewCount'] as num).toInt(),
      likeCount: (json['likeCount'] as num).toInt(),
      engagementScore: (json['engagementScore'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      region: json['region'] as String,
    );

Map<String, dynamic> _$TrendingVideoToJson(TrendingVideo instance) =>
    <String, dynamic>{
      'videoId': instance.videoId,
      'trendingRank': instance.trendingRank,
      'categoryId': instance.categoryId,
      'viewCount': instance.viewCount,
      'likeCount': instance.likeCount,
      'engagementScore': instance.engagementScore,
      'timestamp': instance.timestamp.toIso8601String(),
      'region': instance.region,
    };

CategoryTrend _$CategoryTrendFromJson(Map<String, dynamic> json) =>
    CategoryTrend(
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      totalVideos: (json['totalVideos'] as num).toInt(),
      averageEngagement: (json['averageEngagement'] as num).toDouble(),
      totalViews: (json['totalViews'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$CategoryTrendToJson(CategoryTrend instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'totalVideos': instance.totalVideos,
      'averageEngagement': instance.averageEngagement,
      'totalViews': instance.totalViews,
      'timestamp': instance.timestamp.toIso8601String(),
    };

LiveStream _$LiveStreamFromJson(Map<String, dynamic> json) => LiveStream(
      videoId: json['videoId'] as String,
      title: json['title'] as String,
      channelId: json['channelId'] as String,
      channelTitle: json['channelTitle'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      viewerCount: (json['viewerCount'] as num).toInt(),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      categoryId: json['categoryId'] as String,
      status: json['status'] as String,
      streamUrl: json['streamUrl'] as String,
    );

Map<String, dynamic> _$LiveStreamToJson(LiveStream instance) =>
    <String, dynamic>{
      'videoId': instance.videoId,
      'title': instance.title,
      'channelId': instance.channelId,
      'channelTitle': instance.channelTitle,
      'thumbnailUrl': instance.thumbnailUrl,
      'viewerCount': instance.viewerCount,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'categoryId': instance.categoryId,
      'status': instance.status,
      'streamUrl': instance.streamUrl,
    };
