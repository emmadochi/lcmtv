import '../../../../core/models/admin_content_model.dart';

abstract class AdminRepository {
  // Content Management
  Future<List<AdminContent>> getAllContent();
  Future<AdminContent?> getContentById(String id);
  Future<AdminContent> createContent(AdminContent content);
  Future<AdminContent> updateContent(AdminContent content);
  Future<void> deleteContent(String id);
  Future<List<AdminContent>> getContentByType(String type);
  Future<List<AdminContent>> getFeaturedContent();
  Future<List<AdminContent>> searchContent(String query);

  // Category Management
  Future<List<AdminCategory>> getAllCategories();
  Future<AdminCategory?> getCategoryById(String id);
  Future<AdminCategory> createCategory(AdminCategory category);
  Future<AdminCategory> updateCategory(AdminCategory category);
  Future<void> deleteCategory(String id);
  Future<List<AdminCategory>> getActiveCategories();

  // User Management
  Future<List<AdminUser>> getAllUsers();
  Future<AdminUser?> getUserById(String id);
  Future<AdminUser> updateUser(AdminUser user);
  Future<void> deleteUser(String id);
  Future<List<AdminUser>> getUsersByRole(String role);

  // Analytics and Statistics
  Future<Map<String, dynamic>> getContentStatistics();
  Future<Map<String, dynamic>> getUserStatistics();
  Future<Map<String, dynamic>> getCategoryStatistics();

  // Bulk Operations
  Future<void> bulkUpdateContent(List<AdminContent> contentList);
  Future<void> bulkDeleteContent(List<String> contentIds);
  Future<void> bulkUpdateCategories(List<AdminCategory> categoryList);

  // Search and Filter
  Future<List<AdminContent>> getContentByFilters({
    String? type,
    bool? isActive,
    bool? isFeatured,
    String? categoryId,
    DateTime? createdAfter,
    DateTime? createdBefore,
    int? limit,
    int? offset,
  });

  // Cache Management
  Future<void> clearCache();
  Future<void> refreshCache();
}
