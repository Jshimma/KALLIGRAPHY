abstract final class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'KALLYGRAPHY_API_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );
}
