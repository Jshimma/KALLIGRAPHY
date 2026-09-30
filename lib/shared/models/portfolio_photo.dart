class PortfolioPhoto {
  final String id;
  final String title;
  final String? description;
  final String? categoryId;
  final String? location;
  final String? capturedAt;
  final bool featured;
  final int displayOrder;
  final String thumbnailUrl;
  final String previewUrl;

  const PortfolioPhoto({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.previewUrl,
    this.description,
    this.categoryId,
    this.location,
    this.capturedAt,
    this.featured = false,
    this.displayOrder = 0,
  });

  factory PortfolioPhoto.fromJson(Map<String, dynamic> json) {
    return PortfolioPhoto(
      id: json['id'].toString(),
      title: json['title'] as String,
      categoryId: json['category_id']?.toString(),
      description: json['description'] as String?,
      location: json['location'] as String?,
      capturedAt: json['captured_at'] as String?,
      featured: json['featured'] as bool? ?? false,
      displayOrder: json['display_order'] as int? ?? 0,
      thumbnailUrl: json['thumbnail_url'] as String,
      previewUrl: json['preview_url'] as String,
    );
  }
}
