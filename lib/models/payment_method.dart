class PaymentMethodModel {
  final String id;
  final String userId;
  final String type;
  final String provider;
  final String accountNumber;
  final String accountName;
  final String? expiryDate;
  final bool isDefault;

  PaymentMethodModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.provider,
    required this.accountNumber,
    required this.accountName,
    this.expiryDate,
    required this.isDefault,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'],
      userId: json['userId'],
      type: json['type'],
      provider: json['provider'],
      accountNumber: json['accountNumber'],
      accountName: json['accountName'],
      expiryDate: json['expiryDate'],
      isDefault: json['isDefault'] ?? false,
    );
  }
}
