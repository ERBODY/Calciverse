import 'package:flutter/material.dart';
import '../utils/translations.dart';
import '../widgets/unified_page_design.dart';

class DurationCalculatorPage extends StatefulWidget {
  final String currentLanguage;
  const DurationCalculatorPage({super.key, required this.currentLanguage});

  @override
  State<DurationCalculatorPage> createState() => DurationCalculatorPageState();
}

class DurationCalculatorPageState extends State<DurationCalculatorPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _duration = '';
  bool _includeTime = false;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _duration = '';
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    if (!mounted) return;
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (time != null && mounted) {
      setState(() {
        _startTime = time;
        _duration = '';
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _duration = '';
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    if (!mounted) return;
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );
    if (time != null && mounted) {
      setState(() {
        _endTime = time;
        _duration = '';
      });
    }
  }

  void _calculateDuration() {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Translations.getTranslation(
                widget.currentLanguage, 'Please select both dates'),
          ),
        ),
      );
      return;
    }

    DateTime startDateTime = _startDate!;
    DateTime endDateTime = _endDate!;

    if (_includeTime && _startTime != null && _endTime != null) {
      startDateTime = DateTime(
        _startDate!.year,
        _startDate!.month,
        _startDate!.day,
        _startTime!.hour,
        _startTime!.minute,
      );
      endDateTime = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
        _endTime!.hour,
        _endTime!.minute,
      );
    }

    if (startDateTime.isAfter(endDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Translations.getTranslation(
                widget.currentLanguage, 'Start date cannot be after end date'),
          ),
        ),
      );
      return;
    }

    final difference = endDateTime.difference(startDateTime);
    final years = difference.inDays ~/ 365;
    final months = (difference.inDays % 365) ~/ 30;
    final days = (difference.inDays % 365) % 30;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    final ly = Translations.getTranslation(widget.currentLanguage, 'Years');
    final lm = Translations.getTranslation(widget.currentLanguage, 'Months');
    final ld = Translations.getTranslation(widget.currentLanguage, 'Days');
    final lh = Translations.getTranslation(widget.currentLanguage, 'Hours');
    final lmin = Translations.getTranslation(widget.currentLanguage, 'Minutes');

    final yearsStr = Translations.formatNumber(widget.currentLanguage, years,
        decimalDigits: 0);
    final monthsStr = Translations.formatNumber(widget.currentLanguage, months,
        decimalDigits: 0);
    final daysStr = Translations.formatNumber(widget.currentLanguage, days,
        decimalDigits: 0);
    final hoursStr = Translations.formatNumber(widget.currentLanguage, hours,
        decimalDigits: 0);
    final minutesStr = Translations.formatNumber(
        widget.currentLanguage, minutes,
        decimalDigits: 0);

    setState(() {
      if (_includeTime) {
        _duration =
            '$yearsStr $ly, $monthsStr $lm, $daysStr $ld, $hoursStr $lh, $minutesStr $lmin';
      } else {
        _duration = '$yearsStr $ly, $monthsStr $lm, $daysStr $ld';
      }
    });
  }

  Widget _buildDateCard(String title, DateTime? date, TimeOfDay? time,
      VoidCallback onDateTap, VoidCallback? onTimeTap) {
    final bool hasDate = date != null;
    final bool hasTime = time != null && _includeTime;

    return Column(
      children: [
        GestureDetector(
          onTap: onDateTap,
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
                  Icons.calendar_today,
                  color: UnifiedPageDesign.primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      if (hasDate)
                        Text(
                          Translations.formatDate(
                            widget.currentLanguage,
                            date,
                            pattern: 'MMMM d, yyyy',
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: UnifiedPageDesign.primaryColor,
                          ),
                        )
                      else
                        Text(
                          Translations.getTranslation(
                              widget.currentLanguage, 'Select date'),
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_includeTime) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTimeTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: UnifiedPageDesign.accentColor.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: UnifiedPageDesign.accentColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${Translations.getTranslation(widget.currentLanguage, 'Time')} ($title)',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        if (hasTime)
                          Text(
                            time.format(context),
                            style: const TextStyle(
                              fontSize: 14,
                              color: UnifiedPageDesign.accentColor,
                            ),
                          )
                        else
                          Text(
                            Translations.getTranslation(
                                widget.currentLanguage, 'Select time'),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildResultCard() {
    if (_duration.isEmpty) return const SizedBox.shrink();

    return UnifiedResultCard(
      title: Translations.getTranslation(widget.currentLanguage, 'Result'),
      value: _duration,
      icon: Icons.timer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translations.getTranslation(
              widget.currentLanguage, 'Duration Calculator'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _startDate = null;
                _endDate = null;
                _startTime = null;
                _endTime = null;
                _duration = '';
              });
            },
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
                  widget.currentLanguage, 'Select Dates'),
              icon: Icons.calendar_today,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: UnifiedPageDesign.accentColor,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      Translations.getTranslation(
                          widget.currentLanguage, 'Include Time'),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const Spacer(),
                    Switch(
                      value: _includeTime,
                      onChanged: (bool value) {
                        setState(() {
                          _includeTime = value;
                          if (!value) {
                            _startTime = null;
                            _endTime = null;
                          }
                          _duration = '';
                        });
                      },
                      activeColor: UnifiedPageDesign.accentColor,
                      activeTrackColor:
                          UnifiedPageDesign.accentColor.withOpacity(0.5),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDateCard(
                  Translations.getTranslation(
                      widget.currentLanguage, 'Start Date'),
                  _startDate,
                  _startTime,
                  () => _selectStartDate(context),
                  () => _selectStartTime(context),
                ),
                const SizedBox(height: 16),
                _buildDateCard(
                  Translations.getTranslation(
                      widget.currentLanguage, 'End Date'),
                  _endDate,
                  _endTime,
                  () => _selectEndDate(context),
                  () => _selectEndTime(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            UnifiedPrimaryButton(
              text: Translations.getTranslation(
                  widget.currentLanguage, 'Calculate'),
              icon: Icons.calculate,
              onPressed: _calculateDuration,
            ),
            const SizedBox(height: 24),
            _buildResultCard(),
          ],
        ),
      ),
    );
  }
}
