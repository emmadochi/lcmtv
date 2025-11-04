import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/admin_content_model.dart';
import '../cubit/admin_cubit.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _searchQuery = '';
  String _selectedRole = 'all';
  List<String> _selectedUserIds = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        if (state is AdminLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AdminLoaded) {
          // Filter users based on search and role
          List<AdminUser> filteredUsers = state.users;
          
          if (_searchQuery.isNotEmpty) {
            filteredUsers = filteredUsers.where((user) =>
              user.displayName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              user.email.toLowerCase().contains(_searchQuery.toLowerCase())
            ).toList();
          }
          
          if (_selectedRole != 'all') {
            filteredUsers = filteredUsers.where((user) =>
              user.role == _selectedRole
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
                        'User Management',
                        style: AppTheme.headingLarge.copyWith(
                          color: AppTheme.textDark,
                        ),
                      ),
                    ),
                    if (_selectedUserIds.isNotEmpty) ...[
                      Text(
                        '${_selectedUserIds.length} selected',
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
                        _showCreateUserDialog(context);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add User'),
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
                child: Row(
                  children: [
                    // Search Field
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search users...',
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
                    const SizedBox(width: AppTheme.spacingL),
                    
                    // Role Filter
                    SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All Roles')),
                          DropdownMenuItem(value: 'admin', child: Text('Admin')),
                          DropdownMenuItem(value: 'moderator', child: Text('Moderator')),
                          DropdownMenuItem(value: 'editor', child: Text('Editor')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value ?? 'all';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Users List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppTheme.spacingL),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    final isSelected = _selectedUserIds.contains(user.id);
                    
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
                                      _selectedUserIds.add(user.id);
                                    } else {
                                      _selectedUserIds.remove(user.id);
                                    }
                                  });
                                },
                                activeColor: AppTheme.primaryPurple,
                              ),
                            CircleAvatar(
                              backgroundColor: _getRoleColor(user.role),
                              child: Text(
                                user.displayName.isNotEmpty 
                                    ? user.displayName[0].toUpperCase()
                                    : 'U',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          user.displayName,
                          style: AppTheme.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.email,
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textLight,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingS),
                            Row(
                              children: [
                                _buildRoleChip(user.role),
                                const SizedBox(width: AppTheme.spacingS),
                                _buildStatusChip(user.isActive),
                                const SizedBox(width: AppTheme.spacingS),
                                _buildLastLoginChip(user.lastLogin),
                              ],
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            switch (value) {
                              case 'edit':
                                _showEditUserDialog(context, user);
                                break;
                              case 'delete':
                                _showDeleteUserDialog(context, user);
                                break;
                              case 'toggle_active':
                                _toggleUserActive(user);
                                break;
                              case 'change_role':
                                _showChangeRoleDialog(context, user);
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
                                    user.isActive ? Icons.visibility_off : Icons.visibility,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(user.isActive ? 'Deactivate' : 'Activate'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'change_role',
                              child: Row(
                                children: [
                                  Icon(Icons.admin_panel_settings, size: 20),
                                  SizedBox(width: 8),
                                  Text('Change Role'),
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
                          _showEditUserDialog(context, user);
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
                  'Error loading users',
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

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'moderator':
        return Colors.orange;
      case 'editor':
        return Colors.blue;
      default:
        return AppTheme.textLight;
    }
  }

  Widget _buildRoleChip(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _getRoleColor(role).withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      child: Text(
        role.toUpperCase(),
        style: AppTheme.bodySmall.copyWith(
          color: _getRoleColor(role),
          fontWeight: FontWeight.bold,
        ),
      ),
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

  Widget _buildLastLoginChip(DateTime lastLogin) {
    final now = DateTime.now();
    final difference = now.difference(lastLogin);
    final days = difference.inDays;
    
    String text;
    Color color;
    
    if (days == 0) {
      text = 'Today';
      color = Colors.green;
    } else if (days == 1) {
      text = 'Yesterday';
      color = Colors.orange;
    } else if (days < 7) {
      text = '$days days ago';
      color = Colors.orange;
    } else {
      text = '$days days ago';
      color = Colors.red;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      child: Text(
        text,
        style: AppTheme.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showCreateUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create User'),
        content: const Text('User creation form would go here'),
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

  void _showEditUserDialog(BuildContext context, AdminUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit User'),
        content: Text('Edit form for ${user.displayName} would go here'),
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

  void _showDeleteUserDialog(BuildContext context, AdminUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete "${user.displayName}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AdminCubit>().deleteUser(user.id);
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

  void _showChangeRoleDialog(BuildContext context, AdminUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Role'),
        content: Text('Change role for ${user.displayName}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Change'),
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
                _activateSelectedUsers();
              },
            ),
            ListTile(
              leading: const Icon(Icons.visibility_off, color: Colors.orange),
              title: const Text('Deactivate Selected'),
              onTap: () {
                Navigator.of(context).pop();
                _deactivateSelectedUsers();
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
        title: const Text('Delete Users'),
        content: Text(
          'Are you sure you want to delete ${_selectedUserIds.length} users? This action cannot be undone.',
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
                _selectedUserIds.clear();
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

  void _toggleUserActive(AdminUser user) {
    // Implementation for toggling user active status
  }

  void _activateSelectedUsers() {
    // Implementation for activating selected users
    setState(() {
      _selectedUserIds.clear();
    });
  }

  void _deactivateSelectedUsers() {
    // Implementation for deactivating selected users
    setState(() {
      _selectedUserIds.clear();
    });
  }
}
