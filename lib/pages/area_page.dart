import 'package:flutter/material.dart';
import '../utils/translations.dart';
import '../widgets/unified_page_design.dart';

class AreaPage extends StatefulWidget {
  final String currentLanguage;
  const AreaPage({super.key, required this.currentLanguage});

  @override
  State<AreaPage> createState() => AreaPageState();
}

class AreaPageState extends State<AreaPage> {
  final List<String> _areaUnits = [
    'Hectare',
    'Square Meter',
    'Square Foot',
    'Square Millimeter',
    'Square Centimeter',
    'Square Decimeter',
    'Square Decameter',
    'Square Hectometer',
    'Square Kilometer',
    'Square Inch',
    'Square Yard',
    'Square Mile',
    'Acre',
    'Qirrat',
    'Span',
    'Dunam',
  ];
  String? _fromUnit;
  String? _toUnit;
  double _convertedValue = 0;
  bool _hasCalculated = false;
  Map<String, double> _results = {};
  final TextEditingController _inputController = TextEditingController();

  // Conversion factors to square meters
  final Map<String, double> _conversionFactors = {
    'Hectare': 10000,
    'Square Meter': 1,
    'Square Foot': 0.092903,
    'Square Millimeter': 0.000001,
    'Square Centimeter': 0.0001,
    'Square Decimeter': 0.01,
    'Square Decameter': 100,
    'Square Hectometer': 10000,
    'Square Kilometer': 1000000,
    'Square Inch': 0.00064516,
    'Square Yard': 0.836127,
    'Square Mile': 2589988.11,
    'Acre': 4046.86,
    'Qirrat': 175.0, // Egyptian Qirrat
    'Span': 0.0254, // Based on inch
    'Dunam': 1000.0, // Metric Dunam
  };

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
    if (inputValue == null || inputValue <= 0) {
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
      // Convert to square meters first
      double inSquareMeters = inputValue * _conversionFactors[_fromUnit!]!;
      // Convert from square meters to target unit
      _convertedValue = inSquareMeters / _conversionFactors[_toUnit!]!;
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
      icon: Icons.crop_square,
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
          items: _areaUnits.map<DropdownMenuItem<String>>((String value) {
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
          items: _areaUnits.map<DropdownMenuItem<String>>((String value) {
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
        title: Text(
            Translations.getTranslation(widget.currentLanguage, 'area_unit')),
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
              icon: Icons.crop_square,
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
