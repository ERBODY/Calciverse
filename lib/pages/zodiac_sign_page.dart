import 'package:flutter/material.dart';
import '../utils/translations.dart';
import '../widgets/unified_page_design.dart';

class ZodiacSignPage extends StatefulWidget {
  final String currentLanguage;
  const ZodiacSignPage({super.key, required this.currentLanguage});

  @override
  State<ZodiacSignPage> createState() => ZodiacSignPageState();
}

class ZodiacSignPageState extends State<ZodiacSignPage> {
  DateTime? _selectedDate;
  String? _zodiacSign;
  String? _zodiacDescription;
  bool _hasCalculated = false;

  void _resetCalculator() {
    setState(() {
      _selectedDate = null;
      _zodiacSign = null;
      _zodiacDescription = null;
      _hasCalculated = false;
    });
  }

  void _clearResults() {
    setState(() {
      _zodiacSign = null;
      _zodiacDescription = null;
      _hasCalculated = false;
    });
  }

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

  void _calculateZodiacSign() {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(
              widget.currentLanguage, 'Please select a date')),
        ),
      );
      return;
    }
    _calculateZodiacSignLogic();
  }

  String _getZodiacIcon(String sign) {
    switch (sign) {
      case 'Aries':
        return '♈';
      case 'Taurus':
        return '♉';
      case 'Gemini':
        return '♊';
      case 'Cancer':
        return '♋';
      case 'Leo':
        return '♌';
      case 'Virgo':
        return '♍';
      case 'Libra':
        return '♎';
      case 'Scorpio':
        return '♏';
      case 'Sagittarius':
        return '♐';
      case 'Capricorn':
        return '♑';
      case 'Aquarius':
        return '♒';
      case 'Pisces':
        return '♓';
      default:
        return '★';
    }
  }

  void _calculateZodiacSignLogic() {
    final month = _selectedDate!.month;
    final day = _selectedDate!.day;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      _zodiacSign = 'Aries';
      _zodiacDescription =
          Translations.getTranslation(widget.currentLanguage, 'aries_desc');
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      _zodiacSign = 'Taurus';
      _zodiacDescription =
          Translations.getTranslation(widget.currentLanguage, 'taurus_desc');
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      _zodiacSign = 'Gemini';
      _zodiacDescription =
          Translations.getTranslation(widget.currentLanguage, 'gemini_desc');
    } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      _zodiacSign = 'Cancer';
      _zodiacDescription =
          Translations.getTranslation(widget.currentLanguage, 'cancer_desc');
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      _zodiacSign = 'Leo';
      _zodiacDescription =
          Translations.getTranslation(widget.currentLanguage, 'leo_desc');
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      _zodiacSign = 'Virgo';
      _zodiacDescription =
          Translations.getTranslation(widget.currentLanguage, 'virgo_desc');
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      _zodiacSign = 'Libra';
      _zodiacDescription =
          Translations.getTranslation(widget.currentLanguage, 'libra_desc');
    } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      _zodiacSign = 'Scorpio';
      _zodiacDescription =
          Translations.getTranslation(widget.currentLanguage, 'scorpio_desc');
    } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      _zodiacSign = 'Sagittarius';
      _zodiacDescription = Translations.getTranslation(
          widget.currentLanguage, 'sagittarius_desc');
    } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      _zodiacSign = 'Capricorn';
      _zodiacDescription =
          Translations.getTranslation(widget.currentLanguage, 'capricorn_desc');
    } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      _zodiacSign = 'Aquarius';
      _zodiacDescription =
          Translations.getTranslation(widget.currentLanguage, 'aquarius_desc');
    } else {
      _zodiacSign = 'Pisces';
      _zodiacDescription =
          Translations.getTranslation(widget.currentLanguage, 'pisces_desc');
    }

    setState(() {
      _hasCalculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translations.getTranslation(widget.currentLanguage, 'Zodiac Sign'),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Input Section
            UnifiedInputSection(
              title: Translations.getTranslation(
                  widget.currentLanguage, 'Birth Date'),
              icon: Icons.cake,
              children: [
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
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
                                      widget.currentLanguage,
                                      'No date selected'),
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
                ),
              ],
            ),
            const SizedBox(height: 16),
            UnifiedPrimaryButton(
              text: Translations.getTranslation(
                  widget.currentLanguage, 'Calculate'),
              icon: Icons.calculate,
              onPressed: _calculateZodiacSign,
            ),
            if (_hasCalculated && _zodiacSign != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: UnifiedPageDesign.primaryColor.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _getZodiacIcon(_zodiacSign!),
                      style: const TextStyle(
                        fontSize: 64,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      Translations.getTranslation(
                          widget.currentLanguage, _zodiacSign!.toLowerCase()),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: UnifiedPageDesign.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _zodiacDescription!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
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
        ),
      ),
    );
  }
}
