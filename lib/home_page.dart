import 'package:flutter/material.dart';
import 'package:calciverse/pages/age_calculator_page.dart';
import 'package:calciverse/pages/percentage_calculator_page.dart';
import 'package:calciverse/pages/post_tax_calculator_page.dart';
import 'package:calciverse/pages/age_difference_page.dart';
import 'package:calciverse/pages/duration_calculator_page.dart';
import 'package:calciverse/pages/calorie_calculator_page.dart';
import 'package:calciverse/pages/zodiac_sign_page.dart';
import 'package:calciverse/pages/event_countdown_page.dart';
import 'package:calciverse/pages/file_converter_page.dart';
import 'package:calciverse/pages/bmi_calculator_page.dart';
import 'package:calciverse/pages/currency_converter_page.dart';
import 'package:calciverse/pages/settings_page.dart';
import 'package:calciverse/pages/length_page.dart';
import 'package:calciverse/pages/weight_and_mass_page.dart';
import 'package:calciverse/pages/volume_and_fluid_units_page.dart';
import 'package:calciverse/pages/temperature_page.dart';
import 'package:calciverse/pages/time_page.dart';
import 'package:calciverse/pages/data_page.dart';
import 'package:calciverse/pages/area_page.dart';
import 'utils/translations.dart';

class HomePage extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isLightTheme;
  final String currentLanguage;
  final Function(String) changeLanguage;

  const HomePage({
    super.key,
    required this.toggleTheme,
    required this.isLightTheme,
    required this.currentLanguage,
    required this.changeLanguage,
  });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final isRTL = Translations.isRTL(widget.currentLanguage);

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Translations.getTranslation(widget.currentLanguage, 'app_title'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                      toggleTheme: widget.toggleTheme,
                      isLightTheme: widget.isLightTheme,
                      currentLanguage: widget.currentLanguage,
                      changeLanguage: widget.changeLanguage,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          childAspectRatio: 1.0,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _buildFeatureButton(context, 'age_calculator', Icons.cake),
            _buildFeatureButton(
                context, 'percentage_calculator', Icons.percent),
            _buildFeatureButton(
                context, 'post_tax_calculator', Icons.receipt_long),
            _buildFeatureButton(context, 'age_difference', Icons.people),
            _buildFeatureButton(context, 'duration_calculator', Icons.timer),
            _buildFeatureButton(
                context, 'calorie_calculator', Icons.local_dining),
            _buildFeatureButton(context, 'zodiac_sign', Icons.star),
            _buildFeatureButton(context, 'event_countdown', Icons.event),
            _buildFeatureButton(context, 'file_converter', Icons.transform),
            _buildFeatureButton(context, 'bmi_calculator', Icons.accessibility),
            _buildFeatureButton(
                context, 'currency_converter', Icons.attach_money),
            _buildFeatureButton(context, 'Length', Icons.straighten),
            _buildFeatureButton(context, 'Area', Icons.crop_square),
            _buildFeatureButton(context, 'weight_and_mass', Icons.scale),
            _buildFeatureButton(
                context, 'volume_and_fluid_units', Icons.local_drink),
            _buildFeatureButton(context, 'Temperature', Icons.thermostat),
            _buildFeatureButton(context, 'Time', Icons.access_time),
            _buildFeatureButton(context, 'Data', Icons.storage),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton(
      BuildContext context, String titleKey, IconData icon) {
    final theme = Theme.of(context);
    final title = Translations.getTranslation(widget.currentLanguage, titleKey);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => _getPageForTitle(titleKey),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getPageForTitle(String titleKey) {
    switch (titleKey) {
      case 'age_calculator':
        return AgeCalculatorPage(currentLanguage: widget.currentLanguage);
      case 'percentage_calculator':
        return PercentageCalculatorPage(
            currentLanguage: widget.currentLanguage);

      case 'post_tax_calculator':
        return PostTaxCalculatorPage(currentLanguage: widget.currentLanguage);
      case 'age_difference':
        return AgeDifferencePage(currentLanguage: widget.currentLanguage);
      case 'duration_calculator':
        return DurationCalculatorPage(currentLanguage: widget.currentLanguage);
      case 'calorie_calculator':
        return CalorieCalculatorPage(currentLanguage: widget.currentLanguage);
      case 'zodiac_sign':
        return ZodiacSignPage(currentLanguage: widget.currentLanguage);
      case 'file_converter':
        return FileConverterPage(currentLanguage: widget.currentLanguage);
      case 'event_countdown':
        return EventCountdownPage(currentLanguage: widget.currentLanguage);
      case 'bmi_calculator':
        return BMICalculatorPage(currentLanguage: widget.currentLanguage);
      case 'currency_converter':
        return CurrencyConverterPage(currentLanguage: widget.currentLanguage);
      case 'Length':
        return LengthPage(currentLanguage: widget.currentLanguage);
      case 'Area':
        return AreaPage(currentLanguage: widget.currentLanguage);
      case 'weight_and_mass':
        return WeightAndMassPage(currentLanguage: widget.currentLanguage);
      case 'volume_and_fluid_units':
        return VolumeAndFluidUnitsPage(currentLanguage: widget.currentLanguage);
      case 'Temperature':
        return TemperaturePage(currentLanguage: widget.currentLanguage);
      case 'Time':
        return TimePage(currentLanguage: widget.currentLanguage);
      case 'Data':
        return DataPage(currentLanguage: widget.currentLanguage);
      default:
        return PlaceholderPage(
            title: titleKey, currentLanguage: widget.currentLanguage);
    }
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  final String currentLanguage;

  const PlaceholderPage({
    super.key,
    required this.title,
    required this.currentLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.getTranslation(currentLanguage, title)),
      ),
      body: Center(
        child: Text(
          '${Translations.getTranslation(currentLanguage, "This is the")} ${Translations.getTranslation(currentLanguage, title)} ${Translations.getTranslation(currentLanguage, "page")}',
        ),
      ),
    );
  }
}
