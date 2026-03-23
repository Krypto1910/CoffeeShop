class Product {
  final String id;
  final String categoryID;
  final String title;
  final double price;
  final int stock;
  final String description;
  final String imagePath;

  const Product({
    required this.id,
    required this.categoryID,
    required this.title,
    required this.price,
    required this.stock,
    required this.description,
    required this.imagePath,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      categoryID: json['categoryID'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      description: json['description'] ?? '',
      imagePath: json['imagePath'] ?? '',
    );
  }

  /// URL ảnh đầy đủ từ PocketBase, baseUrl: http://45.63.68.43:8090/ hoặc http://127.0.0.1:8090/
  String imageUrl(String baseUrl) {
    if (imagePath.isEmpty) return '';
    // PocketBase file URL format: /api/files/{collectionName}/{recordId}/{fileName}
    return '$baseUrl/api/files/product/$id/$imagePath';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Product && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
