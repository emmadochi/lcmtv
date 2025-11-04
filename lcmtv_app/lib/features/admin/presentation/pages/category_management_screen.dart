import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/admin_content_model.dart';
import '../cubit/admin_cubit.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  String _searchQuery = '';
  List<String> _selectedCategoryIds = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        if (state is AdminLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AdminLoaded) {
          // Filter categories based on search
          List<AdminCategory> filteredCategories = state.categories;
          
          if (_searchQuery.isNotEmpty) {
            filteredCategories = filteredCategories.where((category) =>
              category.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              category.description.toLowerCase().contains(_searchQuery.toLowerCase())
            ).toList();
          }

          return Column(
            children: [
              // Header with Actions
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundLight,
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.borderLight,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Category Management',
                        style: AppTheme.headingLarge.copyWith(
                          color: AppTheme.textDark,
                        ),
                      ),
                    ),
                    if (_selectedCategoryIds.isNotEmpty) ...[
                      Text(
                        '${_selectedCategoryIds.length} selected',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textLight,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      ElevatedButton.icon(
                        onPressed: () {
                          _showBulkActionsDialog(context);
                        },
                        icon: const Icon(Icons.more_vert),
                        label: const Text('Bulk Actions'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryPurple,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                    ],
                    ElevatedButton.icon(
                      onPressed: () {
                        _showCreateCategoryDialog(context);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Category'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search categories...',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                  ),
                ),
              ),

              // Categories List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppTheme.spacingL),
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index];
                    final isSelected = _selectedCategoryIds.contains(category.id);
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                      child: ListTile(
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (true) // Show checkbox if bulk selection is enabled
                              Checkbox(
                                value: isSelected,
                                onChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      _selectedCategoryIds.add(category.id);
                                    } else {
                                      _selectedCategoryIds.remove(category.id);
                                    }
                                  });
                                },
                                activeColor: AppTheme.primaryPurple,
                              ),
                            CircleAvatar(
                              backgroundColor: category.color != null 
                                  ? Color(int.parse(category.color!.replaceFirst('#', '0xff')))
                                  : AppTheme.primaryPurple,
                              child: const Icon(Icons.category, color: Colors.white),
                            ),
                          ],
                        ),
                        title: Text(
                          category.name,
                          style: AppTheme.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.description,
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textLight,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingS),
                            Row(
                              children: [
                                _buildStatusChip(category.isActive),
                                const SizedBox(width: AppTheme.spacingS),
                                _buildPriorityChip(category.priority),
                                if (category.parentId != null) ...[
                                  const SizedBox(width: AppTheme.spacingS),
                                  _buildParentChip(category.parentId!),
                                ],
                              ],
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            switch (value) {
                              case 'edit':
                                _showEditCategoryDialog(context, category);
                                break;
                              case 'delete':
                                _showDeleteCategoryDialog(context, category);
                                break;
                              case 'toggle_active':
                                _toggleCategoryActive(category);
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 20),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'toggle_active',
                              child: Row(
                                children: [
                                  Icon(
                                    category.isActive ? Icons.visibility_off : Icons.visibility,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(category.isActive ? 'Deactivate' : 'Activate'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: AppTheme.errorRed, size: 20),
                                  SizedBox(width: 8),
                                  Text('Delete', style: TextStyle(color: AppTheme.errorRed)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          _showEditCategoryDialog(context, category);
                        },
                        selected: isSelected,
                        selectedTileColor: AppTheme.primaryPurple.withOpacity(0.1),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is AdminError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppTheme.errorRed,
                ),
                const SizedBox(height: AppTheme.spacingL),
                Text(
                  'Error loading categories',
                  style: AppTheme.headingMedium.copyWith(
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  state.message,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingL),
                ElevatedButton(
                  onPressed: () {
                    context.read<AdminCubit>().loadAdminData();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return const Center(child: Text('Unknown state'));
      },
    );
  }

  Widget _buildStatusChip(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: AppTheme.bodySmall.copyWith(
          color: isActive ? Colors.green.shade700 : Colors.red.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPriorityChip(int priority) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      child: Text(
        'Priority: $priority',
        style: AppTheme.bodySmall.copyWith(
          color: Colors.blue.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildParentChip(String parentId) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      child: Text(
        'Parent: $parentId',
        style: AppTheme.bodySmall.copyWith(
          color: Colors.orange.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showCreateCategoryDialog(BuildContext context) {
    // Implementation for create category dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Category'),
        content: const Text('Category creation form would go here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditCategoryDialog(BuildContext context, AdminCategory category) {
    // Implementation for edit category dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Category'),
        content: Text('Edit form for ${category.name} would go here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteCategoryDialog(BuildContext context, AdminCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AdminCubit>().deleteCategory(category.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showBulkActionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Actions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete, color: AppTheme.errorRed),
              title: const Text('Delete Selected'),
              onTap: () {
                Navigator.of(context).pop();
                _showBulkDeleteConfirmation(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.visibility, color: Colors.green),
              title: const Text('Activate Selected'),
              onTap: () {
                Navigator.of(context).pop();
                _activateSelectedCategories();
              },
            ),
            ListTile(
              leading: const Icon(Icons.visibility_off, color: Colors.orange),
              title: const Text('Deactivate Selected'),
              onTap: () {
                Navigator.of(context).pop();
                _deactivateSelectedCategories();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showBulkDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Categories'),
        content: Text(
          'Are you sure you want to delete ${_selectedCategoryIds.length} categories? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Implement bulk delete
              setState(() {
                _selectedCategoryIds.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _toggleCategoryActive(AdminCategory category) {
    // Implementation for toggling category active status
  }

  void _activateSelectedCategories() {
    // Implementation for activating selected categories
    setState(() {
      _selectedCategoryIds.clear();
    });
  }

  void _deactivateSelectedCategories() {
    // Implementation for deactivating selected categories
    setState(() {
      _selectedCategoryIds.clear();
    });
  }
}
