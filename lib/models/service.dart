class Service {
  const Service({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.durationMinutes,
    required this.inclusions,
    this.imageUrl,
  });

  final String id;
  final String categoryId;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int reviewCount;
  final int durationMinutes;
  final List<String> inclusions;

  /// Optional remote image. When null (or it fails to load) the UI shows a
  /// themed illustration, so the app works fully offline.
  final String? imageUrl;
}
