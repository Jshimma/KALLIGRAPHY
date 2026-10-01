import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../shared/models/inquiry.dart';
import 'api_config.dart';

class PhotographerInquiryApiService {
  const PhotographerInquiryApiService();

  Future<List<Inquiry>> fetchInquiries({required String accessToken}) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/photographer/inquiries'),
      headers: _headers(accessToken),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load inquiries: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as List<dynamic>;

    return data
        .map((item) => Inquiry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Inquiry> fetchInquiry({
    required int inquiryId,
    required String accessToken,
  }) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/photographer/inquiries/$inquiryId'),
      headers: _headers(accessToken),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load inquiry: ${response.statusCode}');
    }

    return Inquiry.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Inquiry> updateStatus({
    required int inquiryId,
    required String status,
    required String accessToken,
  }) async {
    final response = await http.patch(
      Uri.parse(
        '${ApiConfig.baseUrl}/photographer/inquiries/$inquiryId/status',
      ),
      headers: {..._headers(accessToken), 'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to update inquiry status: ${response.statusCode}',
      );
    }

    return Inquiry.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Map<String, String> _headers(String accessToken) {
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }
}
