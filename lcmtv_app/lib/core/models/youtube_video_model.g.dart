// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_video_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YouTubeVideoModel _$YouTubeVideoModelFromJson(Map<String, dynamic> json) =>
    YouTubeVideoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      channelId: json['channelId'] as String,
      channelTitle: json['channelTitle'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      publishedAt: json['publishedAt'] as String,
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      viewCount: (json['viewCount'] as num).toInt(),
      likeCount: (json['likeCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
      categoryId: json['categoryId'] as String,
      isLive: json['isLive'] as bool,
      liveViewerCount: (json['liveViewerCount'] as num?)?.toInt(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$YouTubeVideoModelToJson(YouTubeVideoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'channelId': instance.channelId,
      'channelTitle': instance.channelTitle,
      'thumbnailUrl': instance.thumbnailUrl,
      'publishedAt': instance.publishedAt,
      'duration': instance.duration.inMicroseconds,
      'viewCount': instance.viewCount,
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'categoryId': instance.categoryId,
      'isLive': instance.isLive,
      'liveViewerCount': instance.liveViewerCount,
      'tags': instance.tags,
    };
