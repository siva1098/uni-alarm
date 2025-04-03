import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/alarm.dart';
import '../services/database_helper.dart';
import '../utils/time_utils.dart';
import '../widgets/alarm_card.dart';
import 'add_alarm_page.dart';

class HomePage extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onThemeToggle;

  const HomePage({
    super.key,
    required this.themeMode,
    required this.onThemeToggle,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Alarm> _alarms = [];

  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    final alarms = await _dbHelper.getAlarms();

    setState(() {
      _alarms = alarms;
    });
  }

  void _showAlarmNotification(Alarm alarm) {
    if (!alarm.isEnabled) return;

    final description = TimeUtils.getAlarmDescription(
      alarm.time,
      alarm.period,
      alarm.days,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              alarm.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(description),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _addAlarm() async {
    final result = await Navigator.push<Alarm>(
      context,
      MaterialPageRoute(builder: (context) => const AddAlarmPage()),
    );

    if (result != null) {
      await _dbHelper.insertAlarm(result);
      _loadAlarms();
      _showAlarmNotification(result);
    }
  }

  void _toggleAlarm(Alarm alarm) async {
    final updatedAlarm = alarm.copyWith(isEnabled: !alarm.isEnabled);
    if (alarm.id != null) {
      await _dbHelper.updateAlarm(alarm.id!, updatedAlarm);
      setState(() {});
      _loadAlarms();
      _showAlarmNotification(updatedAlarm);
    }
  }

  void _editAlarm(Alarm alarm) async {
    final result = await Navigator.push<Alarm>(
      context,
      MaterialPageRoute(
        builder: (context) => AddAlarmPage(alarm: alarm),
      ),
    );

    if (result != null && result.id != null) {
      await _dbHelper.updateAlarm(result.id!, result);
      _loadAlarms();
      _showAlarmNotification(result);
    }
    setState(() {});
  }

  Future<void> _duplicateAlarm(Alarm alarm) async {
    final duplicatedAlarm = Alarm(
      title: '${alarm.title} (copy)',
      time: alarm.time,
      period: alarm.period,
      days: List.from(alarm.days),
      isEnabled: alarm.isEnabled,
    );

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Duplicate Alarm'),
        content: Text('Do you want to duplicate "${alarm.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Duplicate'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _dbHelper.insertAlarm(duplicatedAlarm);
      _loadAlarms();
    }
    setState(() {});
  }

  Future<void> _deleteAlarm(Alarm alarm) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Alarm'),
        content: Text('Are you sure you want to delete "${alarm.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true && alarm.id != null) {
      await _dbHelper.deleteAlarm(alarm.id!);
      _loadAlarms();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UnAlarm'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              widget.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
      body: _alarms.isEmpty
          ? Center(
              child: Text(
                'No alarms yet',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _alarms.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(_alarms[index].id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return _deleteAlarm(_alarms[index]).then((_) => true);
                  },
                  child: GestureDetector(
                    onLongPress: () => _duplicateAlarm(_alarms[index]),
                    child: AlarmCard(
                      alarm: _alarms[index],
                      onToggle: (value) => _toggleAlarm(_alarms[index]),
                      onTap: () => _editAlarm(_alarms[index]),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAlarm,
        backgroundColor: AppColors.primaryDark,
        child: const Icon(Icons.add, color: AppColors.textLight),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
