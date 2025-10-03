import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? textColor;
  final Color? selectedTextColor;

  const CategoryChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
    this.backgroundColor,
    this.selectedColor,
    this.textColor,
    this.selectedTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = isSelected
        ? (selectedColor ?? AppTheme.primaryPurple)
        : (backgroundColor ?? AppTheme.lightGray);
    
    final effectiveTextColor = isSelected
        ? (selectedTextColor ?? AppTheme.backgroundWhite)
        : (textColor ?? AppTheme.textDark);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        ),
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          border: isSelected
              ? Border.all(
                  color: AppTheme.primaryPurple,
                  width: 1,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: effectiveTextColor,
              ),
              const SizedBox(width: AppTheme.spacingXS),
            ],
            Text(
              label,
              style: AppTheme.bodyMedium.copyWith(
                color: effectiveTextColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Filter chip variant
class FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool showCloseIcon;

  const FilterChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
    this.showCloseIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryPurple : AppTheme.lightGray,
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          border: Border.all(
            color: isSelected ? AppTheme.primaryPurple : AppTheme.lightGray,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppTheme.backgroundWhite : AppTheme.textDark,
              ),
              const SizedBox(width: AppTheme.spacingXS),
            ],
            Text(
              label,
              style: AppTheme.bodyMedium.copyWith(
                color: isSelected ? AppTheme.backgroundWhite : AppTheme.textDark,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (showCloseIcon && isSelected) ...[
              const SizedBox(width: AppTheme.spacingXS),
              Icon(
                Icons.close,
                size: 16,
                color: AppTheme.backgroundWhite,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Action chip variant
class ActionChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const ActionChip({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppTheme.lightGray,
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: textColor ?? AppTheme.textDark,
              ),
              const SizedBox(width: AppTheme.spacingXS),
            ],
            Text(
              label,
              style: AppTheme.bodyMedium.copyWith(
                color: textColor ?? AppTheme.textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Category chips list widget
class CategoryChipsList extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Function(String)? onCategorySelected;
  final bool scrollable;
  final EdgeInsets? padding;

  const CategoryChipsList({
    super.key,
    required this.categories,
    this.selectedCategory,
    this.onCategorySelected,
    this.scrollable = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final chipsList = ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = selectedCategory == category;
        
        return Padding(
          padding: const EdgeInsets.only(right: AppTheme.spacingS),
          child: CategoryChip(
            label: category,
            isSelected: isSelected,
            onTap: () => onCategorySelected?.call(category),
          ),
        );
      },
    );

    if (scrollable) {
      return SizedBox(
        height: 40,
        child: chipsList,
      );
    } else {
      return Wrap(
        spacing: AppTheme.spacingS,
        runSpacing: AppTheme.spacingS,
        children: categories.map((category) {
          final isSelected = selectedCategory == category;
          return CategoryChip(
            label: category,
            isSelected: isSelected,
            onTap: () => onCategorySelected?.call(category),
          );
        }).toList(),
      );
    }
  }
}
