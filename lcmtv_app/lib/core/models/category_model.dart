import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  final String id;
  final String title;
  final String assignable;
  final String? parentId;
  
  const CategoryModel({
    required this.id,
    required this.title,
    required this.assignable,
    this.parentId,
  });
  
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] ?? {};
    
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      title: snippet['title'] ?? '',
      assignable: snippet['assignable']?.toString() ?? 'true',
      parentId: snippet['parentId']?.toString(),
    );
  }
  
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
  
  // Check if category is assignable to videos
  bool get isAssignable => assignable.toLowerCase() == 'true';
  
  // Get display name with emoji (if applicable)
  String get displayName {
    switch (id) {
      case '1':
        return '📺 Film & Animation';
      case '2':
        return '🚗 Autos & Vehicles';
      case '10':
        return '🎵 Music';
      case '15':
        return '🐾 Pets & Animals';
      case '17':
        return '🏃 Sports';
      case '19':
        return '✈️ Travel & Events';
      case '20':
        return '🎮 Gaming';
      case '22':
        return '👥 People & Blogs';
      case '23':
        return '💼 Comedy';
      case '24':
        return '🎭 Entertainment';
      case '25':
        return '📰 News & Politics';
      case '26':
        return '📚 Howto & Style';
      case '27':
        return '🎓 Education';
      case '28':
        return '🔬 Science & Technology';
      default:
        return title;
    }
  }
  
  // Get category color (for UI theming)
  String get colorHex {
    switch (id) {
      case '1':
        return '#FF6B6B'; // Red
      case '2':
        return '#4ECDC4'; // Teal
      case '10':
        return '#45B7D1'; // Blue
      case '15':
        return '#96CEB4'; // Green
      case '17':
        return '#FFEAA7'; // Yellow
      case '19':
        return '#DDA0DD'; // Plum
      case '20':
        return '#98D8C8'; // Mint
      case '22':
        return '#F7DC6F'; // Gold
      case '23':
        return '#BB8FCE'; // Light Purple
      case '24':
        return '#85C1E9'; // Light Blue
      case '25':
        return '#F8C471'; // Orange
      case '26':
        return '#82E0AA'; // Light Green
      case '27':
        return '#F1948A'; // Light Red
      case '28':
        return '#AED6F1'; // Light Blue
      default:
        return '#9B59B6'; // Purple (default)
    }
  }
  
  // Get category icon (Material Icons)
  String get iconName {
    switch (id) {
      case '1':
        return 'movie';
      case '2':
        return 'directions_car';
      case '10':
        return 'music_note';
      case '15':
        return 'pets';
      case '17':
        return 'sports_soccer';
      case '19':
        return 'flight';
      case '20':
        return 'videogame_asset';
      case '22':
        return 'people';
      case '23':
        return 'comedy';
      case '24':
        return 'theater_comedy';
      case '25':
        return 'newspaper';
      case '26':
        return 'build';
      case '27':
        return 'school';
      case '28':
        return 'computer';
      default:
        return 'category';
    }
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() => 'CategoryModel(id: $id, title: $title)';
}
