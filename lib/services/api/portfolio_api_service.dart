import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../shared/models/portfolio_category.dart';
import '../../shared/models/portfolio_photo.dart';
import 'api_config.dart';

class PortfolioApiService {
  const PortfolioApiService();

  Future<List<PortfolioCategory>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/portfolio/categories'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load portfolio categories: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as List<dynamic>;

    return data
        .map((item) => PortfolioCategory.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<PortfolioPhoto>> fetchPhotos() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/portfolio/photos'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load portfolio photos: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as List<dynamic>;

    return data
        .map((item) => PortfolioPhoto.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
