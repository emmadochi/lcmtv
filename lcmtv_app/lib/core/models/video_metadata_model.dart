import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video_metadata_model.g.dart';

@JsonSerializable()
class VideoMetadata {
  final String id;
  final String title;
  final String description;
  final String channelId;
  final String channelTitle;
  final String thumbnailUrl;
  final String publishedAt;
  final Duration duration;
  final String categoryId;
  final String categoryTitle;
  final List<String> tags;
  final bool isLive;
  final String? liveUrl;
  final DateTime? liveStartTime;
  final DateTime? liveEndTime;

  const VideoMetadata({
    required this.id,
    required this.title,
    required this.description,
    required this.channelId,
    required this.channelTitle,
    required this.thumbnailUrl,
    required this.publishedAt,
    required this.duration,
    required this.categoryId,
    required this.categoryTitle,
    this.tags = const [],
    this.isLive = false,
    this.liveUrl,
    this.liveStartTime,
    this.liveEndTime,
  });

  factory VideoMetadata.fromJson(Map<String, dynamic> json) => _$VideoMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$VideoMetadataToJson(this);

  factory VideoMetadata.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VideoMetadata.fromJson({
      'id': doc.id,
      ...data,
    });
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'channelId': channelId,
      'channelTitle': channelTitle,
      'thumbnailUrl': thumbnailUrl,
      'publishedAt': publishedAt,
      'duration': duration.inSeconds,
      'categoryId': categoryId,
      'categoryTitle': categoryTitle,
      'tags': tags,
      'isLive': isLive,
      'liveUrl': liveUrl,
      'liveStartTime': liveStartTime != null ? Timestamp.fromDate(liveStartTime!) : null,
      'liveEndTime': liveEndTime != null ? Timestamp.fromDate(liveEndTime!) : null,
    };
  }

  VideoMetadata copyWith({
    String? id,
    String? title,
    String? description,
    String? channelId,
    String? channelTitle,
    String? thumbnailUrl,
    String? publishedAt,
    Duration? duration,
    String? categoryId,
    String? categoryTitle,
    List<String>? tags,
    bool? isLive,
    String? liveUrl,
    DateTime? liveStartTime,
    DateTime? liveEndTime,
  }) {
    return VideoMetadata(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      channelId: channelId ?? this.channelId,
      channelTitle: channelTitle ?? this.channelTitle,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      duration: duration ?? this.duration,
      categoryId: categoryId ?? this.categoryId,
      categoryTitle: categoryTitle ?? this.categoryTitle,
      tags: tags ?? this.tags,
      isLive: isLive ?? this.isLive,
      liveUrl: liveUrl ?? this.liveUrl,
      liveStartTime: liveStartTime ?? this.liveStartTime,
      liveEndTime: liveEndTime ?? this.liveEndTime,
    );
  }
}

@JsonSerializable()
class VideoStats {
  final int viewCount;
  final int likeCount;
  final int dislikeCount;
  final int commentCount;
  final int shareCount;
  final double averageRating;
  final int totalRatings;
  final DateTime lastUpdated;

  const VideoStats({
    required this.viewCount,
    required this.likeCount,
    required this.dislikeCount,
    required this.commentCount,
    required this.shareCount,
    this.averageRating = 0.0,
    this.totalRatings = 0,
    required this.lastUpdated,
  });

  factory VideoStats.fromJson(Map<String, dynamic> json) => _$VideoStatsFromJson(json);
  Map<String, dynamic> toJson() => _$VideoStatsToJson(this);

  factory VideoStats.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VideoStats.fromJson({
      ...data,
      'lastUpdated': (data['lastUpdated'] as Timestamp).toDate(),
    });
  }

  Map<String, dynamic> toFirestore() {
    return {
      'viewCount': viewCount,
      'likeCount': likeCount,
      'dislikeCount': dislikeCount,
      'commentCount': commentCount,
      'shareCount': shareCount,
      'averageRating': averageRating,
      'totalRatings': totalRatings,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  VideoStats copyWith({
    int? viewCount,
    int? likeCount,
    int? dislikeCount,
    int? commentCount,
    int? shareCount,
    double? averageRating,
    int? totalRatings,
    DateTime? lastUpdated,
  }) {
    return VideoStats(
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      dislikeCount: dislikeCount ?? this.dislikeCount,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      averageRating: averageRating ?? this.averageRating,
      totalRatings: totalRatings ?? this.totalRatings,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

@JsonSerializable()
class WatchHistory {
  final String videoId;
  final String userId;
  final Duration watchTime;
  final double completionPercentage;
  final DateTime watchedAt;
  final String deviceType;
  final String? sessionId;

  const WatchHistory({
    required this.videoId,
    required this.userId,
    required this.watchTime,
    required this.completionPercentage,
    required this.watchedAt,
    required this.deviceType,
    this.sessionId,
  });

  factory WatchHistory.fromJson(Map<String, dynamic> json) => _$WatchHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$WatchHistoryToJson(this);

  factory WatchHistory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WatchHistory.fromJson({
      'id': doc.id,
      ...data,
      'watchedAt': (data['watchedAt'] as Timestamp).toDate(),
    });
  }

  Map<String, dynamic> toFirestore() {
    return {
      'videoId': videoId,
      'userId': userId,
      'watchTime': watchTime.inSeconds,
      'completionPercentage': completionPercentage,
      'watchedAt': Timestamp.fromDate(watchedAt),
      'deviceType': deviceType,
      'sessionId': sessionId,
    };
  }
}

@JsonSerializable()
class LikedVideo {
  final String videoId;
  final String userId;
  final DateTime likedAt;
  final String? note;

  const LikedVideo({
    required this.videoId,
    required this.userId,
    required this.likedAt,
    this.note,
  });

  factory LikedVideo.fromJson(Map<String, dynamic> json) => _$LikedVideoFromJson(json);
  Map<String, dynamic> toJson() => _$LikedVideoToJson(this);

  factory LikedVideo.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LikedVideo.fromJson({
      'id': doc.id,
      ...data,
      'likedAt': (data['likedAt'] as Timestamp).toDate(),
    });
  }

  Map<String, dynamic> toFirestore() {
    return {
      'videoId': videoId,
      'userId': userId,
      'likedAt': Timestamp.fromDate(likedAt),
      'note': note,
    };
  }
}

@JsonSerializable()
class Playlist {
  final String id;
  final String name;
  final String description;
  final String userId;
  final List<String> videoIds;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String thumbnailUrl;

  const Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.userId,
    this.videoIds = const [],
    this.isPublic = false,
    required this.createdAt,
    required this.updatedAt,
    required this.thumbnailUrl,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) => _$PlaylistFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistToJson(this);

  factory Playlist.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Playlist.fromJson({
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
      'userId': userId,
      'videoIds': videoIds,
      'isPublic': isPublic,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'thumbnailUrl': thumbnailUrl,
    };
  }
}
