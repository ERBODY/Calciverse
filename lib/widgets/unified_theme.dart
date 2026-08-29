import 'package:flutter/material.dart';
import '../utils/translations.dart';

/// Unified Modern Theme System for Universal Converter Calculator
/// Ensures consistent design, animations, & language support across all pages
class UnifiedTheme {
  // Core Colors
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color secondaryColor = Color(0xFF2196F3);
  static const Color accentColor = Color(0xFF4CAF50);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFFF5252);
  static const Color warningColor = Color(0xFFFF9800);

  // Surface Colors
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color surfaceDark = Color(0xFF121212);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF000000);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF1976D2);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFFFFFFF);

  // Dimensions
  static const double borderRadius = 16.0;
  static const double cardElevation = 4.0;
  static const double buttonHeight = 56.0;
  static const double iconSize = 24.0;
  static const double spacing = 16.0;
  static const double spacingSmall = 8.0;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, secondaryColor],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [successColor, accentColor],
  );

  // Animation
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Curve animationCurve = Curves.easeInOut;

  // Text Styles - Light Theme
  static TextStyle headlineLight = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimaryLight,
    letterSpacing: 0.5,
  );

  static TextStyle titleLight = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: textPrimaryLight,
    letterSpacing: 0.5,
  );

  static TextStyle subtitleLight = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textPrimaryLight,
    height: 1.4,
  );

  static TextStyle bodyLight = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondaryLight,
    height: 1.5,
  );

  static TextStyle captionLight = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondaryLight,
    height: 1.4,
  );

  // Text Styles - Dark Theme
  static TextStyle headlineDark =
      headlineLight.copyWith(color: textPrimaryDark);
  static TextStyle titleDark = titleLight.copyWith(color: textPrimaryDark);
  static TextStyle subtitleDark =
      subtitleLight.copyWith(color: textPrimaryDark);
  static TextStyle bodyDark = bodyLight.copyWith(color: textSecondaryDark);
  static TextStyle captionDark =
      captionLight.copyWith(color: textSecondaryDark);

  // Helper Methods
  static TextStyle getHeadlineStyle(bool isDark) =>
      isDark ? headlineDark : headlineLight;
  static TextStyle getTitleStyle(bool isDark) =>
      isDark ? titleDark : titleLight;
  static TextStyle getSubtitleStyle(bool isDark) =>
      isDark ? subtitleDark : subtitleLight;
  static TextStyle getBodyStyle(bool isDark) => isDark ? bodyDark : bodyLight;
  static TextStyle getCaptionStyle(bool isDark) =>
      isDark ? captionDark : captionLight;

  static Color getPrimaryTextColor(bool isDark) =>
      isDark ? textPrimaryDark : textPrimaryLight;
  static Color getSecondaryTextColor(bool isDark) =>
      isDark ? textSecondaryDark : textSecondaryLight;
  static Color getSurfaceColor(bool isDark) =>
      isDark ? surfaceDark : surfaceLight;
  static Color getBackgroundColor(bool isDark) =>
      isDark ? backgroundDark : backgroundLight;

  // RTL Support
  static TextDirection getTextDirection(String languageCode) {
    return Translations.isRTL(languageCode)
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  static Alignment getTextAlignment(String languageCode) {
    return Translations.isRTL(languageCode)
        ? Alignment.centerRight
        : Alignment.centerLeft;
  }

  static CrossAxisAlignment getCrossAxisAlignment(String languageCode) {
    return Translations.isRTL(languageCode)
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
  }

  static MainAxisAlignment getMainAxisAlignment(String languageCode) {
    return Translations.isRTL(languageCode)
        ? MainAxisAlignment.end
        : MainAxisAlignment.start;
  }
}

