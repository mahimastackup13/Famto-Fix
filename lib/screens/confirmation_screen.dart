import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:famto_mini_booking/core/formatters.dart';
import 'package:famto_mini_booking/core/theme.dart';
import 'package:famto_mini_booking/models/booking.dart';
import 'package:famto_mini_booking/widgets/app_card.dart';
import 'package:famto_mini_booking/widgets/info_widgets.dart';
import 'package:famto_mini_booking/widgets/responsive_center.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key, required this.booking});

  final Booking booking;

  void _goHome(BuildContext context) =>
      Navigator.of(context).popUntil((route) => route.isFirst);

  Future<void> _copyId(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: booking.id));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Booking ID copied')));
  }

  @override
  Widget build(BuildContext context) {
    final service = booking.service;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: ResponsiveCenter(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                    child: Column(
                      children: [
                        const _SuccessBadge(),
                        const SizedBox(height: 20),
                        const Text(
                          'Booking confirmed!',
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your professional will arrive during the selected slot. '
                          'We will call you before they set out.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () => _copyId(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Booking ID  ${booking.id}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.copy_rounded,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        AppCard(
                          child: Column(
                            children: [
                              DetailRow(
                                icon: Icons.home_repair_service_outlined,
                                label: 'Service',
                                value: service.name,
                              ),
                              const _Gap(),
                              DetailRow(
                                icon: Icons.event_outlined,
                                label: 'Date',
                                value: Formatters.date(booking.date),
                              ),
                              const _Gap(),
                              DetailRow(
                                icon: Icons.schedule,
                                label: 'Time slot',
                                value: booking.slot.rangeLabel,
                              ),
                              const _Gap(),
                              DetailRow(
                                icon: Icons.person_outline,
                                label: 'Customer',
                                value: '${booking.customerName}\n+91 ${booking.phone}',
                              ),
                              const _Gap(),
                              DetailRow(
                                icon: Icons.location_on_outlined,
                                label: 'Address',
                                value: booking.address,
                              ),
                              const _Gap(),
                              DetailRow(
                                icon: Icons.payments_outlined,
                                label: 'Amount to pay after service',
                                value: Formatters.price(service.price),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: FilledButton(
                    onPressed: () => _goHome(context),
                    child: const Text('Back to Home'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Gap extends StatelessWidget {
  const _Gap();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Divider(height: 1, color: AppColors.border),
      );
}

class _SuccessBadge extends StatelessWidget {
  const _SuccessBadge();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.elasticOut,
      builder: (context, value, child) =>
          Transform.scale(scale: value, child: child),
      child: Container(
        width: 104,
        height: 104,
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_circle_rounded,
          size: 72,
          color: AppColors.success,
        ),
      ),
    );
  }
}
