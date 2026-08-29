import 'package:flutter/material.dart';
import '../utils/translations.dart';
import '../widgets/unified_page_design.dart';

class BMICalculatorPage extends StatefulWidget {
  final String currentLanguage;
  const BMICalculatorPage({super.key, required this.currentLanguage});

  @override
  State<BMICalculatorPage> createState() => BMICalculatorPageState();
}

class BMICalculatorPageState extends State<BMICalculatorPage> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _feetController = TextEditingController();
  final _inchesController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'Male';
  String _weightUnit = 'kg';
  String _heightUnit = 'cm';
  Map<String, dynamic> _results = {};
  bool _hasCalculated = false;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _feetController.dispose();
    _inchesController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _clearResults() {
    setState(() {
      _results = {};
      _hasCalculated = false;
    });
  }

  double _getHeightInCm() {
    if (_heightUnit == 'cm') {
      return double.tryParse(_heightController.text) ?? 0;
    } else {
      int feet = int.tryParse(_feetController.text) ?? 0;
      double inches = double.tryParse(_inchesController.text) ?? 0;
      return (feet * 30.48) + (inches * 2.54);
    }
  }

  double _getWeightInKg() {
    double? weight = double.tryParse(_weightController.text);
    if (weight == null) return 0;
    return _weightUnit == 'kg' ? weight : weight * 0.45359237;
  }

  void _calculateBMI() {
    double heightCm = _getHeightInCm();
    double weightKg = _getWeightInKg();
    int? age = int.tryParse(_ageController.text);

    if (_weightController.text.isEmpty ||
        (_heightUnit == 'cm' && _heightController.text.isEmpty) ||
        (_heightUnit == 'in' &&
            (_feetController.text.isEmpty && _inchesController.text.isEmpty)) ||
        _ageController.text.isEmpty ||
        age == null ||
        age <= 0 ||
        weightKg <= 0 ||
        heightCm <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(
              widget.currentLanguage, 'Please fill in all required fields')),
        ),
      );
      setState(() {
        _results = {};
        _hasCalculated = false;
      });
      return;
    }

    double heightM = heightCm / 100;
    double bmi = weightKg / (heightM * heightM);

    double idealWeightLow = 18.5 * heightM * heightM;
    double idealWeightHigh = 24.9 * heightM * heightM;

    if (_weightUnit == 'lb') {
      idealWeightLow = idealWeightLow * 2.20462;
      idealWeightHigh = idealWeightHigh * 2.20462;
    }

    setState(() {
      _results = {
        'bmi': bmi,
        'classification': _classifyBMI(bmi),
        'idealWeightLow': idealWeightLow,
        'idealWeightHigh': idealWeightHigh,
      };
      _hasCalculated = true;
    });
  }

  String _classifyBMI(double bmi) {
    if (bmi < 18.5) {
      return Translations.getTranslation(widget.currentLanguage, 'Underweight');
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return Translations.getTranslation(
          widget.currentLanguage, 'Normal weight');
    } else if (bmi >= 25 && bmi < 29.9) {
      return Translations.getTranslation(widget.currentLanguage, 'Overweight');
    } else {
      return Translations.getTranslation(widget.currentLanguage, 'Obesity');
    }
  }

  Widget _buildHeightInput() {
    if (_heightUnit == 'cm') {
      return UnifiedInputField(
        label: Translations.getTranslation(widget.currentLanguage, 'Height'),
        hintText: Translations.getTranslation(widget.currentLanguage, 'Height'),
        prefixIcon: Icons.height,
        controller: _heightController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) {
          setState(() => _results.clear());
        },
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return Translations.getTranslation(
                widget.currentLanguage, 'Please enter a valid amount');
          }
          final parsed = double.tryParse(value);
          if (parsed == null || parsed <= 0) {
            return Translations.getTranslation(widget.currentLanguage,
                'Invalid input. Please enter a valid number.');
          }
          return null;
        },
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: UnifiedInputField(
              label:
                  Translations.getTranslation(widget.currentLanguage, 'Feet'),
              hintText:
                  Translations.getTranslation(widget.currentLanguage, 'Feet'),
              prefixIcon: Icons.height,
              controller: _feetController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() => _results.clear());
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return Translations.getTranslation(
                      widget.currentLanguage, 'Please enter a valid amount');
                }
                final parsed = int.tryParse(value);
                if (parsed == null || parsed <= 0) {
                  return Translations.getTranslation(widget.currentLanguage,
                      'Invalid input. Please enter a valid number.');
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: UnifiedInputField(
              label:
                  Translations.getTranslation(widget.currentLanguage, 'Inches'),
              hintText:
                  Translations.getTranslation(widget.currentLanguage, 'Inches'),
              prefixIcon: Icons.height,
              controller: _inchesController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() => _results.clear());
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return Translations.getTranslation(
                      widget.currentLanguage, 'Please enter a valid amount');
                }
                final parsed = double.tryParse(value);
                if (parsed == null || parsed < 0) {
                  return Translations.getTranslation(widget.currentLanguage,
                      'Invalid input. Please enter a valid number.');
                }
                return null;
              },
            ),
          ),
        ],
      );
    }
  }

  void _clearAll() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _feetController.clear();
      _inchesController.clear();
      _ageController.clear();
      _gender = 'Male';
      _weightUnit = 'kg';
      _heightUnit = 'cm';
      _results.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translations.getTranslation(widget.currentLanguage, 'bmi_calculator'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clearAll,
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
            UnifiedInputSection(
              title: Translations.getTranslation(
                  widget.currentLanguage, 'Personal Information'),
              icon: Icons.person,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: UnifiedInputField(
                        label: Translations.getTranslation(
                            widget.currentLanguage, 'Weight'),
                        hintText: Translations.getTranslation(
                            widget.currentLanguage, 'Weight'),
                        prefixIcon: Icons.scale,
                        controller: _weightController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onChanged: (value) {
                          _clearResults();
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return Translations.getTranslation(
                                widget.currentLanguage,
                                'Please enter a valid amount');
                          }
                          final parsed = double.tryParse(value);
                          if (parsed == null || parsed <= 0) {
                            return Translations.getTranslation(
                                widget.currentLanguage,
                                'Invalid input. Please enter a valid number.');
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                UnifiedPageDesign.primaryColor.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                Translations.getTranslation(
                                    widget.currentLanguage, 'Unit'),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButton<String>(
                              value: _weightUnit,
                              underline: const SizedBox(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _weightUnit = newValue!;
                                  _clearResults();
                                });
                              },
                              items: <String>[
                                'kg',
                                'lb'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    Translations.getTranslation(
                                        widget.currentLanguage, value),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildHeightInput(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                UnifiedPageDesign.primaryColor.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                Translations.getTranslation(
                                    widget.currentLanguage, 'Unit'),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButton<String>(
                              value: _heightUnit,
                              underline: const SizedBox(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _heightUnit = newValue!;
                                  _heightController.clear();
                                  _feetController.clear();
                                  _inchesController.clear();
                                  _clearResults();
                                });
                              },
                              items: <String>[
                                'cm',
                                'in'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    Translations.getTranslation(
                                        widget.currentLanguage, value),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                UnifiedInputField(
                  label: Translations.getTranslation(
                      widget.currentLanguage, 'Age'),
                  hintText: Translations.getTranslation(
                      widget.currentLanguage, 'Your age'),
                  prefixIcon: Icons.cake,
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _clearResults();
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return Translations.getTranslation(widget.currentLanguage,
                          'Please enter a valid amount');
                    }
                    final parsed = int.tryParse(value);
                    if (parsed == null || parsed <= 0) {
                      return Translations.getTranslation(widget.currentLanguage,
                          'Invalid input. Please enter a valid number.');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                UnifiedDropdownField<String>(
                  label: Translations.getTranslation(
                      widget.currentLanguage, 'Gender'),
                  value: _gender,
                  items: <String>['Male', 'Female']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        Translations.getTranslation(
                            widget.currentLanguage, value),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _gender = newValue!;
                      _clearResults();
                    });
                  },
                  prefixIcon: Icons.wc,
                ),
              ],
            ),
            const SizedBox(height: 24),
            UnifiedPrimaryButton(
              text: Translations.getTranslation(
                  widget.currentLanguage, 'Calculate'),
              icon: Icons.calculate,
              onPressed: _calculateBMI,
            ),
            if (_hasCalculated && _results.isNotEmpty) ...[
              const SizedBox(height: 24),
              UnifiedResultCard(
                title: Translations.getTranslation(
                    widget.currentLanguage, 'bmi_result'),
                value: Translations.formatNumber(
                    widget.currentLanguage, _results['bmi'] as num,
                    decimalDigits: 1),
                icon: Icons.monitor_heart,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _getBMIColor(_results['bmi']).withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: _getBMIColor(_results['bmi']),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          Translations.getTranslation(
                              widget.currentLanguage, 'Classification'),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _getBMIColor(_results['bmi']),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: _getBMIColor(_results['bmi']),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _results['classification'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${Translations.getTranslation(widget.currentLanguage, 'Ideal weight range')}: '
                      '${Translations.formatNumber(widget.currentLanguage, _results['idealWeightLow'] as num, decimalDigits: 1)} - '
                      '${Translations.formatNumber(widget.currentLanguage, _results['idealWeightHigh'] as num, decimalDigits: 1)} '
                      '${Translations.getTranslation(widget.currentLanguage, _weightUnit)}',
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

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) {
      return Colors.blue; // Underweight
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return Colors.green; // Normal weight
    } else if (bmi >= 25 && bmi < 29.9) {
      return Colors.orange; // Overweight
    } else {
      return Colors.red; // Obesity
    }
  }
}
