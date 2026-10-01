import 'dart:convert';

import 'package:http/http.dart' as http;

import '../auth/auth_session.dart';
import 'api_config.dart';

class AuthApiException implements Exception {
  const AuthApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthApiService {
  const AuthApiService();

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/login'),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email.trim(), 'password': password}),
    );

    if (response.statusCode != 200) {
      String message = 'Unable to sign in. Please check your credentials.';

      try {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final detail = data['detail'];

        if (detail is String && detail.isNotEmpty) {
          message = detail;
        }
      } catch (_) {
        // Keep the user-friendly fallback message.
      }

      throw AuthApiException(message);
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final accessToken = data['access_token'];
    if (accessToken is! String || accessToken.isEmpty) {
      throw const AuthApiException(
        'The server returned an invalid authentication response.',
      );
    }

    final profile = await _fetchProfile(accessToken);

    return AuthSession(
      accessToken: accessToken,
      email: profile['email'] as String,
      fullName: profile['full_name'] as String,
      role: profile['role'] as String,
    );
  }

  Future<Map<String, dynamic>> _fetchProfile(String accessToken) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/photographer/profile'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 200) {
      throw const AuthApiException('Your account could not be verified.');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
