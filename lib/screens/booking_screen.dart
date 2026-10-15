import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:famto_mini_booking/core/formatters.dart';
import 'package:famto_mini_booking/core/router.dart';
import 'package:famto_mini_booking/core/theme.dart';
import 'package:famto_mini_booking/core/validators.dart';
import 'package:famto_mini_booking/models/service.dart';
import 'package:famto_mini_booking/models/time_slot.dart';
import 'package:famto_mini_booking/providers/booking_provider.dart';
import 'package:famto_mini_booking/widgets/app_card.dart';
import 'package:famto_mini_booking/widgets/app_text_field.dart';
import 'package:famto_mini_booking/widgets/bottom_action_bar.dart';
import 'package:famto_mini_booking/widgets/date_selector.dart';
import 'package:famto_mini_booking/widgets/info_widgets.dart';
import 'package:famto_mini_booking/widgets/responsive_center.dart';
import 'package:famto_mini_booking/widgets/section_title.dart';
import 'package:famto_mini_booking/widgets/service_image.dart';
import 'package:famto_mini_booking/widgets/time_slot_picker.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, required this.service});

  final Service service;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneFocus = FocusNode();
  final _addressFocus = FocusNode();
  bool _showSlotError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _phoneFocus.dispose();
    _addressFocus.dispose();
    super.dispose();
  }

  void _toast(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), action: action));
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final booking = context.read<BookingProvider>();

    final slotMissing = booking.selectedSlot == null;
    final formValid = _formKey.currentState!.validate();
    setState(() => _showSlotError = slotMissing);

    if (slotMissing) {
      _toast('Please choose a time slot');
      return;
    }
    if (!formValid) {
      _toast('Please fix the highlighted fields');
      return;
    }
    final success = await booking.submit(
      service: widget.service,
      customerName: _nameController.text.trim(),
      phone: _phoneController.text.replaceAll(RegExp(r'\s+'), ''),
      address: _addressController.text.trim(),
    );
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.confirmation,
        (route) => route.isFirst,
        arguments: booking.lastBooking,
      );
    } else {
      _toast(
        booking.errorMessage ?? 'Booking failed. Please try again.',
        action: SnackBarAction(label: 'Retry', onPressed: _submit),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final service = widget.service;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Book service')),
        body: ResponsiveCenter(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                _ServiceSummary(service: service),
                const SectionTitle(
                  step: 1,
                  title: 'Choose a date',
                  padding: EdgeInsets.only(top: 24, bottom: 12),
                ),
                DateSelector(
                  dates: booking.dates,
                  selected: booking.selectedDate,
                  onSelected: booking.selectDate,
                ),
                SectionTitle(
                  step: 2,
                  title: 'Choose a time slot',
                  subtitle: Formatters.date(booking.selectedDate),
                  padding: const EdgeInsets.only(top: 24, bottom: 12),
                ),
                TimeSlotPicker(
                  slots: TimeSlot.all,
                  selected: booking.selectedSlot,
                  availabilityOf: booking.availabilityOf,
                  onSelected: (slot) {
                    setState(() => _showSlotError = false);
                    booking.selectSlot(slot);
                  },
                ),
                const SizedBox(height: 8),
                if (_showSlotError)
                  const Text(
                    'Please select a time slot to continue',
                    style: TextStyle(color: AppColors.error, fontSize: 12),
                  )
                else
                  const Text(
                    'Struck-through slots are already booked or too soon to schedule.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                const SectionTitle(
                  step: 3,
                  title: 'Your details',
                  padding: EdgeInsets.only(top: 24, bottom: 12),
                ),
                AppTextField(
                  controller: _nameController,
                  label: 'Full name',
                  icon: Icons.person_outline,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  validator: Validators.name,
                  inputFormatters: [LengthLimitingTextInputFormatter(50)],
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  label: 'Mobile number',
                  hint: '98765 43210',
                  icon: Icons.phone_outlined,
                  prefixText: '+91  ',
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  maxLength: 10,
                  autofillHints: const [AutofillHints.telephoneNumberNational],
                  validator: Validators.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _addressController,
                  focusNode: _addressFocus,
                  label: 'Service address',
                  hint: 'House no., street, area, landmark',
                  icon: Icons.location_on_outlined,
                  maxLines: 3,
                  maxLength: 200,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.streetAddress,
                  autofillHints: const [AutofillHints.fullStreetAddress],
                  validator: Validators.address,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.primary),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'No advance payment. Pay after the service is completed. '
                          'Free rescheduling up to 2 hours before your slot.',
                          style: TextStyle(fontSize: 13, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomActionBar(
          topLabel: 'Total',
          priceLabel: Formatters.price(service.price),
          buttonLabel: 'Confirm Booking',
          isLoading: booking.isSubmitting,
          onPressed: _submit,
        ),
      ),
    );
  }
}

class _ServiceSummary extends StatelessWidget {
  const _ServiceSummary({required this.service});

  final Service service;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      radius: 20,
      child: Row(
        children: [
          ServiceImage(service: service, width: 60, height: 60, radius: 14, iconSize: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    InfoChip(
                      icon: Icons.schedule,
                      label: Formatters.duration(service.durationMinutes),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      Formatters.price(service.price),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
