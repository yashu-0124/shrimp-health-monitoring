/// User Model
/// Represents the user data structure used throughout the app
class UserModel {
  final String? id;
  final String fullName;
  final String farmName;
  final String email;
  final String phone;
  final String preferredLanguage;

  UserModel({
    this.id,
    required this.fullName,
    required this.farmName,
    required this.email,
    required this.phone,
    required this.preferredLanguage,
  });

  /// Create UserModel from JSON response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'],
      fullName: json['fullName'] ?? '',
      farmName: json['farmName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      preferredLanguage: json['preferredLanguage'] ?? 'English',
    );
  }

  /// Convert UserModel to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'farmName': farmName,
      'email': email,
      'phone': phone,
      'preferredLanguage': preferredLanguage,
    };
  }

  /// Create a copy of UserModel with updated fields
  UserModel copyWith({
    String? id,
    String? fullName,
    String? farmName,
    String? email,
    String? phone,
    String? preferredLanguage,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      farmName: farmName ?? this.farmName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    );
  }
}
