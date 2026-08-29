import 'package:flutter/material.dart';
import '../utils/translations.dart';
import '../widgets/unified_page_design.dart';

class TimePage extends StatefulWidget {
  final String currentLanguage;
  const TimePage({super.key, required this.currentLanguage});

  @override
  State<TimePage> createState() => TimePageState();
}

class TimePageState extends State<TimePage> {
  final TextEditingController _inputController = TextEditingController();
  String? _fromUnit;
  String? _toUnit;
  double _convertedValue = 0;
  bool _hasCalculated = false;
  Map<String, double> _results = {};

  final Map<String, double> _conversionFactors = {
    'Milliseconds (ms)': 0.001,
    'Seconds (s)': 1,
    'Minutes (min)': 60,
    'Hours (h)': 3600,
    'Days (d)': 86400,
    'Weeks (w)': 604800,
    'Months (avg)': 2629746,
    'Years (365d)': 31536000,
    'Decades': 315360000,
    'Centuries': 3153600000,
  };

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _resetCalculator() {
    setState(() {
      _inputController.clear();
      _fromUnit = null;
      _toUnit = null;
      _convertedValue = 0;
      _hasCalculated = false;
      _results.clear();
    });
  }

  void _clearResults() {
    setState(() {
      _convertedValue = 0;
      _hasCalculated = false;
      _results.clear();
    });
  }

  void _convertUnits() {
    if (_fromUnit == null || _toUnit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(
              widget.currentLanguage, 'Please select both units')),
        ),
      );
      return;
    }

    final inputValue = double.tryParse(_inputController.text);
    if (inputValue == null || inputValue <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(
              widget.currentLanguage, 'Please enter a valid amount')),
        ),
      );
      setState(() {
        _results.clear();
        _hasCalculated = false;
      });
      return;
    }

    setState(() {
      final inSeconds = inputValue * _conversionFactors[_fromUnit]!;
      _convertedValue = inSeconds / _conversionFactors[_toUnit]!;
      _results = {'converted': _convertedValue};
      _hasCalculated = true;
    });
  }

  Widget _buildAmountCard() {
    return UnifiedInputSection(
      title: Translations.getTranslation(widget.currentLanguage, 'Amount'),
      icon: Icons.access_time,
      children: [
        UnifiedInputField(
          label: Translations.getTranslation(
              widget.currentLanguage, 'Enter value'),
          hintText: Translations.getTranslation(
              widget.currentLanguage, 'Enter value'),
          prefixIcon: Icons.input,
          controller: _inputController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            _clearResults();
          },
        ),
      ],
    );
  }

  Widget _buildFromUnitCard() {
    return UnifiedInputSection(
      title: Translations.getTranslation(widget.currentLanguage, 'From Unit'),
      icon: Icons.arrow_downward,
      children: [
        UnifiedDropdownField<String>(
          label:
              Translations.getTranslation(widget.currentLanguage, 'From Unit'),
          value: _fromUnit,
          items: _conversionFactors.keys
              .map((unit) => DropdownMenuItem(
                    value: unit,
                    child: Text(
                      Translations.getTranslation(widget.currentLanguage, unit),
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _fromUnit = value;
              _clearResults();
            });
          },
          prefixIcon: Icons.arrow_downward,
        ),
      ],
    );
  }

  Widget _buildToUnitCard() {
    return UnifiedInputSection(
      title: Translations.getTranslation(widget.currentLanguage, 'To Unit'),
      icon: Icons.arrow_upward,
      children: [
        UnifiedDropdownField<String>(
          label: Translations.getTranslation(widget.currentLanguage, 'To Unit'),
          value: _toUnit,
          items: _conversionFactors.keys
              .map((unit) => DropdownMenuItem(
                    value: unit,
                    child: Text(
                      Translations.getTranslation(widget.currentLanguage, unit),
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _toUnit = value;
              _clearResults();
            });
          },
          prefixIcon: Icons.arrow_upward,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translations.getTranslation(widget.currentLanguage, 'time_unit'),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAmountCard(),
            const SizedBox(height: 16),
            _buildFromUnitCard(),
            const SizedBox(height: 16),
            _buildToUnitCard(),
            const SizedBox(height: 24),
            UnifiedPrimaryButton(
              text: Translations.getTranslation(
                  widget.currentLanguage, 'Convert'),
              icon: Icons.access_time,
              onPressed: _convertUnits,
            ),
            if (_hasCalculated && _results.isNotEmpty) ...[
              const SizedBox(height: 24),
              UnifiedResultCard(
                title: Translations.getTranslation(
                    widget.currentLanguage, 'Converted Value'),
                value:
                    '${Translations.formatNumber(widget.currentLanguage, _convertedValue, decimalDigits: 4)} '
                    '${_toUnit != null ? Translations.getTranslation(widget.currentLanguage, _toUnit!) : ''}',
                icon: Icons.calculate,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Translations.getTranslation(widget.currentLanguage, 'Original')}: ${_inputController.text} ${_fromUnit != null ? Translations.getTranslation(widget.currentLanguage, _fromUnit!) : ''}',
                      style: const TextStyle(fontSize: 13),
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
