import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'home_page.dart';
import 'utils/translations.dart';

void main() async {
  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Warning: Could not load .env file: $e');
    debugPrint('Please create a .env file based on .env.example');
  }

  // Initialize date formatting symbols for Intl (e.g., Arabic month/day names)
  await initializeDateFormatting();

  runApp(const UniversalConverterCalculatorApp());
}

class UniversalConverterCalculatorApp extends StatefulWidget {
  const UniversalConverterCalculatorApp({super.key});

  @override
  UniversalConverterCalculatorAppState createState() =>
      UniversalConverterCalculatorAppState();
}

class UniversalConverterCalculatorAppState
    extends State<UniversalConverterCalculatorApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _isLightTheme = false;
  String _currentLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLightTheme = prefs.getBool('isLightTheme') ?? false;
      _themeMode = _isLightTheme ? ThemeMode.light : ThemeMode.dark;
      // Default to English for better accessibility
      final savedLanguage = prefs.getString('language');
      _currentLanguage = savedLanguage ?? 'en';
    });
  }

  void _toggleTheme(bool isLightTheme) async {
    setState(() {
      _isLightTheme = isLightTheme;
      _themeMode = _isLightTheme ? ThemeMode.light : ThemeMode.dark;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLightTheme', _isLightTheme);
  }

  void _changeLanguage(String language) async {
    setState(() {
      _currentLanguage = language;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = _currentLanguage == 'ar';
    final fontFamily = isArabic ? 'Cairo' : 'Roboto';
    final baseLight = ThemeData.light();
    final baseDark = ThemeData.dark();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Translations.getTranslation(_currentLanguage, 'app_title'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      locale: Locale(_currentLanguage),
      theme: baseLight.copyWith(
        textTheme: baseLight.textTheme.apply(fontFamily: fontFamily),
        primaryTextTheme:
            baseLight.primaryTextTheme.apply(fontFamily: fontFamily),
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black26),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black26),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      darkTheme: baseDark.copyWith(
        textTheme: baseDark.textTheme.apply(fontFamily: fontFamily),
        primaryTextTheme:
            baseDark.primaryTextTheme.apply(fontFamily: fontFamily),
        colorScheme: ColorScheme.dark(
          primary: Colors.blue.shade300,
          secondary: Colors.blueAccent.shade100,
          surface: Colors.grey[900]!,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E1E),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          ),
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      themeMode: _themeMode,
      home: HomePage(
        toggleTheme: _toggleTheme,
        isLightTheme: _isLightTheme,
        currentLanguage: _currentLanguage,
        changeLanguage: _changeLanguage,
      ),
    );
  }
}
