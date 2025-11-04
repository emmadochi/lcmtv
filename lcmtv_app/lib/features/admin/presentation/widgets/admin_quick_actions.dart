import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AdminQuickActions extends StatelessWidget {
  const AdminQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: AppTheme.headingMedium.copyWith(
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            Wrap(
              spacing: AppTheme.spacingM,
              runSpacing: AppTheme.spacingM,
              children: [
                _buildActionButton(
                  icon: Icons.add,
                  label: 'Add Content',
                  color: AppTheme.primaryPurple,
                  onTap: () {
                    // Navigate to add content
                  },
                ),
                _buildActionButton(
                  icon: Icons.category,
                  label: 'Manage Categories',
                  color: Colors.blue,
                  onTap: () {
                    // Navigate to categories
                  },
                ),
                _buildActionButton(
                  icon: Icons.people,
                  label: 'Manage Users',
                  color: Colors.green,
                  onTap: () {
                    // Navigate to users
                  },
                ),
                _buildActionButton(
                  icon: Icons.analytics,
                  label: 'View Analytics',
                  color: Colors.orange,
                  onTap: () {
                    // Navigate to analytics
                  },
                ),
                _buildActionButton(
                  icon: Icons.settings,
                  label: 'Settings',
                  color: AppTheme.textLight,
                  onTap: () {
                    // Navigate to settings
                  },
                ),
                _buildActionButton(
                  icon: Icons.backup,
                  label: 'Backup Data',
                  color: Colors.purple,
                  onTap: () {
                    // Show backup dialog
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingL,
          vertical: AppTheme.spacingM,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: AppTheme.spacingS),
            Text(
              label,
              style: AppTheme.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
