import 'package:flutter/material.dart';

import 'package:famto_mini_booking/core/theme.dart';
import 'package:famto_mini_booking/models/service_category.dart';
import 'package:famto_mini_booking/widgets/app_card.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category, required this.onTap});

  final ServiceCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _CategoryImage(category: category)),
          const SizedBox(height: 10),
          Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            category.tagline,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryImage extends StatelessWidget {
  const _CategoryImage({required this.category});

  final ServiceCategory category;

  @override
  Widget build(BuildContext context) {
    final iconFallback = Container(
      height: 90,
      decoration: BoxDecoration(
        color: category.color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Icon(category.icon, color: category.color, size: 32),
    );
    final path = category.imagePath;

    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: category.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: path == null
              ? iconFallback
              : Center(
                  child: Image.asset(
                    path,
                    width: 52,
                    height: 52,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => iconFallback,
                  ),
                ),
        ),
      ),
    );
  }
}
