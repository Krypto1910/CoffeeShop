class OrderItemModel {
  final String id;
  final String orderID;
  final String productID;
  final double unitPrice;
  final int quantity;
  final Map<String, dynamic> options;
  final String? productTitle;
  final String? productImagePath;

  OrderItemModel({
    required this.id,
    required this.orderID,
    required this.productID,
    required this.unitPrice,
    required this.quantity,
    required this.options,
    this.productTitle,
    this.productImagePath,
  });

  double get subtotal => unitPrice * quantity;

  factory OrderItemModel.fromJson(Map<String, dynamic> json,
      {Map<String, dynamic>? productJson}) {
    return OrderItemModel(
      id: json['id'] ?? '',
      orderID: _parseRelationId(json['orderID']),
      productID: _parseRelationId(json['productID']),
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      options: _parseOptions(json['options']),
      productTitle: productJson?['title'],
      productImagePath: productJson?['imagePath'],
    );
  }
}

class OrderModel {
  final String id;
  final String userID;
  String status;
  final double totalAmount;
  final String address;
  final String paymentMethod;
  final DateTime created;
  final DateTime updated;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.userID,
    required this.status,
    required this.totalAmount,
    required this.address,
    required this.paymentMethod,
    required this.created,
    required this.updated,
    this.items = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      // PocketBase Relation field có thể trả về String ID hoặc List<dynamic>
      userID: _parseRelationId(json['userID']),
      status: json['status'] ?? 'pending',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      address: json['address'] ?? '',
      // SELECT field trả về String
      paymentMethod: _parseSelectField(json['paymentMethod']),
      created: DateTime.tryParse(json['created'] ?? '') ?? DateTime.now(),
      updated: DateTime.tryParse(json['updated'] ?? '') ?? DateTime.now(),
    );
  }

  String get statusLabel {
    switch (status) {
      case 'pending':     return 'Pending';
      case 'confirmed':   return 'Confirmed';
      case 'delivering':  return 'Delivering';
      case 'completed':   return 'Completed';
      case 'cancelled':   return 'Cancelled';
      default:            return status;
    }
  }

  bool get isActive =>
      status == 'pending' || status == 'confirmed' || status == 'delivering';
}

String _parseRelationId(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  if (value is List && value.isNotEmpty) return value.first.toString();
  return value.toString();
}

/// PocketBase SELECT field trả về String hoặc List
String _parseSelectField(dynamic value) {
  if (value == null) return 'cash';
  if (value is String) return value.isEmpty ? 'cash' : value;
  if (value is List && value.isNotEmpty) return value.first.toString();
  return 'cash';
}

/// options field là JSON — có thể là String, Map, hoặc null
Map<String, dynamic> _parseOptions(dynamic value) {
  if (value == null) return {};
  if (value is Map<String, dynamic>) return value;
  if (value is String && value.isNotEmpty) {
    try {
      // Thử parse nếu là JSON string
      return {'title': value};
    } catch (_) {
      return {};
    }
  }
  return {};
}