import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// Custom Floating Action Button
class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;

  const CustomFloatingActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? AppTheme.primaryPurple,
      foregroundColor: foregroundColor ?? AppTheme.backgroundWhite,
      elevation: elevation ?? 6,
      child: Icon(icon),
    );
  }
}

// Extended Floating Action Button
class ExtendedFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;

  const ExtendedFloatingActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? AppTheme.primaryPurple,
      foregroundColor: foregroundColor ?? AppTheme.backgroundWhite,
      elevation: elevation ?? 6,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

// Speed Dial Floating Action Button
class SpeedDialFloatingActionButton extends StatefulWidget {
  final List<SpeedDialAction> actions;
  final IconData icon;
  final IconData? activeIcon;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;

  const SpeedDialFloatingActionButton({
    super.key,
    required this.actions,
    this.icon = Icons.add,
    this.activeIcon,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor = AppTheme.backgroundWhite,
    this.elevation,
  });

  @override
  State<SpeedDialFloatingActionButton> createState() => _SpeedDialFloatingActionButtonState();
}

class _SpeedDialFloatingActionButtonState extends State<SpeedDialFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Action buttons
        ...widget.actions.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: Opacity(
                  opacity: _animation.value,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: action.onPressed,
                      tooltip: action.tooltip,
                      backgroundColor: action.backgroundColor ?? AppTheme.backgroundWhite,
                      foregroundColor: action.foregroundColor ?? AppTheme.textDark,
                      elevation: 4,
                      child: Icon(action.icon),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
        // Main button
        FloatingActionButton(
          onPressed: _toggle,
          tooltip: widget.tooltip,
          backgroundColor: widget.backgroundColor ?? AppTheme.primaryPurple,
          foregroundColor: widget.foregroundColor,
          elevation: widget.elevation ?? 6,
          child: AnimatedRotation(
            turns: _isOpen ? 0.125 : 0,
            duration: const Duration(milliseconds: 300),
            child: Icon(_isOpen ? (widget.activeIcon ?? Icons.close) : widget.icon),
          ),
        ),
      ],
    );
  }
}

// Speed Dial Action data class
class SpeedDialAction {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const SpeedDialAction({
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
  });
}

// Custom Drawer Menu
class CustomDrawer extends StatelessWidget {
  final String? userName;
  final String? userEmail;
  final String? userAvatar;
  final List<DrawerItem> items;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogout;

  const CustomDrawer({
    super.key,
    this.userName,
    this.userEmail,
    this.userAvatar,
    required this.items,
    this.onProfileTap,
    this.onSettingsTap,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spacingL,
              AppTheme.spacingXL,
              AppTheme.spacingL,
              AppTheme.spacingL,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.primaryPurple, AppTheme.secondaryPurple],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.backgroundWhite,
                      backgroundImage: userAvatar != null 
                          ? NetworkImage(userAvatar!) 
                          : null,
                      child: userAvatar == null 
                          ? const Icon(
                              Icons.person,
                              size: 30,
                              color: AppTheme.primaryPurple,
                            )
                          : null,
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName ?? 'Guest User',
                            style: AppTheme.bodyLarge.copyWith(
                              color: AppTheme.backgroundWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (userEmail != null) ...[
                            const SizedBox(height: AppTheme.spacingXS),
                            Text(
                              userEmail!,
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.backgroundWhite.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ...items.map((item) => _buildDrawerItem(context, item)),
              ],
            ),
          ),
          
          // Footer
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightGray,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                if (onSettingsTap != null)
                  ListTile(
                    leading: const Icon(
                      Icons.settings,
                      color: AppTheme.textLight,
                    ),
                    title: Text(
                      'Settings',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textDark,
                      ),
                    ),
                    onTap: onSettingsTap,
                    contentPadding: EdgeInsets.zero,
                  ),
                if (onLogout != null)
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: AppTheme.errorRed,
                    ),
                    title: Text(
                      'Logout',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.errorRed,
                      ),
                    ),
                    onTap: onLogout,
                    contentPadding: EdgeInsets.zero,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, DrawerItem item) {
    if (item.isDivider) {
      return const Divider(
        height: 1,
        color: AppTheme.lightGray,
      );
    }

    return ListTile(
      leading: Icon(
        item.icon,
        color: item.color ?? AppTheme.textDark,
      ),
      title: Text(
        item.title,
        style: AppTheme.bodyLarge.copyWith(
          color: AppTheme.textDark,
          fontWeight: item.isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: item.subtitle != null
          ? Text(
              item.subtitle!,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textLight,
              ),
            )
          : null,
      trailing: item.badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingS,
                vertical: AppTheme.spacingXS,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple,
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
              ),
              child: Text(
                item.badge!,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.backgroundWhite,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : item.trailing,
      onTap: item.onTap,
      selected: item.isSelected,
      selectedTileColor: AppTheme.primaryPurple.withValues(alpha: 0.1),
    );
  }
}

// Drawer Item data class
class DrawerItem {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final String? subtitle;
  final String? badge;
  final Widget? trailing;
  final Color? color;
  final bool isSelected;
  final bool isDivider;

  const DrawerItem({
    required this.title,
    required this.icon,
    this.onTap,
    this.subtitle,
    this.badge,
    this.trailing,
    this.color,
    this.isSelected = false,
    this.isDivider = false,
  });

  const DrawerItem.divider() : this(
    title: '',
    icon: Icons.horizontal_rule,
    isDivider: true,
  );
}

// Bottom Sheet Menu
class BottomSheetMenu extends StatelessWidget {
  final String title;
  final List<BottomSheetItem> items;
  final Widget? header;

  const BottomSheetMenu({
    super.key,
    required this.title,
    required this.items,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
            decoration: BoxDecoration(
              color: AppTheme.textLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          if (header != null) ...[
            header!,
            const SizedBox(height: AppTheme.spacingM),
          ] else ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
              child: Text(
                title,
                style: AppTheme.headingSmall.copyWith(
                  color: AppTheme.textDark,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
          ],
          
          // Items
          ...items.map((item) => _buildBottomSheetItem(context, item)),
          
          const SizedBox(height: AppTheme.spacingL),
        ],
      ),
    );
  }

  Widget _buildBottomSheetItem(BuildContext context, BottomSheetItem item) {
    if (item.isDivider) {
      return const Divider(
        height: 1,
        color: AppTheme.lightGray,
        indent: AppTheme.spacingL,
        endIndent: AppTheme.spacingL,
      );
    }

    return ListTile(
      leading: Icon(
        item.icon,
        color: item.color ?? AppTheme.textDark,
      ),
      title: Text(
        item.title,
        style: AppTheme.bodyLarge.copyWith(
          color: AppTheme.textDark,
        ),
      ),
      subtitle: item.subtitle != null
          ? Text(
              item.subtitle!,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textLight,
              ),
            )
          : null,
      trailing: item.trailing,
      onTap: () {
        Navigator.pop(context);
        item.onTap?.call();
      },
    );
  }
}

// Bottom Sheet Item data class
class BottomSheetItem {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final String? subtitle;
  final Widget? trailing;
  final Color? color;
  final bool isDivider;

  const BottomSheetItem({
    required this.title,
    required this.icon,
    this.onTap,
    this.subtitle,
    this.trailing,
    this.color,
    this.isDivider = false,
  });

  const BottomSheetItem.divider() : this(
    title: '',
    icon: Icons.horizontal_rule,
    isDivider: true,
  );
}
