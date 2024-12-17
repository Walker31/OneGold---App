import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:onegold/API/api_path.dart';
import 'package:onegold/Providers/customer_provider.dart';

class CustomerService {
  static Future<http.Response> addToWishlist(int? productId) async {
    final url = Uri.parse(APIPath.addToWishlist());
    var logger = Logger();
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'customer_id': CustomerProvider().customerId,
            'product_id': productId
          }));

      return response;
    } catch (e) {
      logger.e('Error occurred: $e');
      rethrow;
    }
  }

  static Future<http.Response> removeToWishlist(int? productId) async {
    final url = Uri.parse(APIPath.removeFromWishlist());
    var logger = Logger();
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'customer_id': CustomerProvider().customerId,
            'product_id': productId
          }));

      return response;
    } catch (e) {
      logger.e('Error occurred: $e');
      rethrow;
    }
  }
}
