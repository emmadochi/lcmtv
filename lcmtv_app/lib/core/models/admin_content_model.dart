import 'package:json_annotation/json_annotation.dart';

part 'admin_content_model.g.dart';

@JsonSerializable()
class AdminContent {
  final String id;
  final String title;
  final String description;
  final String type; // 'video', 'category', 'featured', 'banner'
  final String? videoId;
  final String? categoryId;
  final String? imageUrl;
  final String? thumbnailUrl;
  final String? contentUrl;
  final bool isActive;
  final bool isFeatured;
  final int priority;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String? updatedBy;
  final Map<String, dynamic>? metadata;

  const AdminContent({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.videoId,
    this.categoryId,
    this.imageUrl,
    this.thumbnailUrl,
    this.contentUrl,
    this.isActive = true,
    this.isFeatured = false,
    this.priority = 0,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.updatedBy,
    this.metadata,
  });

  factory AdminContent.fromJson(Map<String, dynamic> json) => _$AdminContentFromJson(json);
  Map<String, dynamic> toJson() => _$AdminContentToJson(this);

  AdminContent copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? videoId,
    String? categoryId,
    String? imageUrl,
    String? thumbnailUrl,
    String? contentUrl,
    bool? isActive,
    bool? isFeatured,
    int? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    Map<String, dynamic>? metadata,
  }) {
    return AdminContent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      videoId: videoId ?? this.videoId,
      categoryId: categoryId ?? this.categoryId,
      imageUrl: imageUrl ?? this.imageUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      contentUrl: contentUrl ?? this.contentUrl,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'AdminContent(id: $id, title: $title, type: $type, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdminContent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

@JsonSerializable()
class AdminCategory {
  final String id;
  final String name;
  final String description;
  final String? parentId;
  final String? iconUrl;
  final String? color;
  final bool isActive;
  final int priority;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  const AdminCategory({
    required this.id,
    required this.name,
    required this.description,
    this.parentId,
    this.iconUrl,
    this.color,
    this.isActive = true,
    this.priority = 0,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  factory AdminCategory.fromJson(Map<String, dynamic> json) => _$AdminCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$AdminCategoryToJson(this);

  AdminCategory copyWith({
    String? id,
    String? name,
    String? description,
    String? parentId,
    String? iconUrl,
    String? color,
    bool? isActive,
    int? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) {
    return AdminCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      parentId: parentId ?? this.parentId,
      iconUrl: iconUrl ?? this.iconUrl,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  String toString() {
    return 'AdminCategory(id: $id, name: $name, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdminCategory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

@JsonSerializable()
class AdminUser {
  final String id;
  final String email;
  final String displayName;
  final String role; // 'admin', 'moderator', 'editor'
  final bool isActive;
  final DateTime createdAt;
  final DateTime lastLogin;
  final List<String> permissions;

  const AdminUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
    this.isActive = true,
    required this.createdAt,
    required this.lastLogin,
    this.permissions = const [],
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) => _$AdminUserFromJson(json);
  Map<String, dynamic> toJson() => _$AdminUserToJson(this);

  bool hasPermission(String permission) {
    return permissions.contains(permission) || role == 'admin';
  }

  bool canManageContent() {
    return hasPermission('manage_content') || role == 'admin';
  }

  bool canManageUsers() {
    return hasPermission('manage_users') || role == 'admin';
  }

  bool canManageCategories() {
    return hasPermission('manage_categories') || role == 'admin';
  }

  @override
  String toString() {
    return 'AdminUser(id: $id, email: $email, role: $role)';
  }
}
