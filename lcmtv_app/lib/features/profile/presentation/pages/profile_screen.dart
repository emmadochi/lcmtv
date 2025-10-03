import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Sample user data
  final String _userName = 'John Doe';
  final String _userEmail = 'john.doe@example.com';
  final String _userAvatar = 'https://via.placeholder.com/100x100/6B46C1/FFFFFF?text=JD';
  final int _subscribersCount = 1250;
  final int _videosCount = 45;
  final int _playlistsCount = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _navigateToSettings();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: const BoxDecoration(
                color: AppTheme.backgroundWhite,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppTheme.radiusL),
                  bottomRight: Radius.circular(AppTheme.radiusL),
                ),
              ),
              child: Column(
                children: [
                  // Avatar
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppTheme.primaryPurple,
                        backgroundImage: NetworkImage(_userAvatar),
                        onBackgroundImageError: (exception, stackTrace) {
                          // Handle image error
                        },
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: AppTheme.backgroundWhite,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryPurple,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.backgroundWhite,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: AppTheme.backgroundWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // User Info
                  Text(
                    _userName,
                    style: AppTheme.headingMedium.copyWith(
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    _userEmail,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textLight,
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('Subscribers', _subscribersCount.toString()),
                      _buildStatItem('Videos', _videosCount.toString()),
                      _buildStatItem('Playlists', _playlistsCount.toString()),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Edit Profile Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _navigateToEditProfile();
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Menu Items
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
              decoration: BoxDecoration(
                color: AppTheme.backgroundWhite,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.history,
                    title: 'Watch History',
                    subtitle: 'View your watch history',
                    onTap: () => _navigateToWatchHistory(),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.playlist_play,
                    title: 'My Playlists',
                    subtitle: 'Manage your playlists',
                    onTap: () => _navigateToPlaylists(),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.favorite,
                    title: 'Liked Videos',
                    subtitle: 'Videos you liked',
                    onTap: () => _navigateToLikedVideos(),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.download,
                    title: 'Downloads',
                    subtitle: 'Downloaded videos',
                    onTap: () => _navigateToDownloads(),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Settings Menu
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
              decoration: BoxDecoration(
                color: AppTheme.backgroundWhite,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Manage notification settings',
                    onTap: () => _navigateToNotifications(),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.privacy_tip,
                    title: 'Privacy',
                    subtitle: 'Privacy and security settings',
                    onTap: () => _navigateToPrivacy(),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.help,
                    title: 'Help & Support',
                    subtitle: 'Get help and support',
                    onTap: () => _navigateToHelp(),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.info,
                    title: 'About',
                    subtitle: 'App version and information',
                    onTap: () => _navigateToAbout(),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Logout Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorRed,
                  foregroundColor: AppTheme.backgroundWhite,
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingXL),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.headingSmall.copyWith(
            color: AppTheme.primaryPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingXS),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.textLight,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primaryPurple.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusS),
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryPurple,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.bodyLarge.copyWith(
          color: AppTheme.textDark,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.bodyMedium.copyWith(
          color: AppTheme.textLight,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppTheme.textLight,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 72,
      color: AppTheme.lightGray,
    );
  }

  void _navigateToEditProfile() {
    Navigator.pushNamed(context, '/edit-profile');
  }

  void _navigateToSettings() {
    // Navigate to settings screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings - Coming Soon'),
        backgroundColor: AppTheme.primaryPurple,
      ),
    );
  }

  void _navigateToWatchHistory() {
    Navigator.pushNamed(context, '/watch-history');
  }

  void _navigateToPlaylists() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('My Playlists - Coming Soon'),
        backgroundColor: AppTheme.primaryPurple,
      ),
    );
  }

  void _navigateToLikedVideos() {
    Navigator.pushNamed(context, '/liked-videos');
  }

  void _navigateToDownloads() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Downloads - Coming Soon'),
        backgroundColor: AppTheme.primaryPurple,
      ),
    );
  }

  void _navigateToNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifications - Coming Soon'),
        backgroundColor: AppTheme.primaryPurple,
      ),
    );
  }

  void _navigateToPrivacy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy - Coming Soon'),
        backgroundColor: AppTheme.primaryPurple,
      ),
    );
  }

  void _navigateToHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Help & Support - Coming Soon'),
        backgroundColor: AppTheme.primaryPurple,
      ),
    );
  }

  void _navigateToAbout() {
    Navigator.pushNamed(context, '/about');
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
