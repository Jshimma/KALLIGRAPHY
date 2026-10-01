import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class InquiryApiService {
  Future<void> submitInquiry({
    required String name,
    required String email,
    required String service,
    String? preferredDate,
    String? location,
    String? message,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/inquiries'),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name.trim(),
        'email': email.trim(),
        'service': service,
        'preferred_date': _nullableValue(preferredDate),
        'location': _nullableValue(location),
        'message': _nullableValue(message),
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    var errorMessage = 'We could not send your inquiry. Please try again.';

    try {
      final body = jsonDecode(response.body);

      if (body is Map<String, dynamic>) {
        final detail = body['detail'];

        if (detail is String && detail.isNotEmpty) {
          errorMessage = detail;
        }
      }
    } catch (_) {
      // Keep the friendly fallback message.
    }

    throw InquiryApiException(
      message: errorMessage,
      statusCode: response.statusCode,
    );
  }

  String? _nullableValue(String? value) {
    final trimmed = value?.trim();

    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    return trimmed;
  }
}

class InquiryApiException implements Exception {
  const InquiryApiException({required this.message, required this.statusCode});

  final String message;
  final int statusCode;

  @override
  String toString() => message;
}
