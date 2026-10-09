import 'package:famto_mini_booking/models/service.dart';
import 'package:famto_mini_booking/models/time_slot.dart';

class Booking {
  const Booking({
    required this.id,
    required this.service,
    required this.date,
    required this.slot,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.createdAt,
  });

  final String id;
  final Service service;
  final DateTime date;
  final TimeSlot slot;
  final String customerName;
  final String phone;
  final String address;
  final DateTime createdAt;
}
