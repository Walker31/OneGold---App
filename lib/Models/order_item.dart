class OrderItem {
  final int productId;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.quantity
  });

  // Factory method to create an Order object from JSON
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'] as int,
      quantity: json['quantity'] as int,
    );
  }

  // Method to convert an Order object to JSON
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
    };
  }

  @override
  String toString() {
    return 'Order{ productId: $productId,quantity: $quantity}';
  }
}
