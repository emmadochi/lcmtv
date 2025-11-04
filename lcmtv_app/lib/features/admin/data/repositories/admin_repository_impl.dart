import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/admin_content_model.dart';
import '../../domain/repositories/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Content Management
  @override
  Future<List<AdminContent>> getAllContent() async {
    try {
      final snapshot = await _firestore.collection('admin_content').get();
      return snapshot.docs.map((doc) => AdminContent.fromJson({
        'id': doc.id,
        ...doc.data(),
      })).toList();
    } catch (e) {
      throw Exception('Failed to get all content: $e');
    }
  }

  @override
  Future<AdminContent?> getContentById(String id) async {
    try {
      final doc = await _firestore.collection('admin_content').doc(id).get();
      if (doc.exists) {
        return AdminContent.fromJson({
          'id': doc.id,
          ...doc.data()!,
        });
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get content by id: $e');
    }
  }

  @override
  Future<AdminContent> createContent(AdminContent content) async {
    try {
      print('🔵 Creating content in Firestore: ${content.title}');
      final docRef = await _firestore.collection('admin_content').add(content.toJson());
      final createdContent = content.copyWith(id: docRef.id);
      print('✅ Content created successfully with ID: ${docRef.id}');
      return createdContent;
    } catch (e) {
      print('❌ Failed to create content: $e');
      throw Exception('Failed to create content: $e');
    }
  }

  @override
  Future<AdminContent> updateContent(AdminContent content) async {
    try {
      print('🔵 Updating content in Firestore: ${content.title}');
      await _firestore.collection('admin_content').doc(content.id).update(content.toJson());
      print('✅ Content updated successfully: ${content.id}');
      return content;
    } catch (e) {
      print('❌ Failed to update content: $e');
      throw Exception('Failed to update content: $e');
    }
  }

  @override
  Future<void> deleteContent(String id) async {
    try {
      print('🔵 Deleting content from Firestore: $id');
      await _firestore.collection('admin_content').doc(id).delete();
      print('✅ Content deleted successfully: $id');
    } catch (e) {
      print('❌ Failed to delete content: $e');
      throw Exception('Failed to delete content: $e');
    }
  }

  @override
  Future<List<AdminContent>> getContentByType(String type) async {
    try {
      final snapshot = await _firestore
          .collection('admin_content')
          .where('type', isEqualTo: type)
          .get();
      return snapshot.docs.map((doc) => AdminContent.fromJson({
        'id': doc.id,
        ...doc.data(),
      })).toList();
    } catch (e) {
      throw Exception('Failed to get content by type: $e');
    }
  }

  @override
  Future<List<AdminContent>> getFeaturedContent() async {
    try {
      final snapshot = await _firestore
          .collection('admin_content')
          .where('isFeatured', isEqualTo: true)
          .get();
      return snapshot.docs.map((doc) => AdminContent.fromJson({
        'id': doc.id,
        ...doc.data(),
      })).toList();
    } catch (e) {
      throw Exception('Failed to get featured content: $e');
    }
  }

  @override
  Future<List<AdminContent>> searchContent(String query) async {
    try {
      final snapshot = await _firestore.collection('admin_content').get();
      return snapshot.docs
          .map((doc) => AdminContent.fromJson({
            'id': doc.id,
            ...doc.data(),
          }))
          .where((content) =>
              content.title.toLowerCase().contains(query.toLowerCase()) ||
              content.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Failed to search content: $e');
    }
  }

  // Category Management
  @override
  Future<List<AdminCategory>> getAllCategories() async {
    try {
      final snapshot = await _firestore.collection('admin_categories').get();
      return snapshot.docs.map((doc) => AdminCategory.fromJson({
        'id': doc.id,
        ...doc.data(),
      })).toList();
    } catch (e) {
      throw Exception('Failed to get all categories: $e');
    }
  }

  @override
  Future<AdminCategory?> getCategoryById(String id) async {
    try {
      final doc = await _firestore.collection('admin_categories').doc(id).get();
      if (doc.exists) {
        return AdminCategory.fromJson({
          'id': doc.id,
          ...doc.data()!,
        });
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get category by id: $e');
    }
  }

  @override
  Future<AdminCategory> createCategory(AdminCategory category) async {
    try {
      final docRef = await _firestore.collection('admin_categories').add(category.toJson());
      return category.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to create category: $e');
    }
  }

  @override
  Future<AdminCategory> updateCategory(AdminCategory category) async {
    try {
      await _firestore.collection('admin_categories').doc(category.id).update(category.toJson());
      return category;
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await _firestore.collection('admin_categories').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  @override
  Future<List<AdminCategory>> getActiveCategories() async {
    try {
      final snapshot = await _firestore
          .collection('admin_categories')
          .where('isActive', isEqualTo: true)
          .get();
      return snapshot.docs.map((doc) => AdminCategory.fromJson({
        'id': doc.id,
        ...doc.data(),
      })).toList();
    } catch (e) {
      throw Exception('Failed to get active categories: $e');
    }
  }

  // User Management
  @override
  Future<List<AdminUser>> getAllUsers() async {
    try {
      final snapshot = await _firestore.collection('admin_users').get();
      return snapshot.docs.map((doc) => AdminUser.fromJson({
        'id': doc.id,
        ...doc.data(),
      })).toList();
    } catch (e) {
      throw Exception('Failed to get all users: $e');
    }
  }

  @override
  Future<AdminUser?> getUserById(String id) async {
    try {
      final doc = await _firestore.collection('admin_users').doc(id).get();
      if (doc.exists) {
        return AdminUser.fromJson({
          'id': doc.id,
          ...doc.data()!,
        });
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user by id: $e');
    }
  }

  @override
  Future<AdminUser> updateUser(AdminUser user) async {
    try {
      await _firestore.collection('admin_users').doc(user.id).update(user.toJson());
      return user;
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      await _firestore.collection('admin_users').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  @override
  Future<List<AdminUser>> getUsersByRole(String role) async {
    try {
      final snapshot = await _firestore
          .collection('admin_users')
          .where('role', isEqualTo: role)
          .get();
      return snapshot.docs.map((doc) => AdminUser.fromJson({
        'id': doc.id,
        ...doc.data(),
      })).toList();
    } catch (e) {
      throw Exception('Failed to get users by role: $e');
    }
  }

  // Analytics and Statistics
  @override
  Future<Map<String, dynamic>> getContentStatistics() async {
    try {
      final contentSnapshot = await _firestore.collection('admin_content').get();
      final categoriesSnapshot = await _firestore.collection('admin_categories').get();
      final usersSnapshot = await _firestore.collection('admin_users').get();

      final totalContent = contentSnapshot.docs.length;
      final activeContent = contentSnapshot.docs
          .where((doc) => doc.data()['isActive'] == true)
          .length;
      final featuredContent = contentSnapshot.docs
          .where((doc) => doc.data()['isFeatured'] == true)
          .length;

      return {
        'totalContent': totalContent,
        'activeContent': activeContent,
        'featuredContent': featuredContent,
        'totalCategories': categoriesSnapshot.docs.length,
        'totalUsers': usersSnapshot.docs.length,
        'contentByType': _getContentByType(contentSnapshot.docs),
      };
    } catch (e) {
      throw Exception('Failed to get content statistics: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserStatistics() async {
    try {
      final snapshot = await _firestore.collection('admin_users').get();
      final totalUsers = snapshot.docs.length;
      final activeUsers = snapshot.docs
          .where((doc) => doc.data()['isActive'] == true)
          .length;

      final usersByRole = <String, int>{};
      for (final doc in snapshot.docs) {
        final role = doc.data()['role'] as String? ?? 'unknown';
        usersByRole[role] = (usersByRole[role] ?? 0) + 1;
      }

      return {
        'totalUsers': totalUsers,
        'activeUsers': activeUsers,
        'usersByRole': usersByRole,
      };
    } catch (e) {
      throw Exception('Failed to get user statistics: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getCategoryStatistics() async {
    try {
      final snapshot = await _firestore.collection('admin_categories').get();
      final totalCategories = snapshot.docs.length;
      final activeCategories = snapshot.docs
          .where((doc) => doc.data()['isActive'] == true)
          .length;

      return {
        'totalCategories': totalCategories,
        'activeCategories': activeCategories,
      };
    } catch (e) {
      throw Exception('Failed to get category statistics: $e');
    }
  }

  // Bulk Operations
  @override
  Future<void> bulkUpdateContent(List<AdminContent> contentList) async {
    try {
      final batch = _firestore.batch();
      for (final content in contentList) {
        final docRef = _firestore.collection('admin_content').doc(content.id);
        batch.update(docRef, content.toJson());
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to bulk update content: $e');
    }
  }

  @override
  Future<void> bulkDeleteContent(List<String> contentIds) async {
    try {
      final batch = _firestore.batch();
      for (final id in contentIds) {
        final docRef = _firestore.collection('admin_content').doc(id);
        batch.delete(docRef);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to bulk delete content: $e');
    }
  }

  @override
  Future<void> bulkUpdateCategories(List<AdminCategory> categoryList) async {
    try {
      final batch = _firestore.batch();
      for (final category in categoryList) {
        final docRef = _firestore.collection('admin_categories').doc(category.id);
        batch.update(docRef, category.toJson());
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to bulk update categories: $e');
    }
  }

  // Search and Filter
  @override
  Future<List<AdminContent>> getContentByFilters({
    String? type,
    bool? isActive,
    bool? isFeatured,
    String? categoryId,
    DateTime? createdAfter,
    DateTime? createdBefore,
    int? limit,
    int? offset,
  }) async {
    try {
      Query query = _firestore.collection('admin_content');

      if (type != null) {
        query = query.where('type', isEqualTo: type);
      }
      if (isActive != null) {
        query = query.where('isActive', isEqualTo: isActive);
      }
      if (isFeatured != null) {
        query = query.where('isFeatured', isEqualTo: isFeatured);
      }
      if (categoryId != null) {
        query = query.where('categoryId', isEqualTo: categoryId);
      }
      if (createdAfter != null) {
        query = query.where('createdAt', isGreaterThan: createdAfter);
      }
      if (createdBefore != null) {
        query = query.where('createdAt', isLessThan: createdBefore);
      }

      if (limit != null) {
        query = query.limit(limit);
      }
      // Note: offset() is not available in current Firestore version
      // Use startAfter() with document cursor for pagination instead

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => AdminContent.fromJson({
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      })).toList();
    } catch (e) {
      throw Exception('Failed to get content by filters: $e');
    }
  }

  // Cache Management
  @override
  Future<void> clearCache() async {
    // Firestore handles caching automatically
    // This method is for future implementation of custom caching
  }

  @override
  Future<void> refreshCache() async {
    // Firestore handles caching automatically
    // This method is for future implementation of custom caching
  }

  // Helper Methods
  Map<String, int> _getContentByType(List<QueryDocumentSnapshot> docs) {
    final Map<String, int> contentByType = {};
    for (final doc in docs) {
      final type = (doc.data() as Map<String, dynamic>)['type'] as String? ?? 'unknown';
      contentByType[type] = (contentByType[type] ?? 0) + 1;
    }
    return contentByType;
  }
}
