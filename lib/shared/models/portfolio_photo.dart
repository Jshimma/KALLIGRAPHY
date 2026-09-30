class PortfolioPhoto {
  final String id;
  final String title;
  final String imageUrl;
  final String? description;
  final String categoryId;
  final String? location;
  final String? capturedAt;
  final bool featured;
  final int displayOrder;

  const PortfolioPhoto({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.categoryId,
    this.description,
    this.location,
    this.capturedAt,
    this.featured = false,
    this.displayOrder = 0,
  });
}
