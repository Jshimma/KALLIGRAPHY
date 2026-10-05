import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../../services/auth/auth_session.dart';
import 'api_config.dart';

class GalleryApiService {
  Future<List<GallerySummary>> fetchGalleries({
    required AuthSession session,
  }) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/photographer/galleries'),
      headers: _headers(session),
    );

    _throwIfFailed(response);

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw const GalleryApiException(
        message: 'Invalid gallery response.',
        statusCode: 200,
      );
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(GallerySummary.fromJson)
        .toList();
  }

  Future<Gallery> fetchGallery({
    required AuthSession session,
    required int galleryId,
  }) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/photographer/galleries/$galleryId'),
      headers: _headers(session),
    );

    _throwIfFailed(response);

    return Gallery.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<PortfolioPhoto>> fetchGalleryPhotos({
    required AuthSession session,
    required int galleryId,
  }) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/photographer/galleries/$galleryId/photos',
      ),
      headers: _headers(session),
    );

    _throwIfFailed(response);

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw const GalleryApiException(
        message: 'Invalid gallery photo response.',
        statusCode: 200,
      );
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(PortfolioPhoto.fromJson)
        .toList();
  }

  Future<List<PortfolioPhoto>> uploadPhotos({
    required AuthSession session,
    required int galleryId,
    required List<PlatformFile> files,
  }) async {
    if (files.isEmpty) {
      return const [];
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
        '${ApiConfig.baseUrl}/photographer/galleries/$galleryId/photos',
      ),
    );

    request.headers.addAll(_headers(session));

    for (final file in files) {
      final bytes = await file.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes('files', bytes, filename: file.name),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    _throwIfFailed(response);

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw const GalleryApiException(
        message: 'Invalid photo upload response.',
        statusCode: 200,
      );
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(PortfolioPhoto.fromJson)
        .toList();
  }

  Future<Gallery> updateGallery({
    required AuthSession session,
    required int galleryId,
    String? name,
    String? slug,
    String? description,
    String? status,
    bool? isDownloadEnabled,
    bool? isFavoritesEnabled,
    DateTime? expiresAt,
  }) async {
    final body = <String, dynamic>{};

    if (name != null) body['name'] = name.trim();
    if (slug != null) body['slug'] = slug.trim();
    if (description != null) {
      body['description'] = _nullable(description);
    }
    if (status != null) body['status'] = status;
    if (isDownloadEnabled != null) {
      body['is_download_enabled'] = isDownloadEnabled;
    }
    if (isFavoritesEnabled != null) {
      body['is_favorites_enabled'] = isFavoritesEnabled;
    }
    if (expiresAt != null) {
      body['expires_at'] = expiresAt.toUtc().toIso8601String();
    }

    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/photographer/galleries/$galleryId'),
      headers: {..._headers(session), 'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    _throwIfFailed(response);

    return Gallery.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> removePhoto({
    required AuthSession session,
    required int galleryId,
    required int photoId,
  }) async {
    final response = await http.delete(
      Uri.parse(
        '${ApiConfig.baseUrl}/photographer/galleries/'
        '$galleryId/photos/$photoId',
      ),
      headers: _headers(session),
    );

    _throwIfFailed(response);
  }

  Future<void> reorderPhotos({
    required AuthSession session,
    required int galleryId,
    required List<PortfolioPhoto> photos,
  }) async {
    final response = await http.patch(
      Uri.parse(
        '${ApiConfig.baseUrl}/photographer/galleries/'
        '$galleryId/photos/reorder',
      ),
      headers: {..._headers(session), 'Content-Type': 'application/json'},
      body: jsonEncode({
        'photos': [
          for (var index = 0; index < photos.length; index++)
            {'photo_id': photos[index].id, 'display_order': index},
        ],
      }),
    );

    _throwIfFailed(response);
  }

  Future<void> setCoverPhoto({
    required AuthSession session,
    required int galleryId,
    required int photoId,
  }) async {
    final response = await http.patch(
      Uri.parse(
        '${ApiConfig.baseUrl}/photographer/galleries/'
        '$galleryId/cover/$photoId',
      ),
      headers: _headers(session),
    );

    _throwIfFailed(response);
  }

  Future<String> createShareLink({
    required AuthSession session,
    required int galleryId,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/photographer/galleries/$galleryId/share'),
      headers: _headers(session),
    );

    _throwIfFailed(response);

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const GalleryApiException(
        message: 'Invalid share-link response.',
        statusCode: 200,
      );
    }

    final token = decoded['token'];

    if (token is! String || token.isEmpty) {
      throw const GalleryApiException(
        message: 'The server did not return a gallery link.',
        statusCode: 200,
      );
    }

    return token;
  }

  Future<void> revokeShareLink({
    required AuthSession session,
    required int galleryId,
  }) async {
    final response = await http.post(
      Uri.parse(
        '${ApiConfig.baseUrl}/photographer/galleries/$galleryId/share/revoke',
      ),
      headers: _headers(session),
    );

    _throwIfFailed(response);
  }

  Future<PublicGallery> fetchPublicGallery({required String token}) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/photographer/galleries/public/$token'),
      headers: const {'Accept': 'application/json'},
    );

    _throwIfFailed(response);

    return PublicGallery.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<Client> createClient({
    required AuthSession session,
    required String fullName,
    String? email,
    String? phone,
    String? notes,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/photographer/galleries/clients'),
      headers: {..._headers(session), 'Content-Type': 'application/json'},
      body: jsonEncode({
        'full_name': fullName.trim(),
        'email': _nullable(email),
        'phone': _nullable(phone),
        'notes': _nullable(notes),
      }),
    );

    _throwIfFailed(response);

    return Client.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Gallery> createGallery({
    required AuthSession session,
    required int clientId,
    required String name,
    required String slug,
    String? description,
    String status = 'draft',
    bool isDownloadEnabled = true,
    bool isFavoritesEnabled = true,
    DateTime? expiresAt,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/photographer/galleries'),
      headers: {..._headers(session), 'Content-Type': 'application/json'},
      body: jsonEncode({
        'client_id': clientId,
        'name': name.trim(),
        'slug': slug.trim(),
        'description': _nullable(description),
        'status': status,
        'is_download_enabled': isDownloadEnabled,
        'is_favorites_enabled': isFavoritesEnabled,
        'expires_at': expiresAt?.toUtc().toIso8601String(),
      }),
    );

    _throwIfFailed(response);

    return Gallery.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Map<String, String> _headers(AuthSession session) {
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${session.accessToken}',
    };
  }

  String? _nullable(String? value) {
    final trimmed = value?.trim();

    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    return trimmed;
  }

  void _throwIfFailed(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    var message = 'We could not complete the gallery request.';

    try {
      final body = jsonDecode(response.body);

      if (body is Map<String, dynamic>) {
        final detail = body['detail'];

        if (detail is String && detail.isNotEmpty) {
          message = detail;
        }
      }
    } catch (_) {}

    throw GalleryApiException(
      message: message,
      statusCode: response.statusCode,
    );
  }
}

