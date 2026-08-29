import 'package:flutter/material.dart';
import '../utils/translations.dart';
import '../widgets/unified_page_design.dart';

class AgeCalculatorPage extends StatefulWidget {
  final String currentLanguage;
  const AgeCalculatorPage({super.key, required this.currentLanguage});

  @override
  State<AgeCalculatorPage> createState() => AgeCalculatorPageState();
}

class AgeCalculatorPageState extends State<AgeCalculatorPage> {
  DateTime? _selectedDate;
  int _years = 0;
  int _months = 0;
  int _days = 0;
  bool _hasCalculated = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _clearResults();
      });
    }
  }

  void _clearResults() {
    setState(() {
      _years = 0;
      _months = 0;
      _days = 0;
      _hasCalculated = false;
    });
  }

  void _resetCalculator() {
    setState(() {
      _selectedDate = null;
      _years = 0;
      _months = 0;
      _days = 0;
      _hasCalculated = false;
    });
  }

  void _calculateAge() {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(
              widget.currentLanguage, 'Please select a date')),
        ),
      );
      return;
    }

    final now = DateTime.now();
    int years = now.year - _selectedDate!.year;
    int months = now.month - _selectedDate!.month;
    int days = now.day - _selectedDate!.day;

    // Adjust for negative months or days
    if (days < 0) {
      final lastMonth = DateTime(now.year, now.month - 1, _selectedDate!.day);
      days = now.difference(lastMonth).inDays;
      months--;
    }
    if (months < 0) {
      months += 12;
      years--;
    }

    setState(() {
      _years = years;
      _months = months;
      _days = days;
      _hasCalculated = true;
    });
  }

  Widget _buildDateCard() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: UnifiedInputSection(
        title:
            Translations.getTranslation(widget.currentLanguage, 'Birth Date'),
        icon: Icons.cake,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: UnifiedPageDesign.primaryColor.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Translations.getTranslation(
                          widget.currentLanguage, 'Select Date'),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedDate != null
                          ? Translations.formatDate(
                              widget.currentLanguage,
                              _selectedDate!,
                              pattern: 'MMMM d, yyyy',
                            )
                          : Translations.getTranslation(
                              widget.currentLanguage, 'No date selected'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _selectedDate != null
                            ? UnifiedPageDesign.primaryColor
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.calendar_today,
                  color: UnifiedPageDesign.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    if (!_hasCalculated) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: UnifiedResultCard(
                title: Translations.getTranslation(
                    widget.currentLanguage, 'Years'),
                value: Translations.formatNumber(widget.currentLanguage, _years,
                    decimalDigits: 0),
                icon: Icons.calendar_today,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: UnifiedResultCard(
                title: Translations.getTranslation(
                    widget.currentLanguage, 'Months'),
                value: Translations.formatNumber(
                    widget.currentLanguage, _months,
                    decimalDigits: 0),
                icon: Icons.date_range,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: UnifiedResultCard(
                title:
                    Translations.getTranslation(widget.currentLanguage, 'Days'),
                value: Translations.formatNumber(widget.currentLanguage, _days,
                    decimalDigits: 0),
                icon: Icons.today,
              ),
            ),
          ],
        ),
        if (_selectedDate != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: UnifiedPageDesign.primaryColor.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: UnifiedPageDesign.primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${Translations.getTranslation(widget.currentLanguage, 'Birth Date')}: '
                    '${Translations.formatDate(widget.currentLanguage, _selectedDate!, pattern: 'MMMM d, yyyy')}',
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translations.getTranslation(widget.currentLanguage, 'Age Calculator'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetCalculator,
            tooltip:
                Translations.getTranslation(widget.currentLanguage, 'Reset'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDateCard(),
              const SizedBox(height: 16),
              UnifiedPrimaryButton(
                text: Translations.getTranslation(
                    widget.currentLanguage, 'Calculate'),
                icon: Icons.calculate,
                onPressed: _calculateAge,
              ),
              const SizedBox(height: 16),
              _buildResultCard(),
            ],
          ),
        ),
      ),
    );
  }
}
