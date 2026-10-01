class Inquiry {
  const Inquiry({
    required this.id,
    required this.name,
    required this.email,
    required this.service,
    required this.preferredDate,
    required this.location,
    required this.message,
    required this.status,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String email;
  final String service;
  final String? preferredDate;
  final String? location;
  final String? message;
  final String status;
  final DateTime createdAt;

  factory Inquiry.fromJson(Map<String, dynamic> json) {
    return Inquiry(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      service: json['service'] as String,
      preferredDate: json['preferred_date'] as String?,
      location: json['location'] as String?,
      message: json['message'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
