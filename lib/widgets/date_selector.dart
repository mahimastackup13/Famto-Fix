import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:famto_mini_booking/core/theme.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({
    super.key,
    required this.dates,
    required this.selected,
    required this.onSelected,
  });

  final List<DateTime> dates;
  final DateTime selected;
  final ValueChanged<DateTime> onSelected;

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _sameDay(date, selected);
          final fg = isSelected ? Colors.white : AppColors.textPrimary;
          final subFg = isSelected ? Colors.white70 : AppColors.textSecondary;
          return Semantics(
            button: true,
            selected: isSelected,
            label: DateFormat('EEEE, d MMMM').format(date),
            child: Material(
              color: isSelected ? AppColors.primary : Colors.white,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: InkWell(
                onTap: () => onSelected(date),
                child: SizedBox(
                  width: 66,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        index == 0 ? 'Today' : DateFormat('EEE').format(date),
                        style: TextStyle(fontSize: 12, color: subFg),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: fg,
                        ),
                      ),
                      Text(
                        DateFormat('MMM').format(date),
                        style: TextStyle(fontSize: 12, color: subFg),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
