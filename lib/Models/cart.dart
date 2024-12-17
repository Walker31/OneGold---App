import 'product.dart';

class Cart {
  final int id;
  final int customerId;
  final int productId;
  final int quantity;
  final double total;
  final Product product;

  Cart({
    required this.id,
    required this.customerId,
    required this.productId,
    required this.quantity,
    required this.total,
    required this.product,
  });

  // Factory method for JSON deserialization
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      customerId: json['customer_id'],
      productId: json['product_id'],
      quantity: json['qty'],
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      product: Product.fromJson(json['product']),
    );
  }

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'product_id': productId,
      'qty': quantity,
      'total': total,
      'product': product.toJson(),
    };
  }
}
