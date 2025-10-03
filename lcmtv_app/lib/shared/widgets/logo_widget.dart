import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class LogoWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  final bool showText;
  final String? text;
  final TextStyle? textStyle;

  const LogoWidget({
    super.key,
    this.width,
    this.height,
    this.color,
    this.showText = true,
    this.text,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Image
        Image.asset(
          'assets/images/lcmtv_logo.png',
          width: width ?? 32,
          height: height ?? 32,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to icon if image fails to load
            return Container(
              width: width ?? 32,
              height: height ?? 32,
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.play_circle_filled,
                size: 20,
                color: AppTheme.backgroundWhite,
              ),
            );
          },
        ),
        
        // Text (if enabled)
        if (showText) ...[
          const SizedBox(width: AppTheme.spacingS),
          Text(
            text ?? 'LCMTV',
            style: textStyle ?? const TextStyle(
              color: AppTheme.textDark,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ],
    );
  }
}

// Compact logo for small spaces
class CompactLogoWidget extends StatelessWidget {
  final double? size;
  final Color? backgroundColor;

  const CompactLogoWidget({
    super.key,
    this.size,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 40,
      height: size ?? 40,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.primaryPurple,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/images/lcmtv_logo.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.play_circle_filled,
              color: AppTheme.backgroundWhite,
              size: 24,
            );
          },
        ),
      ),
    );
  }
}

// Large logo for splash screen and welcome screens
class LargeLogoWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final bool showText;
  final String? text;
  final TextStyle? textStyle;

  const LargeLogoWidget({
    super.key,
    this.width,
    this.height,
    this.showText = true,
    this.text,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Large Logo Image
        Image.asset(
          'assets/images/lcmtv_logo.png',
          width: width ?? 120,
          height: height ?? 120,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: width ?? 120,
              height: height ?? 120,
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_circle_filled,
                size: 60,
                color: AppTheme.backgroundWhite,
              ),
            );
          },
        ),
        
        // Text (if enabled)
        if (showText) ...[
          const SizedBox(height: AppTheme.spacingM),
          Text(
            text ?? 'LCMTV',
            style: textStyle ?? AppTheme.headingLarge.copyWith(
              color: AppTheme.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}
