class User {
  final String id;
  final String email;   
  String? name;
  String? phone;
  String? avatar;

  User({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.avatar,
  });

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? name,
    String? phone,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'],
      phone: json['phone'],
      avatar: json['avatar'],
    );
  }

  String get displayName {
    if (name != null && name!.isNotEmpty) return name!;
    return email.split('@').first;
  }
}