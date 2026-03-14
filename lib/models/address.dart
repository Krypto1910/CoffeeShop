class Address {
  final String id;       // PocketBase record ID (string)
  final String userID;
  final String title;
  final String detail;
  final bool isDefault;

  Address({
    required this.id,
    required this.userID,
    required this.title,
    required this.detail,
    this.isDefault = false,
  });

  Address copyWith({
    String? id,
    String? userID,
    String? title,
    String? detail,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      userID: userID ?? this.userID,
      title: title ?? this.title,
      detail: detail ?? this.detail,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? '',
      userID: json['userID'] ?? '',
      title: json['title'] ?? '',
      detail: json['detail'] ?? '',
      isDefault: json['isDefault'] ?? false,
    );
  }
}