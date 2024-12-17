import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:onegold/API/api_path.dart';
import 'package:onegold/Models/order_item.dart';
import '../Models/order.dart';

class OrderService {
  static Future<Map<String, dynamic>> placeOrder(
      Order order, List<OrderItem> items) async {
    var logger = Logger();

    final url = Uri.parse(APIPath.placeOrder());

    Map<String, dynamic> data = {
      'customer_id': order.customerId,
      'items': items.map((item) {
        return {'product_id': item.productId, 'quantity': item.quantity};
      }).toList(),
      'address_id': order.addressId,
      'order_total': order.orderTotal,
      'order_status': order.orderStatus,
      'payment_type': order.paymentType
    };
    try {
      logger.d(data);
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data));
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        // Handle error response
        logger.e('Failed to place order: ${response.statusCode}');
        final responseBody = json.decode(response.body);
        logger.e('Failed due to: ${responseBody["error"]}');
        return {'error': 'Failed to place order'};
      }
    } catch (e) {
      logger.e('Error Ocurred: $e');
      rethrow;
    }
  }
}
