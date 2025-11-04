import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/admin_content_model.dart';

class AdminContentList extends StatelessWidget {
  final List<AdminContent> content;
  final bool showActions;
  final Function(AdminContent)? onContentTap;
  final Function(String, bool)? onContentSelected;
  final List<String> selectedContentIds;

  const AdminContentList({
    super.key,
    required this.content,
    this.showActions = true,
    this.onContentTap,
    this.onContentSelected,
    this.selectedContentIds = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (content.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 64,
              color: AppTheme.textLight,
            ),
            SizedBox(height: AppTheme.spacingL),
            Text(
              'No content found',
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.textLight,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      itemCount: content.length,
      itemBuilder: (context, index) {
        final item = content[index];
        final isSelected = selectedContentIds.contains(item.id);
        
        return Card(
          margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
          child: ListTile(
            leading: _buildLeadingWidget(item, isSelected),
            title: Text(
              item.title,
              style: AppTheme.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textLight,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
                Row(
                  children: [
                    _buildStatusChip(item.isActive),
                    const SizedBox(width: AppTheme.spacingS),
                    _buildTypeChip(item.type),
                    if (item.isFeatured) ...[
                      const SizedBox(width: AppTheme.spacingS),
                      _buildFeaturedChip(),
                    ],
                  ],
                ),
              ],
            ),
            trailing: showActions ? _buildTrailingWidget(context, item) : null,
            onTap: () {
              if (onContentSelected != null) {
                onContentSelected!(item.id, !isSelected);
              } else if (onContentTap != null) {
                onContentTap!(item);
              }
            },
            selected: isSelected,
            selectedTileColor: AppTheme.primaryPurple.withOpacity(0.1),
          ),
        );
      },
    );
  }

  Widget _buildLeadingWidget(AdminContent item, bool isSelected) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onContentSelected != null)
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              onContentSelected!(item.id, value ?? false);
            },
            activeColor: AppTheme.primaryPurple,
          ),
        CircleAvatar(
          backgroundColor: _getTypeColor(item.type),
          child: Icon(
            _getTypeIcon(item.type),
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildTrailingWidget(BuildContext context, AdminContent item) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'edit':
            if (onContentTap != null) {
              onContentTap!(item);
            }
            break;
          case 'delete':
            _showDeleteDialog(context, item);
            break;
          case 'toggle_active':
            _toggleActiveStatus(context, item);
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
                item.isActive ? Icons.visibility_off : Icons.visibility,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(item.isActive ? 'Deactivate' : 'Activate'),
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

  Widget _buildTypeChip(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _getTypeColor(type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      child: Text(
        type.toUpperCase(),
        style: AppTheme.bodySmall.copyWith(
          color: _getTypeColor(type),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFeaturedChip() {
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
        'FEATURED',
        style: AppTheme.bodySmall.copyWith(
          color: Colors.orange.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'video':
        return Colors.blue;
      case 'category':
        return Colors.green;
      case 'featured':
        return Colors.orange;
      case 'banner':
        return Colors.purple;
      default:
        return AppTheme.textLight;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'video':
        return Icons.video_library;
      case 'category':
        return Icons.category;
      case 'featured':
        return Icons.star;
      case 'banner':
        return Icons.image;
      default:
        return Icons.content_copy;
    }
  }

  void _showDeleteDialog(BuildContext context, AdminContent item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Content'),
        content: Text('Are you sure you want to delete "${item.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // This would need to be connected to the AdminCubit
              // context.read<AdminCubit>().deleteContent(item.id);
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

  void _toggleActiveStatus(BuildContext context, AdminContent item) {
    // This would need to be connected to the AdminCubit
    // context.read<AdminCubit>().updateContent(item.copyWith(isActive: !item.isActive));
  }
}
