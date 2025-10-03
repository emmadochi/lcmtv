import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// Custom Radio Button
class CustomRadioButton<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String label;
  final String? subtitle;
  final bool enabled;

  const CustomRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
    this.subtitle,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    
    return InkWell(
      onTap: enabled ? () => onChanged?.call(value) : null,
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primaryPurple.withValues(alpha: 0.1)
              : AppTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(
            color: isSelected 
                ? AppTheme.primaryPurple 
                : AppTheme.lightGray,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: enabled ? onChanged : null,
              activeColor: AppTheme.primaryPurple,
            ),
            const SizedBox(width: AppTheme.spacingS),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTheme.bodyLarge.copyWith(
                      color: enabled ? AppTheme.textDark : AppTheme.textLight,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppTheme.spacingXS),
                    Text(
                      subtitle!,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textLight,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Radio Button Group
class RadioButtonGroup<T> extends StatelessWidget {
  final List<RadioOption<T>> options;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? title;
  final EdgeInsets? padding;

  const RadioButtonGroup({
    super.key,
    required this.options,
    this.value,
    this.onChanged,
    this.title,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: AppTheme.headingSmall.copyWith(
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
        ],
        ...options.map((option) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
            child: CustomRadioButton<T>(
              value: option.value,
              groupValue: value,
              onChanged: onChanged,
              label: option.label,
              subtitle: option.subtitle,
              enabled: option.enabled,
            ),
          );
        }).toList(),
      ],
    );
  }
}

// Radio Option data class
class RadioOption<T> {
  final T value;
  final String label;
  final String? subtitle;
  final bool enabled;

  const RadioOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.enabled = true,
  });
}

// Custom Toggle Switch
class CustomToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? subtitle;
  final bool enabled;
  final Color? activeColor;
  final Color? inactiveColor;

  const CustomToggleSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.subtitle,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => onChanged?.call(!value) : null,
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(
            color: AppTheme.lightGray,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label != null)
                    Text(
                      label!,
                      style: AppTheme.bodyLarge.copyWith(
                        color: enabled ? AppTheme.textDark : AppTheme.textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppTheme.spacingXS),
                    Text(
                      subtitle!,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textLight,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeColor: activeColor ?? AppTheme.primaryPurple,
              inactiveThumbColor: inactiveColor ?? AppTheme.textLight,
              inactiveTrackColor: AppTheme.lightGray,
            ),
          ],
        ),
      ),
    );
  }
}

// Toggle Switch List
class ToggleSwitchList extends StatelessWidget {
  final List<ToggleOption> options;
  final Map<String, bool> values;
  final Function(String, bool)? onChanged;
  final String? title;
  final EdgeInsets? padding;

  const ToggleSwitchList({
    super.key,
    required this.options,
    required this.values,
    this.onChanged,
    this.title,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: AppTheme.headingSmall.copyWith(
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
        ],
        ...options.map((option) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
            child: CustomToggleSwitch(
              value: values[option.key] ?? false,
              onChanged: (value) => onChanged?.call(option.key, value),
              label: option.label,
              subtitle: option.subtitle,
              enabled: option.enabled,
              activeColor: option.activeColor,
              inactiveColor: option.inactiveColor,
            ),
          );
        }).toList(),
      ],
    );
  }
}

// Toggle Option data class
class ToggleOption {
  final String key;
  final String label;
  final String? subtitle;
  final bool enabled;
  final Color? activeColor;
  final Color? inactiveColor;

  const ToggleOption({
    required this.key,
    required this.label,
    this.subtitle,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
  });
}

// Settings Section
class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsets? padding;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Text(
              title,
              style: AppTheme.bodyLarge.copyWith(
                color: AppTheme.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

// Form Field Wrapper
class FormFieldWrapper extends StatelessWidget {
  final Widget child;
  final String? label;
  final String? helperText;
  final String? errorText;
  final bool required;

  const FormFieldWrapper({
    super.key,
    required this.child,
    this.label,
    this.helperText,
    this.errorText,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            children: [
              Text(
                label!,
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.textDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (required) ...[
                const SizedBox(width: AppTheme.spacingXS),
                Text(
                  '*',
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.errorRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
        ],
        child,
        if (helperText != null && errorText == null) ...[
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            helperText!,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textLight,
            ),
          ),
        ],
        if (errorText != null) ...[
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            errorText!,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.errorRed,
            ),
          ),
        ],
      ],
    );
  }
}
