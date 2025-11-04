import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/models/admin_content_model.dart';
import '../../domain/repositories/admin_repository.dart';

// States
abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminLoaded extends AdminState {
  final List<AdminContent> content;
  final List<AdminCategory> categories;
  final List<AdminUser> users;
  final Map<String, dynamic> statistics;

  const AdminLoaded({
    required this.content,
    required this.categories,
    required this.users,
    required this.statistics,
  });

  @override
  List<Object?> get props => [content, categories, users, statistics];

  AdminLoaded copyWith({
    List<AdminContent>? content,
    List<AdminCategory>? categories,
    List<AdminUser>? users,
    Map<String, dynamic>? statistics,
  }) {
    return AdminLoaded(
      content: content ?? this.content,
      categories: categories ?? this.categories,
      users: users ?? this.users,
      statistics: statistics ?? this.statistics,
    );
  }
}

class AdminError extends AdminState {
  final String message;

  const AdminError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AdminContentCreated extends AdminState {
  final AdminContent content;

  const AdminContentCreated({required this.content});

  @override
  List<Object?> get props => [content];
}

class AdminContentUpdated extends AdminState {
  final AdminContent content;

  const AdminContentUpdated({required this.content});

  @override
  List<Object?> get props => [content];
}

class AdminContentDeleted extends AdminState {
  final String contentId;

  const AdminContentDeleted({required this.contentId});

  @override
  List<Object?> get props => [contentId];
}

// Cubit
class AdminCubit extends Cubit<AdminState> {
  final AdminRepository _adminRepository;

  AdminCubit({required AdminRepository adminRepository})
      : _adminRepository = adminRepository,
        super(AdminInitial());

  // Load all admin data
  Future<void> loadAdminData() async {
    emit(AdminLoading());
    try {
      final content = await _adminRepository.getAllContent();
      final categories = await _adminRepository.getAllCategories();
      final users = await _adminRepository.getAllUsers();
      final statistics = await _adminRepository.getContentStatistics();

      emit(AdminLoaded(
        content: content,
        categories: categories,
        users: users,
        statistics: statistics,
      ));
    } catch (e) {
      emit(AdminError(message: 'Failed to load admin data: $e'));
    }
  }

  // Content CRUD Operations
  Future<void> createContent(AdminContent content) async {
    try {
      final createdContent = await _adminRepository.createContent(content);
      emit(AdminContentCreated(content: createdContent));
      
      // Reload data to get updated list
      await loadAdminData();
    } catch (e) {
      emit(AdminError(message: 'Failed to create content: $e'));
    }
  }

  Future<void> updateContent(AdminContent content) async {
    try {
      final updatedContent = await _adminRepository.updateContent(content);
      emit(AdminContentUpdated(content: updatedContent));
      
      // Reload data to get updated list
      await loadAdminData();
    } catch (e) {
      emit(AdminError(message: 'Failed to update content: $e'));
    }
  }

  Future<void> deleteContent(String contentId) async {
    try {
      await _adminRepository.deleteContent(contentId);
      emit(AdminContentDeleted(contentId: contentId));
      
      // Reload data to get updated list
      await loadAdminData();
    } catch (e) {
      emit(AdminError(message: 'Failed to delete content: $e'));
    }
  }

  // Category CRUD Operations
  Future<void> createCategory(AdminCategory category) async {
    try {
      await _adminRepository.createCategory(category);
      await loadAdminData();
    } catch (e) {
      emit(AdminError(message: 'Failed to create category: $e'));
    }
  }

  Future<void> updateCategory(AdminCategory category) async {
    try {
      await _adminRepository.updateCategory(category);
      await loadAdminData();
    } catch (e) {
      emit(AdminError(message: 'Failed to update category: $e'));
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _adminRepository.deleteCategory(categoryId);
      await loadAdminData();
    } catch (e) {
      emit(AdminError(message: 'Failed to delete category: $e'));
    }
  }

  // User Management
  Future<void> deleteUser(String userId) async {
    try {
      await _adminRepository.deleteUser(userId);
      await loadAdminData();
    } catch (e) {
      emit(AdminError(message: 'Failed to delete user: $e'));
    }
  }

  // Search and Filter
  Future<void> searchContent(String query) async {
    try {
      final searchResults = await _adminRepository.searchContent(query);
      if (state is AdminLoaded) {
        final currentState = state as AdminLoaded;
        emit(currentState.copyWith(content: searchResults));
      }
    } catch (e) {
      emit(AdminError(message: 'Failed to search content: $e'));
    }
  }

  Future<void> filterContentByType(String type) async {
    try {
      final filteredContent = await _adminRepository.getContentByType(type);
      if (state is AdminLoaded) {
        final currentState = state as AdminLoaded;
        emit(currentState.copyWith(content: filteredContent));
      }
    } catch (e) {
      emit(AdminError(message: 'Failed to filter content: $e'));
    }
  }

  // Bulk Operations
  Future<void> bulkDeleteContent(List<String> contentIds) async {
    try {
      await _adminRepository.bulkDeleteContent(contentIds);
      await loadAdminData();
    } catch (e) {
      emit(AdminError(message: 'Failed to bulk delete content: $e'));
    }
  }

  Future<void> bulkUpdateContent(List<AdminContent> contentList) async {
    try {
      await _adminRepository.bulkUpdateContent(contentList);
      await loadAdminData();
    } catch (e) {
      emit(AdminError(message: 'Failed to bulk update content: $e'));
    }
  }

  // Statistics
  Future<void> loadStatistics() async {
    try {
      final statistics = await _adminRepository.getContentStatistics();
      if (state is AdminLoaded) {
        final currentState = state as AdminLoaded;
        emit(currentState.copyWith(statistics: statistics));
      }
    } catch (e) {
      emit(AdminError(message: 'Failed to load statistics: $e'));
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadAdminData();
  }
}
