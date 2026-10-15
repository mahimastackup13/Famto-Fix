enum SlotAvailability { available, booked, unavailable }

class TimeSlot {
  const TimeSlot(this.hour);

  final int hour;

  static const List<TimeSlot> all = [
    TimeSlot(9),
    TimeSlot(10),
    TimeSlot(11),
    TimeSlot(12),
    TimeSlot(14),
    TimeSlot(15),
    TimeSlot(16),
    TimeSlot(17),
  ];

  DateTime on(DateTime date) =>
      DateTime(date.year, date.month, date.day, hour);

  String get startLabel => _format(hour);
  String get rangeLabel => '${_format(hour)} – ${_format(hour + 1)}';

  static String _format(int h) {
    final h12 = h % 12 == 0 ? 12 : h % 12;
    final period = h >= 12 ? 'PM' : 'AM';
    return '$h12:00 $period';
  }

  @override
  bool operator ==(Object other) => other is TimeSlot && other.hour == hour;

  @override
  int get hashCode => hour.hashCode;
}