class PortfolioPhoto {
  const PortfolioPhoto({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.originalFilename,
    required this.mimeType,
    required this.fileSize,
    required this.featured,
    required this.displayOrder,
    required this.processingStatus,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.width,
    this.height,
    this.location,
    this.capturedAt,
    this.previewUrl,
  });

  factory PortfolioPhoto.fromJson(Map<String, dynamic> json) {
    return PortfolioPhoto(
      id: json['id'] as int,
      categoryId: json['category_id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String?,
      originalFilename: json['original_filename'] as String,
      mimeType: json['mime_type'] as String,
      fileSize: json['file_size'] as int,
      width: json['width'] as int?,
      height: json['height'] as int?,
      location: json['location'] as String?,
      capturedAt: json['captured_at'] == null
          ? null
          : DateTime.parse(json['captured_at'] as String),
      featured: json['featured'] as bool,
      displayOrder: json['display_order'] as int,
      processingStatus: json['processing_status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      previewUrl: json['preview_url'] as String?,
    );
  }

  final int id;
  final int? categoryId;
  final String title;
  final String? description;
  final String originalFilename;
  final String mimeType;
  final int fileSize;
  final int? width;
  final int? height;
  final String? location;
  final DateTime? capturedAt;
  final bool featured;
  final int displayOrder;
  final String processingStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? previewUrl;
}

class Client {
  const Client({
    required this.id,
    required this.fullName,
    this.email,
    this.phone,
    this.notes,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      notes: json['notes'] as String?,
    );
  }

  final int id;
  final String fullName;
  final String? email;
  final String? phone;
  final String? notes;
}

class Gallery {
  const Gallery({
    required this.id,
    required this.clientId,
    required this.name,
    required this.slug,
    required this.status,
    required this.isDownloadEnabled,
    required this.isFavoritesEnabled,
    this.description,
    this.coverPhotoId,
    this.expiresAt,
  });

  factory Gallery.fromJson(Map<String, dynamic> json) {
    return Gallery(
      id: json['id'] as int,
      clientId: json['client_id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      status: json['status'] as String,
      isDownloadEnabled: json['is_download_enabled'] as bool,
      isFavoritesEnabled: json['is_favorites_enabled'] as bool,
      description: json['description'] as String?,
      coverPhotoId: json['cover_photo_id'] as int?,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
    );
  }

  final int id;
  final int clientId;
  final String name;
  final String slug;
  final String status;
  final bool isDownloadEnabled;
  final bool isFavoritesEnabled;
  final String? description;
  final int? coverPhotoId;
  final DateTime? expiresAt;
}

class GallerySummary extends Gallery {
  const GallerySummary({
    required super.id,
    required super.clientId,
    required super.name,
    required super.slug,
    required super.status,
    required super.isDownloadEnabled,
    required super.isFavoritesEnabled,
    required this.clientName,
    required this.photoCount,
    super.description,
    super.coverPhotoId,
    super.expiresAt,
  });

  factory GallerySummary.fromJson(Map<String, dynamic> json) {
    return GallerySummary(
      id: json['id'] as int,
      clientId: json['client_id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      status: json['status'] as String,
      isDownloadEnabled: json['is_download_enabled'] as bool,
      isFavoritesEnabled: json['is_favorites_enabled'] as bool,
      clientName: json['client_name'] as String,
      photoCount: json['photo_count'] as int,
      description: json['description'] as String?,
      coverPhotoId: json['cover_photo_id'] as int?,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
    );
  }

  final String clientName;
  final int photoCount;
}

class PublicGallery {
  const PublicGallery({
    required this.name,
    required this.photoCount,
    required this.isDownloadEnabled,
    required this.isFavoritesEnabled,
    required this.photos,
    this.description,
    this.expiresAt,
  });

  factory PublicGallery.fromJson(Map<String, dynamic> json) {
    return PublicGallery(
      name: json['name'] as String,
      description: json['description'] as String?,
      photoCount: json['photo_count'] as int,
      isDownloadEnabled: json['is_download_enabled'] as bool,
      isFavoritesEnabled: json['is_favorites_enabled'] as bool,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      photos: (json['photos'] as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(PublicGalleryPhoto.fromJson)
          .toList(),
    );
  }

  final String name;
  final String? description;
  final int photoCount;
  final bool isDownloadEnabled;
  final bool isFavoritesEnabled;
  final DateTime? expiresAt;
  final List<PublicGalleryPhoto> photos;
}

class PublicGalleryPhoto {
  const PublicGalleryPhoto({
    required this.id,
    required this.title,
    required this.previewUrl,
  });

  factory PublicGalleryPhoto.fromJson(Map<String, dynamic> json) {
    return PublicGalleryPhoto(
      id: json['id'] as int,
      title: json['title'] as String,
      previewUrl: json['preview_url'] as String,
    );
  }

  final int id;
  final String title;
  final String previewUrl;
}

class GalleryApiException implements Exception {
  const GalleryApiException({required this.message, required this.statusCode});

  final String message;
  final int statusCode;

  @override
  String toString() => message;
}
