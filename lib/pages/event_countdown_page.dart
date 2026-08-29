import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/translations.dart';
import '../widgets/unified_page_design.dart';

class EventCountdownPage extends StatefulWidget {
  final String currentLanguage;
  const EventCountdownPage({super.key, required this.currentLanguage});

  @override
  State<EventCountdownPage> createState() => EventCountdownPageState();
}

class EventCountdownPageState extends State<EventCountdownPage> {
  final TextEditingController _eventNameController = TextEditingController();
  DateTime? _eventDate;
  TimeOfDay? _selectedTime;
  String _countdown = '';
  Timer? _timer;
  bool _hasCalculated = false;
  bool _includeTime = false;

  @override
  void dispose() {
    _timer?.cancel();
    _eventNameController.dispose();
    super.dispose();
  }

  Future<void> _selectEventDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _eventDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _eventDate) {
      setState(() {
        _eventDate = picked;
        _clearResults();
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _clearResults();
      });
    }
  }

  void _clearResults() {
    setState(() {
      _countdown = '';
      _hasCalculated = false;
      _timer?.cancel();
    });
  }

  void _resetCalculator() {
    setState(() {
      _eventNameController.clear();
      _eventDate = null;
      _selectedTime = null;
      _countdown = '';
      _hasCalculated = false;
      _timer?.cancel();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateCountdown();
    });
  }

  void _calculateCountdown() {
    if (_eventDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.getTranslation(
              widget.currentLanguage, 'Please select a date')),
        ),
      );
      return;
    }

    final now = DateTime.now();
    DateTime eventDateTime = DateTime(
      _eventDate!.year,
      _eventDate!.month,
      _eventDate!.day,
      _selectedTime?.hour ?? 0,
      _selectedTime?.minute ?? 0,
    );

    if (eventDateTime.isBefore(now)) {
      setState(() {
        _countdown = Translations.getTranslation(
            widget.currentLanguage, 'Event has already passed');
        _hasCalculated = true;
        _timer?.cancel();
      });
      return;
    }

    final difference = eventDateTime.difference(now);
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    final daysStr = Translations.formatNumber(widget.currentLanguage, days,
        decimalDigits: 0);
    final hoursStr = Translations.formatNumber(widget.currentLanguage, hours,
        decimalDigits: 0);
    final minutesStr = Translations.formatNumber(
        widget.currentLanguage, minutes,
        decimalDigits: 0);
    final secondsStr = Translations.formatNumber(
        widget.currentLanguage, seconds,
        decimalDigits: 0);

    setState(() {
      _countdown =
          '$daysStr${Translations.getTranslation(widget.currentLanguage, 'd_short')} '
          '$hoursStr${Translations.getTranslation(widget.currentLanguage, 'h_short')} '
          '$minutesStr${Translations.getTranslation(widget.currentLanguage, 'm_short')} '
          '$secondsStr${Translations.getTranslation(widget.currentLanguage, 's_short')}';
      _hasCalculated = true;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translations.getTranslation(
              widget.currentLanguage, 'Event Countdown'),
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
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        Translations.getTranslation(
                            widget.currentLanguage, 'Include Time'),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Switch(
                      value: _includeTime,
                      onChanged: (value) {
                        setState(() {
                          _includeTime = value;
                          if (!_includeTime) {
                            _selectedTime = null;
                          }
                          _clearResults();
                        });
                      },
                      activeColor: UnifiedPageDesign.accentColor,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _selectEventDate(context),
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
                                Translations.getTranslation(
                                    widget.currentLanguage, 'Event Date'),
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _eventDate != null
                                    ? Translations.formatDate(
                                        widget.currentLanguage,
                                        _eventDate!,
                                        pattern: 'MMMM d, yyyy',
                                      )
                                    : Translations.getTranslation(
                                        widget.currentLanguage, 'Select date'),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _eventDate != null
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
                if (_includeTime) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _selectTime(context),
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
                                  Translations.getTranslation(
                                      widget.currentLanguage, 'Time'),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _selectedTime != null
                                      ? _selectedTime!.format(context)
                                      : Translations.getTranslation(
                                          widget.currentLanguage,
                                          'Select time'),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _selectedTime != null
                                        ? UnifiedPageDesign.accentColor
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
              ],
            ),
            const SizedBox(height: 16),
            UnifiedPrimaryButton(
              text: Translations.getTranslation(
                  widget.currentLanguage, 'Calculate'),
              icon: Icons.calculate,
              onPressed: _calculateCountdown,
            ),
            if (_hasCalculated && _countdown.isNotEmpty) ...[
              const SizedBox(height: 16),
              UnifiedResultCard(
                title: Translations.getTranslation(
                    widget.currentLanguage, 'Time Until Event'),
                value: _countdown,
                icon: Icons.timer,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
