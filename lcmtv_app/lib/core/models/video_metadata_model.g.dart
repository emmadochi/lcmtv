// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_metadata_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoMetadata _$VideoMetadataFromJson(Map<String, dynamic> json) =>
    VideoMetadata(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      channelId: json['channelId'] as String,
      channelTitle: json['channelTitle'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      publishedAt: json['publishedAt'] as String,
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      categoryId: json['categoryId'] as String,
      categoryTitle: json['categoryTitle'] as String,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isLive: json['isLive'] as bool? ?? false,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      liveUrl: json['liveUrl'] as String?,
      liveStartTime: json['liveStartTime'] == null
          ? null
          : DateTime.parse(json['liveStartTime'] as String),
      liveEndTime: json['liveEndTime'] == null
          ? null
          : DateTime.parse(json['liveEndTime'] as String),
    );

Map<String, dynamic> _$VideoMetadataToJson(VideoMetadata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'channelId': instance.channelId,
      'channelTitle': instance.channelTitle,
      'thumbnailUrl': instance.thumbnailUrl,
      'publishedAt': instance.publishedAt,
      'duration': instance.duration.inMicroseconds,
      'categoryId': instance.categoryId,
      'categoryTitle': instance.categoryTitle,
      'tags': instance.tags,
      'isLive': instance.isLive,
      'viewCount': instance.viewCount,
      'liveUrl': instance.liveUrl,
      'liveStartTime': instance.liveStartTime?.toIso8601String(),
      'liveEndTime': instance.liveEndTime?.toIso8601String(),
    };

VideoStats _$VideoStatsFromJson(Map<String, dynamic> json) => VideoStats(
      viewCount: (json['viewCount'] as num).toInt(),
      likeCount: (json['likeCount'] as num).toInt(),
      dislikeCount: (json['dislikeCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
      shareCount: (json['shareCount'] as num).toInt(),
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalRatings: (json['totalRatings'] as num?)?.toInt() ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$VideoStatsToJson(VideoStats instance) =>
    <String, dynamic>{
      'viewCount': instance.viewCount,
      'likeCount': instance.likeCount,
      'dislikeCount': instance.dislikeCount,
      'commentCount': instance.commentCount,
      'shareCount': instance.shareCount,
      'averageRating': instance.averageRating,
      'totalRatings': instance.totalRatings,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

WatchHistory _$WatchHistoryFromJson(Map<String, dynamic> json) => WatchHistory(
      videoId: json['videoId'] as String,
      userId: json['userId'] as String,
      watchTime: Duration(microseconds: (json['watchTime'] as num).toInt()),
      completionPercentage: (json['completionPercentage'] as num).toDouble(),
      watchedAt: DateTime.parse(json['watchedAt'] as String),
      deviceType: json['deviceType'] as String,
      sessionId: json['sessionId'] as String?,
    );

Map<String, dynamic> _$WatchHistoryToJson(WatchHistory instance) =>
    <String, dynamic>{
      'videoId': instance.videoId,
      'userId': instance.userId,
      'watchTime': instance.watchTime.inMicroseconds,
      'completionPercentage': instance.completionPercentage,
      'watchedAt': instance.watchedAt.toIso8601String(),
      'deviceType': instance.deviceType,
      'sessionId': instance.sessionId,
    };

LikedVideo _$LikedVideoFromJson(Map<String, dynamic> json) => LikedVideo(
      videoId: json['videoId'] as String,
      userId: json['userId'] as String,
      likedAt: DateTime.parse(json['likedAt'] as String),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$LikedVideoToJson(LikedVideo instance) =>
    <String, dynamic>{
      'videoId': instance.videoId,
      'userId': instance.userId,
      'likedAt': instance.likedAt.toIso8601String(),
      'note': instance.note,
    };

Playlist _$PlaylistFromJson(Map<String, dynamic> json) => Playlist(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      userId: json['userId'] as String,
      videoIds: (json['videoIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isPublic: json['isPublic'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      thumbnailUrl: json['thumbnailUrl'] as String,
    );

Map<String, dynamic> _$PlaylistToJson(Playlist instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'userId': instance.userId,
      'videoIds': instance.videoIds,
      'isPublic': instance.isPublic,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'thumbnailUrl': instance.thumbnailUrl,
    };
