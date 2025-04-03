import 'package:flutter/material.dart';
import '../models/alarm.dart';
import '../constants.dart';
import '../utils/time_utils.dart';

class AlarmCard extends StatelessWidget {
  final Alarm alarm;
  final Function(bool)? onToggle;
  final VoidCallback? onTap;

  const AlarmCard({
    super.key,
    required this.alarm,
    this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultMargin,
          vertical: AppConstants.defaultMargin / 2,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Days row
                    Text(
                      TimeUtils.formatDays(alarm.days, context),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withAlpha(200),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Time row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          alarm.time,
                          style: textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          alarm.period,
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface.withAlpha(255),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      alarm.title,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              // Toggle switch
              Switch(
                value: alarm.isEnabled,
                onChanged: (value) {
                  onToggle?.call(value);
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
