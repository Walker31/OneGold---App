import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onegold/API/api_path.dart';
import 'package:onegold/Models/address.dart';
import 'package:onegold/Providers/customer_provider.dart';

class AddressService {

  /// Fetches a list of saved addresses for a given customer ID.
  Future<List<Address>> fetchAddresses(String customerId) async {
    final url = APIPath.getAddress(customerId);

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData
            .map((json) => Address.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            'Failed to load addresses. Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Adds a new address for the currently logged-in customer.
  Future<Map<String, dynamic>> addAddress(Address address) async {
    final url = Uri.parse(APIPath.addAddress());
    final int? customerId = CustomerProvider().customerId;

    if (customerId == null) {
      return {'error': 'Customer ID is null'};
    }

    try {
      final Map<String, dynamic> data = {
        'customer_id': customerId,
        'pincode': address.pincode,
        'city': address.city,
        'landmark': address.landmark,
        'state': address.state,
        'location': address.location,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        return {'error': 'Failed to add Address'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  /// Deletes an address by its ID.
  Future<Map<String, dynamic>> deleteAddress(int addressId) async {
    final url = Uri.parse(
        '${APIPath.deleteAddress()}?address_id=$addressId&customer_id=${CustomerProvider().customerId}');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Failed to delete Address'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
