import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/admin_content_model.dart';

class FirestoreTestDataService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize test data in Firestore
  static Future<void> initializeTestData() async {
    print('🔵 Initializing Firestore test data...');
    
    try {
      await _createTestCategories();
      await _createTestContent();
      await _createTestUsers();
      print('✅ Firestore test data initialized successfully');
    } catch (e) {
      print('❌ Error initializing Firestore test data: $e');
      rethrow;
    }
  }

  // Create test categories
  static Future<void> _createTestCategories() async {
    final categories = [
      AdminCategory(
        id: 'cat_1',
        name: 'Gaming',
        description: 'Gaming videos and live streams',
        iconUrl: 'https://picsum.photos/seed/gaming/100/100',
        color: '#FF6B6B',
        isActive: true,
        priority: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
        createdBy: 'admin',
      ),
      AdminCategory(
        id: 'cat_2',
        name: 'Music',
        description: 'Music videos and performances',
        iconUrl: 'https://picsum.photos/seed/music/100/100',
        color: '#4ECDC4',
        isActive: true,
        priority: 2,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now(),
        createdBy: 'admin',
      ),
      AdminCategory(
        id: 'cat_3',
        name: 'Technology',
        description: 'Tech reviews and tutorials',
        iconUrl: 'https://picsum.photos/seed/tech/100/100',
        color: '#45B7D1',
        isActive: true,
        priority: 3,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
        createdBy: 'admin',
      ),
      AdminCategory(
        id: 'cat_4',
        name: 'Entertainment',
        description: 'Entertainment and comedy videos',
        iconUrl: 'https://picsum.photos/seed/entertainment/100/100',
        color: '#96CEB4',
        isActive: true,
        priority: 4,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
        createdBy: 'admin',
      ),
      AdminCategory(
        id: 'cat_5',
        name: 'Education',
        description: 'Educational content and tutorials',
        iconUrl: 'https://picsum.photos/seed/education/100/100',
        color: '#FFEAA7',
        isActive: true,
        priority: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
        createdBy: 'admin',
      ),
    ];

    for (final category in categories) {
      await _firestore.collection('admin_categories').doc(category.id).set(category.toJson());
      print('✅ Created category: ${category.name}');
    }
  }

  // Create test content
  static Future<void> _createTestContent() async {
    final content = [
      AdminContent(
        id: 'content_1',
        title: 'Amazing Gaming Video',
        description: 'Check out this incredible gaming moment!',
        type: 'video',
        videoId: 'dQw4w9WgXcQ',
        categoryId: 'cat_1',
        thumbnailUrl: 'https://picsum.photos/seed/gaming1/400/300',
        imageUrl: 'https://picsum.photos/seed/gaming1/800/600',
        isActive: true,
        isFeatured: true,
        priority: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
        createdBy: 'admin',
        updatedBy: 'admin',
        metadata: {
          'views': 125000,
          'likes': 8500,
          'comments': 234,
        },
      ),
      AdminContent(
        id: 'content_2',
        title: 'Music Performance Live',
        description: 'Live music performance from our studio',
        type: 'video',
        videoId: 'jNQXAC9IVRw',
        categoryId: 'cat_2',
        thumbnailUrl: 'https://picsum.photos/seed/music1/400/300',
        imageUrl: 'https://picsum.photos/seed/music1/800/600',
        isActive: true,
        isFeatured: false,
        priority: 2,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        updatedAt: DateTime.now(),
        createdBy: 'admin',
        updatedBy: 'admin',
        metadata: {
          'views': 89000,
          'likes': 6200,
          'comments': 156,
        },
      ),
      AdminContent(
        id: 'content_3',
        title: 'Tech Review: Latest Smartphone',
        description: 'Comprehensive review of the latest smartphone',
        type: 'video',
        videoId: 'M7lc1UVf-VE',
        categoryId: 'cat_3',
        thumbnailUrl: 'https://picsum.photos/seed/tech1/400/300',
        imageUrl: 'https://picsum.photos/seed/tech1/800/600',
        isActive: true,
        isFeatured: true,
        priority: 3,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now(),
        createdBy: 'admin',
        updatedBy: 'admin',
        metadata: {
          'views': 156000,
          'likes': 12000,
          'comments': 445,
        },
      ),
      AdminContent(
        id: 'content_4',
        title: 'Comedy Skit Collection',
        description: 'Funny comedy skits to brighten your day',
        type: 'video',
        videoId: 'L_jWHffIx5E',
        categoryId: 'cat_4',
        thumbnailUrl: 'https://picsum.photos/seed/comedy1/400/300',
        imageUrl: 'https://picsum.photos/seed/comedy1/800/600',
        isActive: true,
        isFeatured: false,
        priority: 4,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now(),
        createdBy: 'admin',
        updatedBy: 'admin',
        metadata: {
          'views': 78000,
          'likes': 5400,
          'comments': 189,
        },
      ),
      AdminContent(
        id: 'content_5',
        title: 'Programming Tutorial',
        description: 'Learn programming with this comprehensive tutorial',
        type: 'video',
        videoId: 'fJ9rUzIMcZQ',
        categoryId: 'cat_5',
        thumbnailUrl: 'https://picsum.photos/seed/education1/400/300',
        imageUrl: 'https://picsum.photos/seed/education1/800/600',
        isActive: true,
        isFeatured: true,
        priority: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
        createdBy: 'admin',
        updatedBy: 'admin',
        metadata: {
          'views': 234000,
          'likes': 18700,
          'comments': 567,
        },
      ),
      AdminContent(
        id: 'content_6',
        title: 'Featured Banner',
        description: 'Special featured content banner',
        type: 'banner',
        categoryId: 'cat_1',
        thumbnailUrl: 'https://picsum.photos/seed/banner1/800/400',
        imageUrl: 'https://picsum.photos/seed/banner1/1200/600',
        contentUrl: 'https://example.com/featured',
        isActive: true,
        isFeatured: true,
        priority: 1,
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        updatedAt: DateTime.now(),
        createdBy: 'admin',
        updatedBy: 'admin',
        metadata: {
          'clicks': 1250,
          'impressions': 15000,
        },
      ),
    ];

    for (final item in content) {
      await _firestore.collection('admin_content').doc(item.id).set(item.toJson());
      print('✅ Created content: ${item.title}');
    }
  }

  // Create test users
  static Future<void> _createTestUsers() async {
    final users = [
      AdminUser(
        id: 'user_1',
        email: 'admin@lcmtv.com',
        displayName: 'Admin User',
        role: 'admin',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastLogin: DateTime.now().subtract(const Duration(hours: 2)),
        permissions: ['manage_content', 'manage_users', 'manage_categories'],
      ),
      AdminUser(
        id: 'user_2',
        email: 'moderator@lcmtv.com',
        displayName: 'Moderator User',
        role: 'moderator',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        lastLogin: DateTime.now().subtract(const Duration(hours: 5)),
        permissions: ['manage_content', 'manage_categories'],
      ),
      AdminUser(
        id: 'user_3',
        email: 'editor@lcmtv.com',
        displayName: 'Editor User',
        role: 'editor',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        lastLogin: DateTime.now().subtract(const Duration(hours: 1)),
        permissions: ['manage_content'],
      ),
      AdminUser(
        id: 'user_4',
        email: 'inactive@lcmtv.com',
        displayName: 'Inactive User',
        role: 'editor',
        isActive: false,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        lastLogin: DateTime.now().subtract(const Duration(days: 7)),
        permissions: ['manage_content'],
      ),
    ];

    for (final user in users) {
      await _firestore.collection('admin_users').doc(user.id).set(user.toJson());
      print('✅ Created user: ${user.displayName}');
    }
  }

  // Clear all test data
  static Future<void> clearTestData() async {
    print('🔵 Clearing Firestore test data...');
    
    try {
      // Clear categories
      final categoriesSnapshot = await _firestore.collection('admin_categories').get();
      for (final doc in categoriesSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Clear content
      final contentSnapshot = await _firestore.collection('admin_content').get();
      for (final doc in contentSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Clear users
      final usersSnapshot = await _firestore.collection('admin_users').get();
      for (final doc in usersSnapshot.docs) {
        await doc.reference.delete();
      }
      
      print('✅ Firestore test data cleared successfully');
    } catch (e) {
      print('❌ Error clearing Firestore test data: $e');
      rethrow;
    }
  }

  // Add sample content
  static Future<void> addSampleContent() async {
    final sampleContent = AdminContent(
      id: 'sample_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Sample Video ${DateTime.now().millisecondsSinceEpoch}',
      description: 'This is a sample video created for testing',
      type: 'video',
      videoId: 'dQw4w9WgXcQ',
      categoryId: 'cat_1',
      thumbnailUrl: 'https://picsum.photos/seed/sample/400/300',
      imageUrl: 'https://picsum.photos/seed/sample/800/600',
      isActive: true,
      isFeatured: false,
      priority: 10,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy: 'admin',
      updatedBy: 'admin',
      metadata: {
        'views': 0,
        'likes': 0,
        'comments': 0,
      },
    );

    await _firestore.collection('admin_content').doc(sampleContent.id).set(sampleContent.toJson());
    print('✅ Added sample content: ${sampleContent.title}');
  }

  // Get data statistics
  static Future<Map<String, int>> getDataStatistics() async {
    try {
      final categoriesCount = (await _firestore.collection('admin_categories').get()).docs.length;
      final contentCount = (await _firestore.collection('admin_content').get()).docs.length;
      final usersCount = (await _firestore.collection('admin_users').get()).docs.length;
      
      return {
        'categories': categoriesCount,
        'content': contentCount,
        'users': usersCount,
      };
    } catch (e) {
      print('❌ Error getting data statistics: $e');
      return {'categories': 0, 'content': 0, 'users': 0};
    }
  }
}
