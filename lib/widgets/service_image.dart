import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:famto_mini_booking/models/service.dart';
import 'package:famto_mini_booking/providers/catalog_provider.dart';

/// Service picture. Uses [Service.imageUrl] when present, otherwise (or when
/// offline) a gradient illustration themed with the category icon + colour.
class ServiceImage extends StatelessWidget {
  const ServiceImage({
    super.key,
    required this.service,
    this.width,
    this.height,
    this.radius = 16,
    this.iconSize = 36,
    this.heroTag,
  });

  final Service service;
  final double? width;
  final double? height;
  final double radius;
  final double iconSize;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final category = context.read<CatalogProvider>().categoryById(service.categoryId);
    final color = category?.color ?? Theme.of(context).colorScheme.primary;
    final icon = category?.icon ?? Icons.home_repair_service;

    final gradient = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.75), color],
        ),
      ),
      child: Center(
        child: Icon(icon, size: iconSize, color: Colors.white.withOpacity(0.92)),
      ),
    );

    final categoryImage = category?.imagePath;
    final Widget fallback = categoryImage == null
        ? gradient
        : Image.asset(
            categoryImage,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => gradient,
          );

    Widget content = fallback;
    final url = service.imageUrl;
    if (url != null) {
      content = Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) =>
            progress == null ? child : fallback,
        errorBuilder: (_, __, ___) => fallback,
      );
    }

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(width: width, height: height, child: content),
    );
    return heroTag == null ? image : Hero(tag: heroTag!, child: image);
  }
}
