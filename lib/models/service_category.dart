import 'package:flutter/material.dart';

class ServiceCategory {
  const ServiceCategory({
    required this.id,
    required this.name,
    required this.tagline,
    required this.icon,
    required this.color,
    this.imagePath,
  });

  final String id;
  final String name;
  final String tagline;
  final IconData icon;
  final Color color;

  final String? imagePath;
}
