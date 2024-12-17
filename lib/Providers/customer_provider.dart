import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CustomerProvider extends ChangeNotifier {
  Logger logger = Logger();
  int? _customerId = 3;
  String? _customerName = '';
  List<int> _wishlist = [];

  // Getter for customerId
  int? get customerId => _customerId;
  List<int> get wishlist => _wishlist;

  // Getter for customerName
  String? get customerName => _customerName;

  // Setter to update customer information
  void setCustomerInfo(int customerId, String customerName) {
    _customerId = customerId;
    _customerName = customerName;
    logger.d('$customerName + $customerId');
    notifyListeners(); // Notify listeners when the data changes
  }

  void setWishlist(List<int> wishlist) {
    _wishlist = wishlist;
  }

  // Clear customer information (e.g., on logout)
  void clearCustomerInfo() {
    _customerId = null;
    _customerName = null;
    notifyListeners();
  }
}
