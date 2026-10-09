import 'package:famto_mini_booking/data/mock_data.dart';
import 'package:famto_mini_booking/models/booking.dart';
import 'package:famto_mini_booking/models/service.dart';
import 'package:famto_mini_booking/models/service_category.dart';
import 'package:famto_mini_booking/models/time_slot.dart';

class ServiceException implements Exception {
  const ServiceException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Data access layer. Today it serves local mock data with simulated network
/// latency; replacing it with a REST client needs no UI/provider changes.
class ServiceRepository {
  /// Demo switch (Home screen menu) to exercise error states.
  bool simulateError = false;

  static const _latency = Duration(milliseconds: 800);

  Future<List<ServiceCategory>> fetchCategories() async {
    await Future<void>.delayed(_latency);
    _failIfNeeded();
    return MockData.categories;
  }

  Future<List<Service>> fetchServices(String categoryId) async {
    await Future<void>.delayed(_latency);
    _failIfNeeded();
    return MockData.services.where((s) => s.categoryId == categoryId).toList();
  }

  Future<Booking> createBooking({
    required Service service,
    required DateTime date,
    required TimeSlot slot,
    required String customerName,
    required String phone,
    required String address,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    _failIfNeeded();
    final now = DateTime.now();
    final suffix =
        (now.millisecondsSinceEpoch % 1000000).toString().padLeft(6, '0');
    return Booking(
      id: 'FM$suffix',
      service: service,
      date: date,
      slot: slot,
      customerName: customerName,
      phone: phone,
      address: address,
      createdAt: now,
    );
  }

  void _failIfNeeded() {
    if (simulateError) {
      throw const ServiceException(
        'We could not reach the server. Please check your connection and try again.',
      );
    }
  }
}
