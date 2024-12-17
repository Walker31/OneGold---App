class Order {
  final int customerId;
  final int addressId;
  final double orderTotal;
  final String orderStatus;
  final String paymentType;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.customerId,
    required this.addressId,
    required this.orderTotal,
    required this.orderStatus,
    required this.paymentType,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an Order object from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      customerId: json['customer_id'] as int,
      addressId: json['address_id'] as int,
      orderTotal: (json['order_total'] as num).toDouble(),
      orderStatus: json['order_status'] as String,
      paymentType: json['payment_type'] as String,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert an Order object to JSON
  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'address_id': addressId,
      'order_total': orderTotal,
      'order_status': orderStatus,
      'payment_type': paymentType,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Order{customerId: $customerId, addressId: $addressId,orderTotal: $orderTotal, orderStatus: $orderStatus, paymentType: $paymentType}';
  }
}
