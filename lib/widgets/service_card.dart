import 'package:flutter/material.dart';

import 'package:famto_mini_booking/core/formatters.dart';
import 'package:famto_mini_booking/core/theme.dart';
import 'package:famto_mini_booking/models/service.dart';
import 'package:famto_mini_booking/widgets/app_card.dart';
import 'package:famto_mini_booking/widgets/info_widgets.dart';
import 'package:famto_mini_booking/widgets/service_image.dart';

String serviceHeroTag(Service s) => 'service-image-${s.id}';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.service, required this.onTap});

  final Service service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      radius: 20,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ServiceImage(
            service: service,
            width: 88,
            height: 88,
            heroTag: serviceHeroTag(service),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    RatingBadge(rating: service.rating),
                    InfoChip(
                      icon: Icons.schedule,
                      label: Formatters.duration(service.durationMinutes),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  Formatters.price(service.price),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
