import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/admin_content_model.dart';
import '../cubit/admin_cubit.dart';
import '../widgets/admin_content_list.dart';
import '../widgets/admin_statistics_card.dart';
import '../widgets/admin_quick_actions.dart';
import 'content_management_screen.dart';
import 'category_management_screen.dart';
import 'user_management_screen.dart';
import 'test_data_management_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const AdminHomeScreen(),
    const ContentManagementScreen(),
    const CategoryManagementScreen(),
    const UserManagementScreen(),
    const TestDataManagementScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load admin data when dashboard initializes
    context.read<AdminCubit>().loadAdminData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppTheme.primaryPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AdminCubit>().refreshData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Handle logout
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: BlocListener<AdminCubit, AdminState>(
        listener: (context, state) {
          if (state is AdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.errorRed,
              ),
            );
          }
        },
        child: Row(
          children: [
            // Sidebar Navigation
            Container(
              width: 250,
              color: AppTheme.backgroundLight,
              child: Column(
                children: [
                  const SizedBox(height: AppTheme.spacingL),
                  _buildNavItem(
                    icon: Icons.dashboard,
                    title: 'Dashboard',
                    index: 0,
                  ),
                  _buildNavItem(
                    icon: Icons.video_library,
                    title: 'Content',
                    index: 1,
                  ),
                  _buildNavItem(
                    icon: Icons.category,
                    title: 'Categories',
                    index: 2,
                  ),
                  _buildNavItem(
                    icon: Icons.people,
                    title: 'Users',
                    index: 3,
                  ),
                  _buildNavItem(
                    icon: Icons.data_usage,
                    title: 'Test Data',
                    index: 4,
                  ),
                  const Spacer(),
                  _buildNavItem(
                    icon: Icons.settings,
                    title: 'Settings',
                    index: 5,
                    isLast: true,
                  ),
                ],
              ),
            ),
            // Main Content
            Expanded(
              child: _screens[_selectedIndex],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required int index,
    bool isLast = false,
  }) {
    final isSelected = _selectedIndex == index;
    
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppTheme.primaryPurple : AppTheme.textLight,
        ),
        title: Text(
          title,
          style: AppTheme.bodyMedium.copyWith(
            color: isSelected ? AppTheme.primaryPurple : AppTheme.textDark,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedTileColor: AppTheme.primaryPurple.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        if (state is AdminLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AdminLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                Text(
                  'Welcome to Admin Dashboard',
                  style: AppTheme.headingLarge.copyWith(
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  'Manage your content, categories, and users',
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.textLight,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXXL),

                // Statistics Cards
                Row(
                  children: [
                    Expanded(
                      child: AdminStatisticsCard(
                        title: 'Total Content',
                        value: state.content.length.toString(),
                        icon: Icons.video_library,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: AdminStatisticsCard(
                        title: 'Categories',
                        value: state.categories.length.toString(),
                        icon: Icons.category,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: AdminStatisticsCard(
                        title: 'Users',
                        value: state.users.length.toString(),
                        icon: Icons.people,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: AdminStatisticsCard(
                        title: 'Active Content',
                        value: state.content.where((c) => c.isActive).length.toString(),
                        icon: Icons.check_circle,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingXXL),

                // Quick Actions
                AdminQuickActions(),
                const SizedBox(height: AppTheme.spacingXXL),

                // Recent Content
                Text(
                  'Recent Content',
                  style: AppTheme.headingMedium.copyWith(
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingL),
                AdminContentList(
                  content: state.content.take(5).toList(),
                  showActions: false,
                ),
              ],
            ),
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
                  'Error loading admin data',
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
}
