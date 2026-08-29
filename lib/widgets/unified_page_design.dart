import 'package:flutter/material.dart';

/// Unified Page Design System
/// Provides consistent styling & components across all pages

class UnifiedPageDesign {
  // Color Palette
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color accentColor = Color(0xFF00BCD4);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFE53935);
  static const Color warningColor = Color(0xFFFFA726);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF5F5F5);
  static const Color lightText = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
}

/// Unified Input Section Card
class UnifiedInputSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final Color? backgroundColor;

  const UnifiedInputSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDark ? UnifiedPageDesign.darkCard : UnifiedPageDesign.lightCard);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              children: Directionality.of(context) == TextDirection.rtl
                  ? [
                      Expanded(
                        child: Text(
                          title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? UnifiedPageDesign.darkText
                                        : UnifiedPageDesign.lightText,
                                  ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        icon,
                        color: UnifiedPageDesign.primaryColor,
                        size: 28,
                      ),
                    ]
                  : [
                      Icon(
                        icon,
                        color: UnifiedPageDesign.primaryColor,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? UnifiedPageDesign.darkText
                                        : UnifiedPageDesign.lightText,
                                  ),
                        ),
                      ),
                    ],
            ),
            const SizedBox(height: 20),
            // Children
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Unified Input Field
class UnifiedInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const UnifiedInputField({
    super.key,
    required this.label,
    required this.hintText,
    this.prefixIcon,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? UnifiedPageDesign.darkText
                    : UnifiedPageDesign.lightText,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: UnifiedPageDesign.primaryColor,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark
                    ? UnifiedPageDesign.darkTextSecondary
                    : UnifiedPageDesign.lightTextSecondary,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark
                    ? UnifiedPageDesign.darkTextSecondary.withOpacity(0.3)
                    : UnifiedPageDesign.lightTextSecondary.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: UnifiedPageDesign.primaryColor,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: isDark
                ? UnifiedPageDesign.darkSurface
                : UnifiedPageDesign.lightSurface,
            contentPadding: const EdgeInsetsDirectional.fromSTEB(
              16,
              14,
              16,
              14,
            ),
          ),
        ),
      ],
    );
  }
}

/// Unified Dropdown Field
class UnifiedDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?)? onChanged;
  final IconData? prefixIcon;

  const UnifiedDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? UnifiedPageDesign.darkText
                    : UnifiedPageDesign.lightText,
              ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          decoration: InputDecoration(
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: UnifiedPageDesign.primaryColor,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark
                    ? UnifiedPageDesign.darkTextSecondary
                    : UnifiedPageDesign.lightTextSecondary,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark
                    ? UnifiedPageDesign.darkTextSecondary.withOpacity(0.3)
                    : UnifiedPageDesign.lightTextSecondary.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: UnifiedPageDesign.primaryColor,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: isDark
                ? UnifiedPageDesign.darkSurface
                : UnifiedPageDesign.lightSurface,
            contentPadding: const EdgeInsetsDirectional.fromSTEB(
              16,
              14,
              16,
              14,
            ),
          ),
        ),
      ],
    );
  }
}

/// Unified Primary Button
class UnifiedPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  const UnifiedPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: UnifiedPageDesign.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Unified Result Card
class UnifiedResultCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? backgroundColor;

  const UnifiedResultCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDark ? UnifiedPageDesign.darkCard : UnifiedPageDesign.lightCard);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: Directionality.of(context) == TextDirection.rtl
                  ? [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isDark
                                        ? UnifiedPageDesign.darkTextSecondary
                                        : UnifiedPageDesign.lightTextSecondary,
                                  ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        icon,
                        color: UnifiedPageDesign.primaryColor,
                        size: 28,
                      ),
                    ]
                  : [
                      Icon(
                        icon,
                        color: UnifiedPageDesign.primaryColor,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isDark
                                        ? UnifiedPageDesign.darkTextSecondary
                                        : UnifiedPageDesign.lightTextSecondary,
                                  ),
                        ),
                      ),
                    ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: UnifiedPageDesign.primaryColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
