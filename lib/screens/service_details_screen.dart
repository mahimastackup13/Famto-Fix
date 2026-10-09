import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:famto_mini_booking/core/formatters.dart';
import 'package:famto_mini_booking/core/router.dart';
import 'package:famto_mini_booking/core/theme.dart';
import 'package:famto_mini_booking/models/service.dart';
import 'package:famto_mini_booking/providers/booking_provider.dart';
import 'package:famto_mini_booking/providers/catalog_provider.dart';
import 'package:famto_mini_booking/widgets/bottom_action_bar.dart';
import 'package:famto_mini_booking/widgets/info_widgets.dart';
import 'package:famto_mini_booking/widgets/responsive_center.dart';
import 'package:famto_mini_booking/widgets/section_title.dart';
import 'package:famto_mini_booking/widgets/service_card.dart';
import 'package:famto_mini_booking/widgets/service_image.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key, required this.service});

  final Service service;

  void _book(BuildContext context) {
    context.read<BookingProvider>().startNewBooking();
    Navigator.of(context).pushNamed(AppRoutes.booking, arguments: service);
  }

  @override
  Widget build(BuildContext context) {
    final category =
        context.read<CatalogProvider>().categoryById(service.categoryId);
    final accent = category?.color ?? AppColors.primary;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            backgroundColor: accent,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  tooltip: 'Back',
                  icon: const Icon(Icons.arrow_back, size: 20),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: ServiceImage(
                service: service,
                radius: 0,
                iconSize: 96,
                heroTag: serviceHeroTag(service),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ResponsiveCenter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    child: Text(
                      service.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: StatTile(
                            icon: Icons.star_rounded,
                            iconColor: AppColors.star,
                            label: '${service.reviewCount} reviews',
                            value: service.rating.toStringAsFixed(1),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: StatTile(
                            icon: Icons.schedule,
                            label: 'Duration',
                            value: Formatters.duration(service.durationMinutes),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: StatTile(
                            icon: Icons.sell_outlined,
                            label: 'Starting at',
                            value: Formatters.price(service.price),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SectionTitle(title: 'About this service'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      service.description,
                      style: const TextStyle(
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SectionTitle(title: "What's included"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        for (final item in service.inclusions)
                          _BulletRow(text: item, icon: Icons.check_circle),
                      ],
                    ),
                  ),
                  const SectionTitle(title: 'Good to know'),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _BulletRow(
                          text: 'Pay only after the job is done',
                          icon: Icons.payments_outlined,
                          color: AppColors.primary,
                        ),
                        _BulletRow(
                          text: 'Free rescheduling up to 2 hours before',
                          icon: Icons.event_repeat,
                          color: AppColors.primary,
                        ),
                        _BulletRow(
                          text: '30-day warranty on workmanship',
                          icon: Icons.shield_outlined,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        topLabel: 'Starting at',
        priceLabel: Formatters.price(service.price),
        buttonLabel: 'Book Now',
        onPressed: () => _book(context),
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({
    required this.text,
    required this.icon,
    this.color = AppColors.success,
  });

  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
