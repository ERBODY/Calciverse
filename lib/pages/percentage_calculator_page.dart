import 'package:flutter/material.dart';
import '../utils/translations.dart';
import '../widgets/unified_page_design.dart';

class PercentageCalculatorPage extends StatefulWidget {
  final String currentLanguage;
  const PercentageCalculatorPage({super.key, required this.currentLanguage});

  @override
  PercentageCalculatorPageState createState() =>
      PercentageCalculatorPageState();
}

class PercentageCalculatorPageState extends State<PercentageCalculatorPage> {
  final _originalValueController = TextEditingController();
  final _percentageController = TextEditingController();
  Map<String, double> _results = {};
  final _formKey = GlobalKey<FormState>();

  void _clearCalculations() {
    setState(() {
      _originalValueController.clear();
      _percentageController.clear();
      _results.clear();
    });
  }

  Map<String, double> _calculatePercentages(
      double originalValue, double percentage) {
    // Basic percentage
    double basicPercentage = (originalValue * percentage) / 100;

    // Percentage increase
    double increase = originalValue + basicPercentage;

    // Percentage decrease
    double decrease = originalValue - basicPercentage;

    return {
      'basic': basicPercentage,
      'increase': increase,
      'decrease': decrease,
    };
  }

  void _performCalculation() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() {
        _results.clear();
      });
      return;
    }

    final originalValue =
        double.parse(_originalValueController.text.replaceAll(',', ''));
    final percentage =
        double.parse(_percentageController.text.replaceAll(',', ''));

    setState(() {
      _results = _calculatePercentages(originalValue, percentage);
    });
  }

  Widget _buildOriginalValueCard() {
    return UnifiedInputSection(
      title:
          Translations.getTranslation(widget.currentLanguage, 'original_value'),
      icon: Icons.attach_money,
      children: [
        UnifiedInputField(
          label: Translations.getTranslation(
              widget.currentLanguage, 'original_value'),
          hintText: Translations.getTranslation(
              widget.currentLanguage, 'Enter value'),
          prefixIcon: Icons.attach_money,
          controller: _originalValueController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return Translations.getTranslation(
                  widget.currentLanguage, 'Please enter a valid amount');
            }
            final parsed = double.tryParse(value.replaceAll(',', ''));
            if (parsed == null || parsed <= 0) {
              return Translations.getTranslation(widget.currentLanguage,
                  'Invalid input. Please enter a valid number.');
            }
            return null;
          },
          onChanged: (_) {
            setState(() {
              _results.clear();
            });
          },
        ),
      ],
    );
  }

  Widget _buildPercentageCard() {
    return UnifiedInputSection(
      title: Translations.getTranslation(widget.currentLanguage, 'percentage'),
      icon: Icons.percent,
      children: [
        UnifiedInputField(
          label:
              Translations.getTranslation(widget.currentLanguage, 'percentage'),
          hintText: Translations.getTranslation(
              widget.currentLanguage, 'Enter value'),
          prefixIcon: Icons.percent,
          controller: _percentageController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return Translations.getTranslation(
                  widget.currentLanguage, 'Please enter a valid amount');
            }
            final parsed = double.tryParse(value.replaceAll(',', ''));
            if (parsed == null || parsed < 0 || parsed > 100) {
              return Translations.getTranslation(widget.currentLanguage,
                  'Please enter valid values (percentage between 0-100)');
            }
            return null;
          },
          onChanged: (_) {
            setState(() {
              _results.clear();
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.getTranslation(
            widget.currentLanguage, 'percentage_calculator')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clearCalculations,
            tooltip:
                Translations.getTranslation(widget.currentLanguage, 'Clear'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildOriginalValueCard(),
              const SizedBox(height: 16),
              _buildPercentageCard(),
              const SizedBox(height: 24),
              UnifiedPrimaryButton(
                text: Translations.getTranslation(
                    widget.currentLanguage, 'calculate'),
                icon: Icons.calculate,
                onPressed: _performCalculation,
              ),
              if (_results.isNotEmpty) ...[
                const SizedBox(height: 24),
                UnifiedResultCard(
                  title: Translations.getTranslation(
                      widget.currentLanguage, 'Percentage Amount'),
                  value: Translations.formatNumber(
                      widget.currentLanguage, _results['basic']!,
                      decimalDigits: 2),
                  icon: Icons.calculate,
                ),
                const SizedBox(height: 16),
                UnifiedResultCard(
                  title: Translations.getTranslation(
                      widget.currentLanguage, 'Amount After Increase'),
                  value: Translations.formatNumber(
                      widget.currentLanguage, _results['increase']!,
                      decimalDigits: 2),
                  icon: Icons.trending_up,
                ),
                const SizedBox(height: 16),
                UnifiedResultCard(
                  title: Translations.getTranslation(
                      widget.currentLanguage, 'Amount After Decrease'),
                  value: Translations.formatNumber(
                      widget.currentLanguage, _results['decrease']!,
                      decimalDigits: 2),
                  icon: Icons.trending_down,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
