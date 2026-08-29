import 'package:flutter/material.dart';
import '../utils/translations.dart';
import '../widgets/unified_page_design.dart';

class CalorieCalculatorPage extends StatefulWidget {
  final String currentLanguage;
  const CalorieCalculatorPage({super.key, required this.currentLanguage});

  @override
  State<CalorieCalculatorPage> createState() => CalorieCalculatorPageState();
}

class CalorieCalculatorPageState extends State<CalorieCalculatorPage> {
  double _weight = 0;
  double _height = 0;
  int _age = 0;
  String _gender = 'Male';
  double _bodyFat = 0;
  String _weightUnit = 'kg';
  String _heightUnit = 'cm';
  int _feet = 0;
  int _inches = 0;
  String _activityLevel = 'Little or no exercise';
  String _formula = 'Mifflin St Jeor';
  Map<String, double> _results = {};
  bool _showWeightLossInfo = false;
  bool _showWeightGainInfo = false;
  bool _hasCalculated = false;

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchesController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bodyFatController = TextEditingController();

  final Map<String, double> _activityMultipliers = {
    'Little or no exercise': 1.2,
    'Exercise 1-3 times/week': 1.375,
    'Exercise 4-5 times/week': 1.465,
    'Daily exercise or intense exercise 3-4 times/week': 1.55,
    'Intense exercise 6-7 times/week': 1.725,
    'Very intense exercise daily, or physical job': 1.9
  };

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _feetController.dispose();
    _inchesController.dispose();
    _ageController.dispose();
    _bodyFatController.dispose();
    super.dispose();
  }

  void _resetCalculator() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _feetController.clear();
      _inchesController.clear();
      _ageController.clear();
      _bodyFatController.clear();
      _weight = 0;
      _height = 0;
      _feet = 0;
      _inches = 0;
      _age = 0;
      _bodyFat = 0;
      _results = {};
      _showWeightLossInfo = false;
      _showWeightGainInfo = false;
      _hasCalculated = false;
    });
  }

  void _clearResults() {
    setState(() {
      _results = {};
      _hasCalculated = false;
      _showWeightLossInfo = false;
      _showWeightGainInfo = false;
    });
  }

  // Convert weight to kg
  double _getWeightInKg() {
    return _weightUnit == 'kg' ? _weight : _weight * 0.45359237;
  }

  // Convert height to cm
  double _getHeightInCm() {
    if (_heightUnit == 'cm') {
      return _height;
    } else {
      return (_feet * 30.48) + (_inches * 2.54);
    }
  }

  double _calculateMifflinStJeor() {
    double bmr;
    double weightKg = _getWeightInKg();
    double heightCm = _getHeightInCm();

    if (_gender == 'Male') {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * _age) + 5;
    } else {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * _age) - 161;
    }
    return bmr;
  }

  double _calculateRevisedHarrisBenedict() {
    double bmr;
    double weightKg = _getWeightInKg();
    double heightCm = _getHeightInCm();

    if (_gender == 'Male') {
      bmr = (13.397 * weightKg) + (4.799 * heightCm) - (5.677 * _age) + 88.362;
    } else {
      bmr = (9.247 * weightKg) + (3.098 * heightCm) - (4.330 * _age) + 447.593;
    }
    return bmr;
  }

  double _calculateKatchMcArdle() {
    if (_bodyFat <= 0) return 0;
    double weightKg = _getWeightInKg();
    double leanBodyMass = weightKg * (1 - (_bodyFat / 100));
    return 370 + (21.6 * leanBodyMass);
  }

  void _calculateCalories() {
    if (_weight <= 0 ||
        (_heightUnit == 'cm' && _height <= 0) ||
        (_heightUnit == 'ft/in' && (_feet <= 0 && _inches <= 0)) ||
        _age <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(
              widget.currentLanguage, 'Please fill in all required fields')),
        ),
      );
      setState(() {
        _results = {};
      });
      return;
    }

    double bmr = 0;
    switch (_formula) {
      case 'Mifflin St Jeor':
        bmr = _calculateMifflinStJeor();
        break;
      case 'Revised Harris-Benedict':
        bmr = _calculateRevisedHarrisBenedict();
        break;
      case 'Katch-McArdle Body Fat':
        if (_bodyFat <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(Translations.getTranslation(
                  widget.currentLanguage, 'Please enter body fat percentage')),
            ),
          );
          return;
        }
        bmr = _calculateKatchMcArdle();
        break;
    }

    setState(() {
      _results = {
        'BMR': bmr,
        'Daily Calories': bmr * _activityMultipliers[_activityLevel]!,
        'Weight Loss (Mild)': bmr * _activityMultipliers[_activityLevel]! * 0.9,
        'Weight Loss (Moderate)':
            bmr * _activityMultipliers[_activityLevel]! * 0.8,
        'Weight Loss (Extreme)':
            bmr * _activityMultipliers[_activityLevel]! * 0.6,
        'Weight Gain (Mild)': bmr * _activityMultipliers[_activityLevel]! * 1.1,
        'Weight Gain (Moderate)':
            bmr * _activityMultipliers[_activityLevel]! * 1.2,
        'Weight Gain (Extreme)':
            bmr * _activityMultipliers[_activityLevel]! * 1.4,
      };
      _hasCalculated = true;
    });
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
          setState(() {
            _height = double.tryParse(value) ?? 0;
            _clearResults();
          });
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
                setState(() {
                  _feet = int.tryParse(value) ?? 0;
                  _clearResults();
                });
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
          const SizedBox(width: 16),
          Expanded(
            child: UnifiedInputField(
              label:
                  Translations.getTranslation(widget.currentLanguage, 'Inches'),
              hintText:
                  Translations.getTranslation(widget.currentLanguage, 'Inches'),
              prefixIcon: Icons.height,
              controller: _inchesController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _inches = int.tryParse(value) ?? 0;
                  _clearResults();
                });
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return Translations.getTranslation(
                      widget.currentLanguage, 'Please enter a valid amount');
                }
                final parsed = int.tryParse(value);
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

  String _formatWeight(double kgPerWeek) {
    final language = widget.currentLanguage;
    if (_weightUnit == 'kg') {
      final value =
          Translations.formatNumber(language, kgPerWeek, decimalDigits: 2);
      final unit = Translations.getTranslation(language, 'kg');
      return '$value $unit';
    } else {
      final pounds = kgPerWeek * 2.20462;
      final value =
          Translations.formatNumber(language, pounds, decimalDigits: 2);
      final unit = Translations.getTranslation(language, 'lb');
      return '$value $unit';
    }
  }

  Widget _buildWeightLossInfo() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _showWeightLossInfo ? null : 0,
      child: Container(
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
              Translations.getTranslation(
                  widget.currentLanguage, 'Weight Loss Goals:'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: UnifiedPageDesign.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildGoalRow(
              'Mild weight loss',
              0.25,
              _results['Daily Calories']! - 250,
              Colors.blue.shade200,
            ),
            const SizedBox(height: 12),
            _buildGoalRow(
              'Weight loss',
              0.5,
              _results['Daily Calories']! - 500,
              Colors.blue.shade400,
            ),
            const SizedBox(height: 12),
            _buildGoalRow(
              'Extreme weight loss',
              1.0,
              _results['Daily Calories']! - 1000,
              Colors.blue.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightGainInfo() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _showWeightGainInfo ? null : 0,
      child: Container(
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
              Translations.getTranslation(
                  widget.currentLanguage, 'Weight Gain Goals:'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: UnifiedPageDesign.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildGoalRow(
              'Mild weight gain',
              0.25,
              _results['Daily Calories']! + 250,
              Colors.green.shade200,
            ),
            const SizedBox(height: 12),
            _buildGoalRow(
              'Weight gain',
              0.5,
              _results['Daily Calories']! + 500,
              Colors.green.shade400,
            ),
            const SizedBox(height: 12),
            _buildGoalRow(
              'Fast weight gain',
              1.0,
              _results['Daily Calories']! + 1000,
              Colors.green.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalRow(
      String label, double weight, double calories, Color color) {
    final perWeek =
        Translations.getTranslation(widget.currentLanguage, 'per_week');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${Translations.getTranslation(widget.currentLanguage, label)}: '
            '${_formatWeight(weight)} $perWeek',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            '${Translations.getTranslation(widget.currentLanguage, 'Calories')}: '
            '${Translations.formatNumber(widget.currentLanguage, calories, decimalDigits: 0)}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.getTranslation(
            widget.currentLanguage, 'Calorie Calculator')),
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
            // Personal Info Section
            UnifiedInputSection(
              title: Translations.getTranslation(
                  widget.currentLanguage, 'Personal Information'),
              icon: Icons.person,
              children: [
                // Weight with Unit Selector
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
                          setState(() {
                            _weight = double.tryParse(value) ?? 0;
                            _clearResults();
                          });
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
                // Height with Unit Selector
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
                                  _height = 0;
                                  _feet = 0;
                                  _inches = 0;
                                  _clearResults();
                                });
                              },
                              items: <String>[
                                'cm',
                                'ft/in'
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
                      widget.currentLanguage, 'Your age'),
                  hintText: Translations.getTranslation(
                      widget.currentLanguage, 'Your age'),
                  prefixIcon: Icons.cake,
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _age = int.tryParse(value) ?? 0;
                      _clearResults();
                    });
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
            // Activity & Formula Section
            UnifiedInputSection(
              title: Translations.getTranslation(
                  widget.currentLanguage, 'Activity & Formula'),
              icon: Icons.fitness_center,
              children: [
                UnifiedDropdownField<String>(
                  label: Translations.getTranslation(
                      widget.currentLanguage, 'Activity Level'),
                  value: _activityLevel,
                  items: _activityMultipliers.keys
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
                      _activityLevel = newValue!;
                      _clearResults();
                    });
                  },
                  prefixIcon: Icons.directions_run,
                ),
                const SizedBox(height: 16),
                UnifiedDropdownField<String>(
                  label: Translations.getTranslation(
                      widget.currentLanguage, 'BMR Formula'),
                  value: _formula,
                  items: <String>[
                    'Mifflin St Jeor',
                    'Revised Harris-Benedict',
                    'Katch-McArdle Body Fat'
                  ].map<DropdownMenuItem<String>>((String value) {
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
                      _formula = newValue!;
                      if (_formula != 'Katch-McArdle Body Fat') {
                        _bodyFat = 0;
                        _bodyFatController.clear();
                      }
                      _clearResults();
                    });
                  },
                  prefixIcon: Icons.calculate,
                ),
                if (_formula == 'Katch-McArdle Body Fat') ...[
                  const SizedBox(height: 16),
                  UnifiedInputField(
                    label: Translations.getTranslation(
                        widget.currentLanguage, 'Body Fat %'),
                    hintText: Translations.getTranslation(
                        widget.currentLanguage, 'Body Fat %'),
                    prefixIcon: Icons.percent,
                    controller: _bodyFatController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      setState(() {
                        _bodyFat = double.tryParse(value) ?? 0;
                        _clearResults();
                      });
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
                ],
              ],
            ),
            const SizedBox(height: 24),
            UnifiedPrimaryButton(
              text: Translations.getTranslation(
                  widget.currentLanguage, 'Calculate Calories'),
              icon: Icons.calculate,
              onPressed: _calculateCalories,
            ),
            if (_hasCalculated && _results.isNotEmpty) ...[
              const SizedBox(height: 24),
              UnifiedResultCard(
                title:
                    Translations.getTranslation(widget.currentLanguage, 'BMR'),
                value: _results['BMR'] == null
                    ? '0'
                    : Translations.formatNumber(
                        widget.currentLanguage, _results['BMR'] as num,
                        decimalDigits: 0),
                icon: Icons.local_fire_department,
              ),
              const SizedBox(height: 8),
              UnifiedResultCard(
                title: Translations.getTranslation(
                    widget.currentLanguage, 'Daily Calories'),
                value: _results['Daily Calories'] == null
                    ? '0'
                    : Translations.formatNumber(widget.currentLanguage,
                        _results['Daily Calories'] as num,
                        decimalDigits: 0),
                icon: Icons.restaurant,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: UnifiedPrimaryButton(
                      text: Translations.getTranslation(
                        widget.currentLanguage,
                        _showWeightLossInfo
                            ? 'Hide weight loss'
                            : 'Weight loss',
                      ),
                      icon: _showWeightLossInfo
                          ? Icons.expand_less
                          : Icons.expand_more,
                      onPressed: () {
                        setState(() {
                          _showWeightLossInfo = !_showWeightLossInfo;
                          if (_showWeightLossInfo) {
                            _showWeightGainInfo = false;
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: UnifiedPrimaryButton(
                      text: Translations.getTranslation(
                        widget.currentLanguage,
                        _showWeightGainInfo
                            ? 'Hide weight gain'
                            : 'Weight gain',
                      ),
                      icon: _showWeightGainInfo
                          ? Icons.expand_less
                          : Icons.expand_more,
                      onPressed: () {
                        setState(() {
                          _showWeightGainInfo = !_showWeightGainInfo;
                          if (_showWeightGainInfo) {
                            _showWeightLossInfo = false;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildWeightLossInfo(),
              _buildWeightGainInfo(),
            ],
          ],
        ),
      ),
    );
  }
}
