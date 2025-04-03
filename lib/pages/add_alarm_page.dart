import 'package:flutter/material.dart';

import '../models/alarm.dart';

class AddAlarmPage extends StatefulWidget {
  final Alarm? alarm; // Pass existing alarm for editing

  const AddAlarmPage({
    super.key,
    this.alarm,
  });

  @override
  State<AddAlarmPage> createState() => _AddAlarmPageState();
}

class _AddAlarmPageState extends State<AddAlarmPage> {
  late TimeOfDay _selectedTime;
  late TextEditingController _nameController;
  final List<String> _weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  late List<String> _selectedDays;
  late bool _isVibrationEnabled;
  late double _volume;

  @override
  void initState() {
    super.initState();
    // Initialize with existing alarm data if editing
    if (widget.alarm != null) {
      final timeParts = widget.alarm!.time.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      _selectedTime = TimeOfDay(
        hour: widget.alarm!.period == 'PM' && hour != 12 ? hour + 12 : hour,
        minute: minute,
      );
      _nameController = TextEditingController(text: widget.alarm!.title);
      _selectedDays = List.from(widget.alarm!.days);
    } else {
      _selectedTime = TimeOfDay.now();
      _nameController = TextEditingController();
      _selectedDays = List.empty();
    }
    _isVibrationEnabled = false;
    _volume = 0.7;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _toggleDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.alarm != null ? 'Edit Alarm' : 'Add Alarm'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              final newAlarm = Alarm(
                id: widget.alarm?.id, // Preserve ID if editing
                title: _nameController.text.isEmpty
                    ? 'Alarm'
                    : _nameController.text,
                time:
                    '${_selectedTime.hourOfPeriod.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                period: _selectedTime.period == DayPeriod.am ? 'AM' : 'PM',
                days: List.from(_selectedDays),
                isEnabled: widget.alarm?.isEnabled ?? true,
              );
              Navigator.pop(context, newAlarm);
            },
            child: Text(
              'Save',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Time Picker
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'AM',
                        style: textTheme.titleMedium?.copyWith(
                          color: _selectedTime.period == DayPeriod.am
                              ? colorScheme.primary
                              : colorScheme.onSurface.withAlpha(150),
                        ),
                      ),
                      const SizedBox(width: 32),
                      Text(
                        'PM',
                        style: textTheme.titleMedium?.copyWith(
                          color: _selectedTime.period == DayPeriod.pm
                              ? colorScheme.primary
                              : colorScheme.onSurface.withAlpha(150),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (time != null) {
                        setState(() => _selectedTime = time);
                      }
                    },
                    child: Text(
                      '${_selectedTime.hourOfPeriod.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                      style: textTheme.displayLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Day Selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Repeat',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _weekDays.map((day) {
                      final isSelected = _selectedDays.contains(day);
                      return GestureDetector(
                        onTap: () => _toggleDay(day),
                        child: CircleAvatar(
                          backgroundColor: isSelected
                              ? colorScheme.primary
                              : colorScheme.surface,
                          child: Text(
                            day[0],
                            style: TextStyle(
                              color: isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurface,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Alarm Name
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alarm name',
                    style: textTheme.titleMedium,
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter alarm name',
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Alarm Sound
          Card(
            child: ListTile(
              title: Text(
                'Alarm sound',
                style: textTheme.titleMedium,
              ),
              trailing: Text(
                'Default',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withAlpha(255),
                ),
              ),
              onTap: () {
                // TODO: Implement sound selection
              },
            ),
          ),
          const SizedBox(height: 16),

          // Volume Slider
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alarm volume',
                    style: textTheme.titleMedium,
                  ),
                  Slider(
                    value: _volume,
                    onChanged: (value) => setState(() => _volume = value),
                    activeColor: colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Vibration Toggle
          Card(
            child: ListTile(
              title: Text(
                'Alarm with vibration',
                style: textTheme.titleMedium,
              ),
              trailing: Switch(
                value: _isVibrationEnabled,
                onChanged: (value) =>
                    setState(() => _isVibrationEnabled = value),
                activeColor: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
