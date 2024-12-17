class Address {
  final int addressId;
  final String pincode;
  final String city;
  final String state;
  final String location;
  final String? landmark;
  final DateTime createdAt;

  // Default values are set to 'Unknown' where applicable
  Address({
    this.addressId = 0,
    required this.pincode,
    required this.city,
    required this.state,
    required this.location,
    this.landmark = 'Unknown', // Default 'Unknown' for landmark
    required this.createdAt,
  });

  // Factory method to create Address from JSON
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressId: json['id'] as int? ?? 0, // Default to 0 if null
      pincode:
          json['postal_code'] as String? ?? 'Unknown', // Default to 'Unknown'
      city: json['city'] as String? ?? 'Unknown', // Default to 'Unknown'
      state: json['state'] as String? ?? 'Unknown', // Default to 'Unknown'
      location:
          json['location'] as String? ?? 'Unknown', // Default to 'Unknown'
      landmark:
          json['landmark'] as String? ?? 'Unknown', // Default to 'Unknown'
      createdAt: json['created_at'] != null && json['created_at'].isNotEmpty
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(), // Default to current time if parsing fails
    );
  }

  // Convert Address to JSON
  Map<String, dynamic> toJson() {
    return {
      'address_id': addressId,
      'pincode': pincode,
      'city': city,
      'state': state,
      'location': location,
      'landmark': landmark,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return '$location, $city, $state, $pincode';
  }
}
