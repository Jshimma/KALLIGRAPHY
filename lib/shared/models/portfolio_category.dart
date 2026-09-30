class PortfolioCategory {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? coverImage;
  final int displayOrder;

  const PortfolioCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.coverImage,
    this.displayOrder = 0,
  });
}
