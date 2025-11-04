import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/admin_content_model.dart';
import '../cubit/admin_cubit.dart';
import '../widgets/admin_content_list.dart';
import '../widgets/content_form_dialog.dart';
import '../widgets/admin_search_bar.dart';

class ContentManagementScreen extends StatefulWidget {
  const ContentManagementScreen({super.key});

  @override
  State<ContentManagementScreen> createState() => _ContentManagementScreenState();
}

class _ContentManagementScreenState extends State<ContentManagementScreen> {
  String _searchQuery = '';
  String _selectedType = 'all';
  bool _showActiveOnly = true;
  List<String> _selectedContentIds = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        if (state is AdminLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AdminLoaded) {
          // Filter content based on search and filters
          List<AdminContent> filteredContent = state.content;
          
          if (_searchQuery.isNotEmpty) {
            filteredContent = filteredContent.where((content) =>
              content.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              content.description.toLowerCase().contains(_searchQuery.toLowerCase())
            ).toList();
          }
          
          if (_selectedType != 'all') {
            filteredContent = filteredContent.where((content) =>
              content.type == _selectedType
            ).toList();
          }
          
          if (_showActiveOnly) {
            filteredContent = filteredContent.where((content) =>
              content.isActive
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
                        'Content Management',
                        style: AppTheme.headingLarge.copyWith(
                          color: AppTheme.textDark,
                        ),
                      ),
                    ),
                    if (_selectedContentIds.isNotEmpty) ...[
                      Text(
                        '${_selectedContentIds.length} selected',
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
                        _showCreateContentDialog(context);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Content'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Search and Filters
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Column(
                  children: [
                    // Search Bar
                    AdminSearchBar(
                      onSearchChanged: (query) {
                        setState(() {
                          _searchQuery = query;
                        });
                      },
                      hintText: 'Search content...',
                    ),
                    const SizedBox(height: AppTheme.spacingL),

                    // Filters
                    Row(
                      children: [
                        // Type Filter
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedType,
                            decoration: const InputDecoration(
                              labelText: 'Content Type',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'all', child: Text('All Types')),
                              DropdownMenuItem(value: 'video', child: Text('Video')),
                              DropdownMenuItem(value: 'category', child: Text('Category')),
                              DropdownMenuItem(value: 'featured', child: Text('Featured')),
                              DropdownMenuItem(value: 'banner', child: Text('Banner')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value ?? 'all';
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingM),

                        // Active Only Filter
                        Expanded(
                          child: Row(
                            children: [
                              Checkbox(
                                value: _showActiveOnly,
                                onChanged: (value) {
                                  setState(() {
                                    _showActiveOnly = value ?? true;
                                  });
                                },
                                activeColor: AppTheme.primaryPurple,
                              ),
                              const Text('Active Only'),
                            ],
                          ),
                        ),

                        // Clear Filters
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                              _selectedType = 'all';
                              _showActiveOnly = true;
                              _selectedContentIds.clear();
                            });
                          },
                          child: const Text('Clear Filters'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content List
              Expanded(
                child: AdminContentList(
                  content: filteredContent,
                  showActions: true,
                  onContentTap: (content) {
                    _showEditContentDialog(context, content);
                  },
                  onContentSelected: (contentId, isSelected) {
                    setState(() {
                      if (isSelected) {
                        _selectedContentIds.add(contentId);
                      } else {
                        _selectedContentIds.remove(contentId);
                      }
                    });
                  },
                  selectedContentIds: _selectedContentIds,
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
                  'Error loading content',
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

  void _showCreateContentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ContentFormDialog(
        onSave: (content) {
          context.read<AdminCubit>().createContent(content);
        },
      ),
    );
  }

  void _showEditContentDialog(BuildContext context, AdminContent content) {
    showDialog(
      context: context,
      builder: (context) => ContentFormDialog(
        content: content,
        onSave: (updatedContent) {
          context.read<AdminCubit>().updateContent(updatedContent);
        },
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
                _showDeleteConfirmation(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.visibility, color: Colors.green),
              title: const Text('Activate Selected'),
              onTap: () {
                Navigator.of(context).pop();
                _activateSelectedContent();
              },
            ),
            ListTile(
              leading: const Icon(Icons.visibility_off, color: Colors.orange),
              title: const Text('Deactivate Selected'),
              onTap: () {
                Navigator.of(context).pop();
                _deactivateSelectedContent();
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

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Content'),
        content: Text(
          'Are you sure you want to delete ${_selectedContentIds.length} content items? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AdminCubit>().bulkDeleteContent(_selectedContentIds);
              setState(() {
                _selectedContentIds.clear();
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

  void _activateSelectedContent() {
    // Implementation for activating selected content
    setState(() {
      _selectedContentIds.clear();
    });
  }

  void _deactivateSelectedContent() {
    // Implementation for deactivating selected content
    setState(() {
      _selectedContentIds.clear();
    });
  }
}
