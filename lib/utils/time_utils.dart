import 'package:flutter/material.dart';

class TimeUtils {
  static DateTime getNextAlarmTime(
      String time, String period, List<String> days) {
    final now = DateTime.now();
    final timeParts = time.split(':');
    var hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // Convert to 24-hour format
    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    // Create initial alarm time for today
    var nextAlarm = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If no days selected or days is empty, it's a one-time alarm
    if (days.isEmpty) {
      // If the time has passed for today, set it for tomorrow
      if (nextAlarm.isBefore(now)) {
        nextAlarm = nextAlarm.add(const Duration(days: 1));
      }
      return nextAlarm;
    }

    // Handle repeating alarms
    // Map day names to numbers (1 = Monday, 7 = Sunday)
    final dayMap = {
      'Mon': 1,
      'Tue': 2,
      'Wed': 3,
      'Thu': 4,
      'Fri': 5,
      'Sat': 6,
      'Sun': 7
    };

    // Handle special case for 'Weekdays'
    if (days.contains('Weekdays')) {
      days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
    }

    // Convert day names to numbers
    final dayNumbers = days.map((d) => dayMap[d] ?? 0).toList();

    // If the alarm time has passed for today, start checking from tomorrow
    if (nextAlarm.isBefore(now)) {
      nextAlarm = nextAlarm.add(const Duration(days: 1));
    }

    // Find the next occurrence
    while (!dayNumbers.contains(nextAlarm.weekday)) {
      nextAlarm = nextAlarm.add(const Duration(days: 1));
    }

    return nextAlarm;
  }

  static String getTimeUntil(DateTime alarmTime) {
    final now = DateTime.now();
    final difference = alarmTime.difference(now);

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    final List<String> parts = [];
    if (days > 0) {
      parts.add('$days ${days == 1 ? 'day' : 'days'}');
    }
    if (hours > 0) {
      parts.add('$hours ${hours == 1 ? 'hour' : 'hours'}');
    }
    if (minutes > 0 || parts.isEmpty) {
      parts.add('$minutes ${minutes == 1 ? 'minute' : 'minutes'}');
    }

    return parts.join(', ');
  }

  static String formatDays(List<String> days, BuildContext context) {
    if (days.isEmpty) {
      final nextAlarm = getNextAlarmTime(
        TimeOfDay.now().format(context).split(' ')[0],
        TimeOfDay.now().period == DayPeriod.am ? 'AM' : 'PM',
        [],
      );
      final isToday = nextAlarm.day == DateTime.now().day;
      final isTomorrow = nextAlarm.difference(DateTime.now()).inDays == 1;

      if (isToday) {
        return 'Today only';
      } else if (isTomorrow) {
        return 'Tomorrow only';
      } else {
        return 'One-time alarm';
      }
    } else if (days.contains('Weekdays')) {
      return 'Every weekday';
    }
    return 'Every ${days.join(', ')}';
  }

  static String getAlarmDescription(
      String time, String period, List<String> days) {
    final nextAlarm = getNextAlarmTime(time, period, days);
    final timeUntil = getTimeUntil(nextAlarm);

    if (days.isEmpty) {
      final isToday = nextAlarm.day == DateTime.now().day;
      final isTomorrow = nextAlarm.difference(DateTime.now()).inDays == 1;

      if (isToday) {
        return 'Rings today in $timeUntil';
      } else if (isTomorrow) {
        return 'Rings tomorrow in $timeUntil';
      }
      return 'Rings in $timeUntil';
    } else {
      return 'Next alarm in $timeUntil';
    }
  }
}
