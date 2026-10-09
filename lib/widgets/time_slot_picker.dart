import 'package:flutter/material.dart';

import 'package:famto_mini_booking/core/theme.dart';
import 'package:famto_mini_booking/models/time_slot.dart';

class TimeSlotPicker extends StatelessWidget {
  const TimeSlotPicker({
    super.key,
    required this.slots,
    required this.selected,
    required this.availabilityOf,
    required this.onSelected,
  });

  final List<TimeSlot> slots;
  final TimeSlot? selected;
  final SlotAvailability Function(TimeSlot slot) availabilityOf;
  final ValueChanged<TimeSlot> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final slot in slots) _chip(slot),
      ],
    );
  }

  Widget _chip(TimeSlot slot) {
    final available = availabilityOf(slot) == SlotAvailability.available;
    final isSelected = slot == selected;
    return ChoiceChip(
      label: Text(slot.startLabel),
      selected: isSelected,
      showCheckmark: false,
      onSelected: available ? (_) => onSelected(slot) : null,
      selectedColor: AppColors.primary,
      backgroundColor: Colors.white,
      disabledColor: const Color(0xFFF0F0F5),
      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: isSelected
            ? Colors.white
            : available
                ? AppColors.textPrimary
                : AppColors.textSecondary.withOpacity(0.55),
        decoration: available ? null : TextDecoration.lineThrough,
      ),
    );
  }
}
