import 'package:flutter/material.dart';
import '../utils/translations.dart';
import '../widgets/unified_page_design.dart';

class AgeDifferencePage extends StatefulWidget {
  final String currentLanguage;
  const AgeDifferencePage({super.key, required this.currentLanguage});

  @override
  State<AgeDifferencePage> createState() => AgeDifferencePageState();
}

class AgeDifferencePageState extends State<AgeDifferencePage> {
  DateTime? _firstDate;
  DateTime? _secondDate;
  Map<String, int>? _ageDifference;
  bool _hasCalculated = false;

  void _resetCalculator() {
    setState(() {
      _firstDate = null;
      _secondDate = null;
      _ageDifference = null;
      _hasCalculated = false;
    });
  }

  Future<void> _selectFirstDate(BuildContext context) async {
    final theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _firstDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: theme.colorScheme,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _firstDate) {
      setState(() {
        _firstDate = picked;
        _hasCalculated = false;
      });
    }
  }

  Future<void> _selectSecondDate(BuildContext context) async {
    final theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _secondDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: theme.colorScheme,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _secondDate) {
      setState(() {
        _secondDate = picked;
        _hasCalculated = false;
      });
    }
  }

  void _calculateAgeDifference() {
    if (_firstDate == null || _secondDate == null) return;

    final difference = _secondDate!.difference(_firstDate!);
    final years = (difference.inDays / 365).floor();
    final months = ((difference.inDays % 365) / 30).floor();
    final days = (difference.inDays % 365) % 30;

    setState(() {
      _ageDifference = {
        'years': years,
        'months': months,
        'days': days,
      };
      _hasCalculated = true;
    });
  }

  Widget _buildInputCard() {
    return UnifiedInputSection(
      title:
          Translations.getTranslation(widget.currentLanguage, 'Select Dates'),
      icon: Icons.calendar_today,
      children: [
        GestureDetector(
          onTap: () => _selectFirstDate(context),
          child: Container(
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
                  Icons.person_outline,
                  color: UnifiedPageDesign.primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Translations.getTranslation(
                            widget.currentLanguage, 'First Date'),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _firstDate != null
                            ? Translations.formatDate(
                                widget.currentLanguage,
                                _firstDate!,
                                pattern: 'MMMM d, yyyy',
                              )
                            : Translations.getTranslation(
                                widget.currentLanguage, 'No date selected'),
                        style: TextStyle(
                          fontSize: 14,
                          color: _firstDate != null
                              ? UnifiedPageDesign.primaryColor
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _selectSecondDate(context),
          child: Container(
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
                  Icons.person,
                  color: UnifiedPageDesign.primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Translations.getTranslation(
                            widget.currentLanguage, 'Second Date'),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _secondDate != null
                            ? Translations.formatDate(
                                widget.currentLanguage,
                                _secondDate!,
                                pattern: 'MMMM d, yyyy',
                              )
                            : Translations.getTranslation(
                                widget.currentLanguage, 'No date selected'),
                        style: TextStyle(
                          fontSize: 14,
                          color: _secondDate != null
                              ? UnifiedPageDesign.primaryColor
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard() {
    if (!_hasCalculated) return const SizedBox.shrink();

    return UnifiedInputSection(
      title:
          Translations.getTranslation(widget.currentLanguage, 'Age Difference'),
      icon: Icons.calculate,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: UnifiedPageDesign.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildDifferenceUnit(
                _ageDifference!['years']!,
                Translations.getTranslation(widget.currentLanguage, 'Years'),
              ),
              const SizedBox(height: 8),
              _buildDifferenceUnit(
                _ageDifference!['months']!,
                Translations.getTranslation(widget.currentLanguage, 'Months'),
              ),
              const SizedBox(height: 8),
              _buildDifferenceUnit(
                _ageDifference!['days']!,
                Translations.getTranslation(widget.currentLanguage, 'Days'),
              ),
            ],
          ),
        ),
        if (_firstDate != null && _secondDate != null) ...[
          const SizedBox(height: 16),
          Text(
            '${Translations.getTranslation(widget.currentLanguage, 'First Date')}: '
            '${Translations.formatDate(widget.currentLanguage, _firstDate!, pattern: 'MMMM d, yyyy')}',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            '${Translations.getTranslation(widget.currentLanguage, 'Second Date')}: '
            '${Translations.formatDate(widget.currentLanguage, _secondDate!, pattern: 'MMMM d, yyyy')}',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ],
    );
  }

  Widget _buildDifferenceUnit(int value, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Translations.formatNumber(widget.currentLanguage, value,
              decimalDigits: 0),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: UnifiedPageDesign.primaryColor,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translations.getTranslation(widget.currentLanguage, 'Age Difference'),
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
              _buildInputCard(),
              const SizedBox(height: 24),
              UnifiedPrimaryButton(
                text: Translations.getTranslation(
                    widget.currentLanguage, 'Calculate'),
                icon: Icons.calculate,
                onPressed: _calculateAgeDifference,
              ),
              const SizedBox(height: 24),
              _buildResultCard(),
            ],
          ),
        ),
      ),
    );
  }
}
