class Customer {
  final int customerId;
  final String name;
  final String? email;
  final String phoneNo;
  final DateTime createdAt;
  final DateTime updatedAt;

  Customer({
    required this.customerId,
    required this.name,
    this.email,
    required this.phoneNo,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create Customer from JSON
  factory Customer.fromJson(Map<String, dynamic> json) {
    final customerId = json['customer_id'];
    final name = json['name'];
    final email = json['email'];
    final phoneNo = json['phone_no'];
    final createdAt = json['created_at'];
    final updatedAt = json['updated_at'];

    return Customer(
      customerId: customerId as int,
      name: name as String? ?? '',
      email: email as String?,
      phoneNo: phoneNo as String,
      createdAt: createdAt != null ? DateTime.parse(createdAt) : DateTime.now(),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt) : DateTime.now(),
    );
  }

  // Convert Customer to JSON
  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'name': name,
      'email': email,
      'phone_no': phoneNo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Customer{name: $name, phoneNo: $phoneNo}';
  }
}
