import 'package:flutter/material.dart';
import '../utils/translations.dart';
import '../widgets/unified_page_design.dart';

class TemperaturePage extends StatefulWidget {
  final String currentLanguage;
  const TemperaturePage({super.key, required this.currentLanguage});

  @override
  State<TemperaturePage> createState() => TemperaturePageState();
}

class TemperaturePageState extends State<TemperaturePage> {
  final List<String> _temperatureUnits = [
    'Celsius',
    'Fahrenheit',
    'Kelvin',
    'Rankine'
  ];
  String? _fromUnit;
  String? _toUnit;
  double _convertedValue = 0;
  bool _hasCalculated = false;
  Map<String, double> _results = {};
  final TextEditingController _inputController = TextEditingController();

  // Temperature conversion functions
  double _convertTemperature(double value, String from, String to) {
    // First convert to Celsius as base unit
    double celsius;
    switch (from) {
      case 'Celsius':
        celsius = value;
        break;
      case 'Fahrenheit':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'Kelvin':
        celsius = value - 273.15;
        break;
      case 'Rankine':
        celsius = (value - 491.67) * 5 / 9;
        break;
      default:
        throw Exception('Unsupported unit');
    }

    // Then convert from Celsius to target unit
    switch (to) {
      case 'Celsius':
        return celsius;
      case 'Fahrenheit':
        return (celsius * 9 / 5) + 32;
      case 'Kelvin':
        return celsius + 273.15;
      case 'Rankine':
        return (celsius + 273.15) * 9 / 5;
      default:
        throw Exception('Unsupported unit');
    }
  }

  @override
  void initState() {
    super.initState();
    _fromUnit = null;
    _toUnit = null;
  }

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
    if (_inputController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(
              widget.currentLanguage, 'Please enter a value to convert.')),
        ),
      );
      return;
    }

    double? inputValue = double.tryParse(_inputController.text);
    if (inputValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(widget.currentLanguage,
              'Invalid input. Please enter a valid number.')),
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
          content: Text(Translations.getTranslation(widget.currentLanguage,
              'Please select both "From" & "To" units.')),
        ),
      );
      return;
    }

    try {
      _convertedValue = _convertTemperature(inputValue, _fromUnit!, _toUnit!);
      _results = {'converted': _convertedValue};
      _hasCalculated = true;

      // Handle very small or very large numbers
      if (_convertedValue.abs() < 0.000001 && _convertedValue != 0) {
        _convertedValue = 0;
        _hasCalculated = false;
        _results.clear();
        throw Exception('Result too small to display');
      }
      if (_convertedValue.abs() > 999999999999999) {
        _convertedValue = 0;
        _hasCalculated = false;
        _results.clear();
        throw Exception('Result too large to display');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().contains('Exception:')
              ? e.toString().split('Exception: ')[1]
              : 'Conversion from $_fromUnit to $_toUnit is not supported.'),
        ),
      );
      _convertedValue = 0;
      _hasCalculated = false;
      _results.clear();
    }

    setState(() {});
  }

  Widget _buildAmountCard() {
    return UnifiedInputSection(
      title: Translations.getTranslation(widget.currentLanguage, 'Amount'),
      icon: Icons.thermostat,
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
          items:
              _temperatureUnits.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                Translations.getTranslation(widget.currentLanguage, value),
              ),
            );
          }).toList(),
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
          items:
              _temperatureUnits.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                Translations.getTranslation(widget.currentLanguage, value),
              ),
            );
          }).toList(),
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
        title: Text(Translations.getTranslation(
            widget.currentLanguage, 'temperature_unit')),
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
              icon: Icons.thermostat,
              onPressed: _convertUnits,
            ),
            if (_hasCalculated && _results.isNotEmpty) ...[
              const SizedBox(height: 24),
              UnifiedResultCard(
                title: Translations.getTranslation(
                    widget.currentLanguage, 'Converted Value'),
                value:
                    '${Translations.formatNumber(widget.currentLanguage, _convertedValue, decimalDigits: _convertedValue.abs() < 0.01 ? 6 : 2)} '
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
