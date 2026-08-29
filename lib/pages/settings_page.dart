import 'package:flutter/material.dart';
import '../utils/translations.dart';
import '../widgets/unified_page_design.dart';

class SettingsPage extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isLightTheme;
  final String currentLanguage;
  final Function(String) changeLanguage;

  const SettingsPage({
    super.key,
    required this.toggleTheme,
    required this.isLightTheme,
    required this.currentLanguage,
    required this.changeLanguage,
  });

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  void _showLanguageChangedSnackBar(String languageCode) {
    final message = Translations.getTranslation(
        languageCode, 'language_changed_successfully');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Translations.isRTL(widget.currentLanguage);

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Translations.getTranslation(widget.currentLanguage, 'settings'),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Language Section
            UnifiedInputSection(
              title: Translations.getTranslation(
                  widget.currentLanguage, 'language'),
              icon: Icons.language,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.currentLanguage != 'en'
                            ? () {
                                widget.changeLanguage('en');
                                _showLanguageChangedSnackBar('en');
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.currentLanguage == 'en'
                              ? UnifiedPageDesign.primaryColor
                              : null,
                        ),
                        child: Text(Translations.getTranslation(
                            widget.currentLanguage, 'english')),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.currentLanguage != 'ar'
                            ? () {
                                widget.changeLanguage('ar');
                                _showLanguageChangedSnackBar('ar');
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.currentLanguage == 'ar'
                              ? UnifiedPageDesign.primaryColor
                              : null,
                        ),
                        child: Text(Translations.getTranslation(
                            widget.currentLanguage, 'arabic')),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Theme Section
            UnifiedInputSection(
              title:
                  Translations.getTranslation(widget.currentLanguage, 'theme'),
              icon: Icons.brightness_4,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.isLightTheme
                          ? Translations.getTranslation(widget.currentLanguage,
                              'currently_using_light_theme')
                          : Translations.getTranslation(widget.currentLanguage,
                              'currently_using_dark_theme'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Switch(
                      value: widget.isLightTheme,
                      onChanged: widget.toggleTheme,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // About Section
            UnifiedInputSection(
              title:
                  Translations.getTranslation(widget.currentLanguage, 'about'),
              icon: Icons.info,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Translations.getTranslation(
                          widget.currentLanguage, 'version'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'v1.0.0',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
