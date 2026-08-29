import 'package:flutter_test/flutter_test.dart';
import 'package:calciverse/utils/translations.dart';

void main() {
  group('Language Tests', () {
    test('English translations should exist', () {
      expect(Translations.getTranslation('en', 'settings'), 'Settings');
      expect(Translations.getTranslation('en', 'app_title'), 'Calciverse');
      expect(Translations.getLanguageName('en'), 'English');
      expect(Translations.getLanguageDisplayName('en'), 'English');
      expect(Translations.isRTL('en'), false);
    });

    test('Arabic translations should exist', () {
      expect(Translations.getTranslation('ar', 'settings'), 'الإعدادات');
      expect(Translations.getTranslation('ar', 'app_title'), 'Calciverse');
      expect(Translations.getLanguageName('ar'), 'العربية');
      expect(Translations.getLanguageDisplayName('ar'), 'العربية');
      expect(Translations.isRTL('ar'), true);
    });

    test('All supported languages should be returned', () {
      final languages = Translations.getSupportedLanguages();
      expect(languages, contains('en'));
      expect(languages, contains('ar'));
      expect(languages.length, 2);
    });

    test('Language direction should be correct', () {
      expect(Translations.getLanguageDirection('en'), 'ltr');
      expect(Translations.getLanguageDirection('ar'), 'rtl');
    });

    test('Fallback to English for unsupported language', () {
      expect(Translations.getTranslation('fr', 'settings'), 'Settings');
      expect(Translations.getLanguageName('fr'), 'English');
      expect(Translations.getLanguageDisplayName('fr'), 'English');
    });

    test('Key fallback should work', () {
      expect(Translations.getTranslation('en', 'nonexistent_key'),
          'nonexistent_key');
      expect(Translations.getTranslation('ar', 'nonexistent_key'),
          'nonexistent_key');
    });

    test('Arabic text rendering test', () {
      // Test that Arabic characters are properly encoded
      final arabicText = Translations.getTranslation('ar', 'app_title');
      expect(arabicText, isA<String>());
      expect(arabicText.length, greaterThan(0));
    });
  });

  group('UI Consistency Tests', () {
    test('All language keys should exist in both languages', () {
      final englishKeys = Translations.getAllTranslations('en').keys;
      final arabicKeys = Translations.getAllTranslations('ar').keys;

      // Test that essential keys exist in both languages
      final essentialKeys = [
        'settings',
        'app_title',
        'about',
        'version',
        'input',
        'result',
        'reset',
        'clear',
        'error',
        'ok',
        'cancel',
        'confirm',
        'bmi_calculator',
        'currency_converter',
        'file_converter',
        'height_cm',
        'weight_kg',
        'calculate',
        'male',
        'female',
        'light_theme',
        'dark_theme',
        'language',
        'appearance',
        'security_status',
        'features'
      ];

      for (final key in essentialKeys) {
        expect(englishKeys, contains(key), reason: 'Missing English key: $key');
        expect(arabicKeys, contains(key), reason: 'Missing Arabic key: $key');
      }
    });

    test('Translation lengths should be reasonable', () {
      final englishTranslations = Translations.getAllTranslations('en');
      final arabicTranslations = Translations.getAllTranslations('ar');

      // Ensure reasonable number of translations
      expect(englishTranslations.length, greaterThan(50),
          reason: 'Too few English translations');
      expect(arabicTranslations.length, greaterThan(50),
          reason: 'Too few Arabic translations');
      expect(englishTranslations.length, equals(arabicTranslations.length),
          reason: 'Translation counts should match');
    });

    test('Consistent translation quality', () {
      // Test that Arabic translations are meaningful (not just placeholders)
      final sampleKeys = ['settings', 'theme', 'unit_conversion'];

      for (final key in sampleKeys) {
        final arabicTranslation = Translations.getTranslation('ar', key);
        final englishTranslation = Translations.getTranslation('en', key);

        // Ensure Arabic translation is not just English text
        expect(arabicTranslation, isNot(equals(englishTranslation)),
            reason: 'Arabic translation for "$key" should not equal English');
        expect(arabicTranslation.length, greaterThan(0),
            reason: 'Arabic translation for "$key" should not be empty');
      }
    });

    test('Every English key has an Arabic translation', () {
      final englishTranslations = Translations.getAllTranslations('en');
      final arabicTranslations = Translations.getAllTranslations('ar');

      for (final entry in englishTranslations.entries) {
        final key = entry.key;
        expect(arabicTranslations.containsKey(key), isTrue,
            reason: 'Missing Arabic translation for key: $key');
      }
    });
  });
}
