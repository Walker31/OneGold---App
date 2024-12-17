class Review {
  final int reviewId;
  final int productId;
  final int customerId; // Non-nullable now
  final int rating;
  final String reviewText;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.reviewId,
    required this.productId,
    required this.customerId, // Ensure it's required and defaults to 0 if null
    required this.rating,
    required this.reviewText,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['review_id'] as int,
      productId: json['product_id'] != null ? json['product_id'] as int : 0,
      customerId: json['customer_id'] != null
          ? json['customer_id'] as int
          : 0, // Default to 0
      rating: json['rating'] as int,
      reviewText: json['review_text'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(), // Fallback to current time
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'review_id': reviewId,
      'product_id': productId,
      'customer_id': customerId, // Always non-null
      'rating': rating,
      'review_text': reviewText,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Review{reviewId: $reviewId, rating: $rating, reviewText: "$reviewText"}';
  }
}
