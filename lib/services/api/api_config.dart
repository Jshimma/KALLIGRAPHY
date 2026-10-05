import 'package:flutter/foundation.dart';

abstract final class ApiConfig {
  static const String _configuredUrl = String.fromEnvironment(
    'KALLYGRAPHY_API_URL',
    defaultValue: '',
  );

  static String get baseUrl {
    if (_configuredUrl.isNotEmpty) {
      return _configuredUrl.replaceFirst(RegExp(r'/$'), '');
    }

    if (kIsWeb) {
      final uri = Uri.base;

      // During Codespaces development the frontend is served on 8080
      // and FastAPI on 8000. Keep the same public host and switch ports.
      if (uri.host.endsWith('.app.github.dev')) {
        return '${uri.scheme}://${uri.host.replaceFirst('-8080.', '-8000.')}';
      }

      // Same-origin deployment: the reverse proxy can expose /api.
      return '${uri.scheme}://${uri.host}/api';
    }

    return 'http://127.0.0.1:8000';
  }
}