/// Modern Card Component
class UnifiedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool useGlass;
  final VoidCallback? onTap;
  final double? width;
  final String? languageCode;

  const UnifiedCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.useGlass = false,
    this.onTap,
    this.width,
    this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget card = Container(
      width: width,
      margin: margin ?? const EdgeInsets.only(bottom: UnifiedTheme.spacing),
      decoration: _getCardDecoration(isDark, useGlass, backgroundColor),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(UnifiedTheme.borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(UnifiedTheme.borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(UnifiedTheme.spacing),
            child: child,
          ),
        ),
      ),
    );

    return AnimatedSwitcher(
      duration: UnifiedTheme.animationDuration,
      child: card,
    );
  }

  BoxDecoration _getCardDecoration(
      bool isDark, bool useGlass, Color? backgroundColor) {
    if (useGlass) {
      return BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withOpacity(0.1),
        borderRadius: BorderRadius.circular(UnifiedTheme.borderRadius),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withOpacity(0.2),
          width: 1,
        ),
      );
    }

    return BoxDecoration(
      color: backgroundColor ??
          (isDark ? UnifiedTheme.surfaceDark : UnifiedTheme.surfaceLight),
      borderRadius: BorderRadius.circular(UnifiedTheme.borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

/// Modern Button Component
class UnifiedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isSecondary;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  final String? languageCode;

  const UnifiedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isSecondary = false,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    ButtonStyle buttonStyle =
        _getButtonStyle(isDark, isSecondary, backgroundColor, textColor);

    Widget button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle.copyWith(
        minimumSize: WidgetStateProperty.all(
          Size(width ?? double.infinity, UnifiedTheme.buttonHeight),
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 18,
                    color: textColor ?? Colors.white,
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
    );

    return AnimatedSwitcher(
      duration: UnifiedTheme.animationDuration,
      child: button,
    );
  }

  ButtonStyle _getButtonStyle(
      bool isDark, bool isSecondary, Color? backgroundColor, Color? textColor) {
    if (isSecondary) {
      return OutlinedButton.styleFrom(
        foregroundColor: backgroundColor ?? UnifiedTheme.primaryColor,
        side: BorderSide(
            color: backgroundColor ?? UnifiedTheme.primaryColor, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UnifiedTheme.borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: TextStyle(
          color: backgroundColor ?? UnifiedTheme.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? UnifiedTheme.primaryColor,
      foregroundColor: textColor ?? Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UnifiedTheme.borderRadius),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    );
  }
}

/// Modern Input Field Component
class UnifiedInputField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final IconData? icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final VoidCallback? onSuffixIconTap;
  final IconData? suffixIcon;
  final int maxLines;
  final String? languageCode;

  const UnifiedInputField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.icon,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.onSuffixIconTap,
    this.suffixIcon,
    this.maxLines = 1,
    this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isRTL = languageCode != null && Translations.isRTL(languageCode!);

    return AnimatedSwitcher(
      duration: UnifiedTheme.animationDuration,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        validator: validator,
        style: UnifiedTheme.getBodyStyle(isDark),
        textAlign: isRTL ? TextAlign.right : TextAlign.left,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: UnifiedTheme.getSubtitleStyle(isDark),
          prefixIcon: icon != null
              ? Icon(icon, color: UnifiedTheme.primaryColor, size: 20)
              : null,
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(suffixIcon,
                      color: UnifiedTheme.primaryColor, size: 20),
                  onPressed: onSuffixIconTap,
                )
              : null,
          filled: true,
          fillColor:
              (isDark ? UnifiedTheme.surfaceDark : UnifiedTheme.surfaceLight),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(UnifiedTheme.borderRadius),
            borderSide: BorderSide(
              color: isDark ? Colors.white24 : Colors.black12,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(UnifiedTheme.borderRadius),
            borderSide: BorderSide(
              color: isDark ? Colors.white24 : Colors.black12,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(UnifiedTheme.borderRadius),
            borderSide:
                const BorderSide(color: UnifiedTheme.primaryColor, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          hintStyle: UnifiedTheme.getBodyStyle(isDark).copyWith(
            color: isDark ? Colors.white38 : Colors.black38,
          ),
        ),
      ),
    );
  }
}

/// Modern Result Display Component
class UnifiedResultDisplay extends StatelessWidget {
  final String title;
  final String result;
  final String? unit;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final String? languageCode;

  const UnifiedResultDisplay({
    super.key,
    required this.title,
    required this.result,
    this.unit,
    this.icon,
    this.backgroundColor,
    this.textColor,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedSwitcher(
      duration: UnifiedTheme.animationDuration,
      child: UnifiedCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (backgroundColor ?? UnifiedTheme.primaryColor)
                      .withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: backgroundColor ?? UnifiedTheme.primaryColor,
                  size: UnifiedTheme.iconSize,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              title,
              style: UnifiedTheme.getTitleStyle(isDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              decoration: BoxDecoration(
                gradient: UnifiedTheme.successGradient,
                borderRadius: BorderRadius.circular(UnifiedTheme.borderRadius),
              ),
              child: Text(
                '$result${unit != null ? ' $unit' : ''}',
                style: UnifiedTheme.getHeadlineStyle(isDark).copyWith(
                  color: textColor ?? Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple animated container wrapper
class AnimatedSwitcher extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const AnimatedSwitcher({
    super.key,
    required this.child,
    this.duration = UnifiedTheme.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: UnifiedTheme.animationCurve,
      decoration: BoxDecoration(color: Colors.transparent),
      child: child,
    );
  }
}
