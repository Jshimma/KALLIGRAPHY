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

  factory PortfolioCategory.fromJson(Map<String, dynamic> json) {
    return PortfolioCategory(
      id: json['id'].toString(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      coverImage: json['cover_image'] as String?,
      displayOrder: json['display_order'] as int? ?? 0,
    );
  }
}
