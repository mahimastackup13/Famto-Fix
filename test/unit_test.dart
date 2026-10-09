import 'package:flutter_test/flutter_test.dart';

import 'package:famto_mini_booking/core/formatters.dart';
import 'package:famto_mini_booking/core/validators.dart';
import 'package:famto_mini_booking/data/service_repository.dart';
import 'package:famto_mini_booking/models/time_slot.dart';
import 'package:famto_mini_booking/providers/booking_provider.dart';

void main() {
  group('Validators', () {
    test('name', () {
      expect(Validators.name(''), isNotNull);
      expect(Validators.name('Al'), isNotNull);
      expect(Validators.name('R2D2'), isNotNull);
      expect(Validators.name('Anjali Menon'), isNull);
    });

    test('phone', () {
      expect(Validators.phone(''), isNotNull);
      expect(Validators.phone('12345'), isNotNull);
      expect(Validators.phone('5123456789'), isNotNull);
      expect(Validators.phone('98765 43210'), isNull);
    });

    test('address', () {
      expect(Validators.address(''), isNotNull);
      expect(Validators.address('Kochi'), isNotNull);
      expect(Validators.address('12/4, MG Road, near Metro'), isNull);
    });
  });

  group('Formatters & models', () {
    test('duration', () {
      expect(Formatters.duration(45), '45 min');
      expect(Formatters.duration(120), '2 hr');
      expect(Formatters.duration(90), '1 hr 30 min');
    });

    test('time slot labels', () {
      expect(const TimeSlot(9).startLabel, '9:00 AM');
      expect(const TimeSlot(12).startLabel, '12:00 PM');
      expect(const TimeSlot(14).rangeLabel, '2:00 PM – 3:00 PM');
    });
  });

  group('BookingProvider', () {
    test('offers 7 days starting today', () {
      final provider = BookingProvider(ServiceRepository());
      expect(provider.dates.length, 7);
    });

    test('cannot select a slot that is in the past', () {
      final provider = BookingProvider(ServiceRepository());
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      provider.selectDate(today);
      // 9 AM today is unavailable whenever it is already after 8 AM.
      if (now.hour >= 8) {
        provider.selectSlot(const TimeSlot(9));
        expect(provider.selectedSlot, isNull);
      }
    });
  });
}
