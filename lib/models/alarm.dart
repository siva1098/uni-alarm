class Alarm {
  final int? id;
  final String title;
  final String time;
  final String period; // AM/PM
  final List<String> days;
  bool isEnabled; // Changed from final to allow toggling

  Alarm({
    this.id,
    required this.title,
    required this.time,
    required this.period,
    required this.days,
    this.isEnabled = true,
  });

  @override
  String toString() {
    return '$id $days $time $period $title $isEnabled';
  }

  // Create a copy of the alarm with updated fields
  Alarm copyWith({
    int? id,
    String? title,
    String? time,
    String? period,
    List<String>? days,
    bool? isEnabled,
  }) {
    return Alarm(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      period: period ?? this.period,
      days: days ?? this.days,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
