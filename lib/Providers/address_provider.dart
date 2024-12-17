import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../API/address_service.dart';
import '../Models/address.dart';

class AddressProvider with ChangeNotifier {
  List<Address> _addresses = [];
  Address? _defaultAddress;

  final Logger logger = Logger();

  List<Address> get addresses => _addresses;
  Address? get defaultAddress => _defaultAddress;

  // Function to fetch addresses from the database based on customer ID
  Future<void> fetchAddresses(int customerId) async {
    try {
      // Use your AddressService to fetch addresses
      final List<Address> response = await AddressService().fetchAddresses(customerId.toString());

      // Update the list of addresses
      _addresses = response;

      // Set the first address as the default address if available
      if (_addresses.isNotEmpty) {
        _defaultAddress = _addresses.first;
      }

      notifyListeners();
    } catch (e) {
      logger.e('Error fetching addresses: $e');
    }
  }

  // Function to change the default address
  void setDefaultAddress(Address address) {
    if (_addresses.contains(address)) {
      _defaultAddress = address;
      notifyListeners();
    } else {
      logger.e('Address not found in the list');
    }
  }
}
