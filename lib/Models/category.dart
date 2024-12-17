class Category {
  final int categoryId;
  final String categoryName;

  Category({
    required this.categoryId,
    required this.categoryName,
  });

  // Factory method to create a Category object from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'] as int,
      categoryName: json['category_name'] as String,
    );
  }

  // Method to convert a Category object to JSON
  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
    };
  }

  @override
  String toString() {
    return 'Category{categoryId: $categoryId, categoryName: $categoryName}';
  }
}
