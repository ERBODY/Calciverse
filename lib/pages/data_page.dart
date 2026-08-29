import 'package:flutter/material.dart';
import '../utils/translations.dart';
import '../widgets/unified_page_design.dart';

class DataPage extends StatefulWidget {
  final String currentLanguage;
  const DataPage({super.key, required this.currentLanguage});

  @override
  State<DataPage> createState() => DataPageState();
}

class DataPageState extends State<DataPage> {
  final Map<String, int> _powerMap = {
    'bit': -3,
    'byte': 0,
    'kilobyte': 1,
    'megabyte': 2,
    'gigabyte': 3,
    'terabyte': 4,
    'petabyte': 5,
    'exabyte': 6,
    'zettabyte': 7,
    'yottabyte': 8,
  };

  String? _fromUnit;
  String? _toUnit;
  String _convertedValue = '';
  bool _hasCalculated = false;
  Map<String, String> _results = {};
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _resetCalculator() {
    setState(() {
      _inputController.clear();
      _convertedValue = '';
      _fromUnit = null;
      _toUnit = null;
      _hasCalculated = false;
      _results.clear();
    });
  }

  void _clearResults() {
    setState(() {
      _convertedValue = '';
      _hasCalculated = false;
      _results.clear();
    });
  }

  String _formatNumber(double number) {
    if (number == 0) return '0';

    // For extremely small or large numbers, keep exponential notation.
    if (number.abs() < 0.000001 || number.abs() > 999999999999) {
      return number.toStringAsExponential(6);
    }

    final decimalDigits = number.truncateToDouble() == number ? 0 : 6;
    return Translations.formatNumber(
      widget.currentLanguage,
      number,
      decimalDigits: decimalDigits,
    );
  }

  void _convertUnits() {
    double? inputValue = double.tryParse(_inputController.text);
    if (inputValue == null || inputValue < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(
              widget.currentLanguage, 'Please enter a valid positive number')),
        ),
      );
      setState(() {
        _results.clear();
        _hasCalculated = false;
      });
      return;
    }

    if (_fromUnit == null || _toUnit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(
              widget.currentLanguage, 'Please select both units')),
        ),
      );
      return;
    }

    try {
      // Convert to bytes first
      double inBytes;
      if (_fromUnit == 'bit') {
        inBytes = inputValue / 8;
      } else {
        inBytes = inputValue * pow(1024, _powerMap[_fromUnit]!);
      }

      // Convert from bytes to target unit
      double result;
      if (_toUnit == 'bit') {
        result = inBytes * 8;
      } else {
        result = inBytes / pow(1024, _powerMap[_toUnit]!);
      }

      setState(() {
        _convertedValue = _formatNumber(result);
        _results = {'converted': _convertedValue};
        _hasCalculated = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(
              widget.currentLanguage, 'Conversion error occurred')),
        ),
      );
      _convertedValue = '';
      _hasCalculated = false;
      _results.clear();
    }
  }

  Widget _buildAmountCard() {
    return UnifiedInputSection(
      title: Translations.getTranslation(widget.currentLanguage, 'Amount'),
      icon: Icons.storage,
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
          items: _powerMap.keys
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
          items: _powerMap.keys
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
            Translations.getTranslation(widget.currentLanguage, 'data_unit')),
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
              icon: Icons.storage,
              onPressed: _convertUnits,
            ),
            if (_hasCalculated && _results.isNotEmpty) ...[
              const SizedBox(height: 24),
              UnifiedResultCard(
                title: Translations.getTranslation(
                    widget.currentLanguage, 'Converted Value'),
                value:
                    '$_convertedValue ${_toUnit != null ? Translations.getTranslation(widget.currentLanguage, _toUnit!) : ''}',
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

  num pow(num x, int exponent) {
    num result = 1;
    for (int i = 0; i < exponent.abs(); i++) {
      result *= x;
    }
    return exponent < 0 ? 1 / result : result;
  }
}
