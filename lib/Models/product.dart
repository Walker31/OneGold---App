import 'review.dart';

class Product {
  final int productId;
  final String productName;
  final String productDescription;
  final List<String> productImages;
  final String categoryName;
  final double productPrice;
  final int stockQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Review> reviews;
  final double averageRating;

  Product({
    required this.productId,
    required this.productName,
    required this.productDescription,
    this.productImages = const [],
    required this.categoryName,
    required this.productPrice,
    required this.stockQuantity,
    required this.createdAt,
    required this.updatedAt,
    this.reviews = const [],
    this.averageRating = 0.0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'] as int,
      productName: json['product_name'] as String? ?? 'Unknown Product',
      productDescription:
          json['product_description'] as String? ?? 'No description available',
      productImages: (json['product_images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      categoryName: json['category_name'] as String? ?? 'Uncategorized',
      productPrice: double.tryParse(json['product_price'].toString()) ?? 0.0,
      stockQuantity: json['stock_quantity'] as int? ?? 0,
      createdAt: json['created_at'] != null && json['created_at'].isNotEmpty
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null && json['updated_at'].isNotEmpty
          ? DateTime.tryParse(json['updated_at']) ?? DateTime.now()
          : DateTime.now(),
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((reviewJson) => Review.fromJson(reviewJson))
              .toList() ??
          [],
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_description': productDescription,
      'product_images': productImages,
      'category_name': categoryName,
      'product_price': productPrice,
      'stock_quantity': stockQuantity,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'average_rating': averageRating,
    };
  }

  @override
  String toString() {
    return 'Product{productId: $productId, productName: $productName, averageRating: $averageRating}';
  }
}
