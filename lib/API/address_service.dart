import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:onegold/API/api_path.dart';
import 'package:onegold/Models/address.dart';

class AddressService {
  Future<List<Address>> fetchAddresses(String customerId) async {
    final url = APIPath.getAddress(customerId);
    var logger = Logger();
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse JSON response into a list of addresses
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((json) => Address.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load addresses. Status code: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error fetching addresses: $e');
      rethrow;
    }
  }
}
