import 'package:flutter/foundation.dart';

import 'package:famto_mini_booking/data/service_repository.dart';
import 'package:famto_mini_booking/models/booking.dart';
import 'package:famto_mini_booking/models/service.dart';
import 'package:famto_mini_booking/models/time_slot.dart';

/// Owns the in-progress booking: chosen date, slot and submission state.
/// Form text lives in the screen's controllers and is passed on [submit].
class BookingProvider extends ChangeNotifier {
  BookingProvider(this._repository) {
    _date = dates.first;
  }

  final ServiceRepository _repository;

  late DateTime _date;
  TimeSlot? _slot;
  bool _isSubmitting = false;
  String? _errorMessage;
  Booking? _lastBooking;

  DateTime get selectedDate => _date;
  TimeSlot? get selectedSlot => _slot;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  Booking? get lastBooking => _lastBooking;

  /// Today + the next 6 days.
  List<DateTime> get dates {
    final now = DateTime.now();
    return List.generate(
      7,
      (i) => DateTime(now.year, now.month, now.day + i),
    );
  }

  /// Resets state for a fresh booking and picks the first day that still has
  /// at least one open slot.
  void startNewBooking() {
    _slot = null;
    _errorMessage = null;
    _isSubmitting = false;
    _date = dates.firstWhere(
      (d) => TimeSlot.all.any(
        (s) => availabilityOf(s, date: d) == SlotAvailability.available,
      ),
      orElse: () => dates.first,
    );
    notifyListeners();
  }

  /// Mock availability: slots less than an hour away are unavailable and a
  /// deterministic subset is "already booked" so the UI has realistic states.
  SlotAvailability availabilityOf(TimeSlot slot, {DateTime? date}) {
    final day = date ?? _date;
    final soonest = DateTime.now().add(const Duration(hours: 1));
    if (slot.on(day).isBefore(soonest)) return SlotAvailability.unavailable;
    if ((day.day + slot.hour) % 4 == 0) return SlotAvailability.booked;
    return SlotAvailability.available;
  }

  void selectDate(DateTime date) {
    _date = date;
    if (_slot != null &&
        availabilityOf(_slot!) != SlotAvailability.available) {
      _slot = null;
    }
    notifyListeners();
  }

  void selectSlot(TimeSlot slot) {
    if (availabilityOf(slot) != SlotAvailability.available) return;
    _slot = slot;
    notifyListeners();
  }

  /// Returns true on success; on failure [errorMessage] is populated.
  Future<bool> submit({
    required Service service,
    required String customerName,
    required String phone,
    required String address,
  }) async {
    final slot = _slot;
    if (slot == null || _isSubmitting) return false;
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _lastBooking = await _repository.createBooking(
        service: service,
        date: _date,
        slot: slot,
        customerName: customerName,
        phone: phone,
        address: address,
      );
      _isSubmitting = false;
      notifyListeners();
      return true;
    } on ServiceException catch (e) {
      _errorMessage = e.message;
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }
}
