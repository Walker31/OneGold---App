import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:onegold/API/api_path.dart';
import 'package:http/http.dart' as http;
import 'package:onegold/Models/cart.dart';
import 'package:provider/provider.dart';
import '../Providers/customer_provider.dart';

enum CartAction { increase, decrease, delete }

class CartService {
  

  // Add product to cart
  static Future<http.Response> addToCart(int customerId, int productId) async {
    var logger = Logger();
    final url = Uri.parse(APIPath.addToCart(customerId.toString(), productId.toString()));

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      logger.i('Response Status: ${response.statusCode}');
      return response; // Return the http.Response object directly
    } catch (e) {
      logger.e('Error occurred: $e');
      rethrow;
    }
  }

  // Update cart (increase, decrease, delete)
  static Future<http.Response> updateCart(int productId, CartAction action, BuildContext context) async {
    var logger = Logger();
    final url = Uri.parse(APIPath.updateCart());

    // Access customerId from Provider
    final customerProvider = Provider.of<CustomerProvider>(context, listen: false);
    int? customerId = customerProvider.customerId ?? 0;

    if (customerId == 0) {
      // Optionally handle the case where customerId is not found (maybe show an error message or redirect)
      logger.e('Customer ID is not available.');
      return Future.error('Customer ID is not available.');
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'customer_id': customerId,
          'product_id': productId,
          'action': action.toString().split('.').last, // Convert enum to string
        }),
      );

      logger.i('Response Status: ${response.statusCode}');
      return response; // Return the http.Response object directly
    } catch (e) {
      logger.e('Error occurred: $e');
      rethrow;
    }
  }

  // View cart for a specific customer
  static Future<Map<String, dynamic>> viewCart(int customerId) async {
    var logger = Logger();
    final url = Uri.parse('${APIPath.viewCart()}?customer_id=$customerId');
    logger.i('Sending request to view cart: $url');

    try {
      final response = await http.get(url);

      logger.i('Response Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        logger.i('Response Data: $responseData');

        // Parsing cart items
        List<Cart> cartItems = (responseData['cart_items'] as List<dynamic>)
            .map((cartData) => Cart.fromJson(cartData as Map<String, dynamic>))
            .toList();

        double totalCost = double.tryParse(responseData['total_cost'].toString()) ?? 0.0;
        double totalQty = double.tryParse(responseData['total_qty'].toString()) ?? 0.0;
        logger.i(totalCost);

        return {
          'cart_items': cartItems,
          'total_cost': totalCost,
          'total_qty': totalQty,
        };
      } else {
        final errorData = json.decode(response.body);
        logger.e('Error Response: $errorData');
        throw Exception('Failed to fetch cart: ${errorData['message']}');
      }
    } catch (e) {
      logger.e('Error occurred: $e');
      rethrow;
    }
  }
}
