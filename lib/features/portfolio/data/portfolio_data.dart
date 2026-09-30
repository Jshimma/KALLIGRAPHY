import '../../../shared/models/portfolio_category.dart';
import '../../../shared/models/portfolio_photo.dart';

abstract final class PortfolioData {
  static const categories = [
    PortfolioCategory(id: 'all', name: 'All', slug: 'all', displayOrder: 0),
    PortfolioCategory(
      id: 'portraits',
      name: 'Portraits',
      slug: 'portraits',
      displayOrder: 1,
    ),
    PortfolioCategory(
      id: 'weddings',
      name: 'Weddings',
      slug: 'weddings',
      displayOrder: 2,
    ),
    PortfolioCategory(
      id: 'events',
      name: 'Events',
      slug: 'events',
      displayOrder: 3,
    ),
    PortfolioCategory(
      id: 'editorial',
      name: 'Editorial',
      slug: 'editorial',
      displayOrder: 4,
    ),
    PortfolioCategory(
      id: 'fashion',
      name: 'Fashion',
      slug: 'fashion',
      displayOrder: 5,
    ),
    PortfolioCategory(
      id: 'lifestyle',
      name: 'Lifestyle',
      slug: 'lifestyle',
      displayOrder: 6,
    ),
  ];

  static const photos = <PortfolioPhoto>[];
}
