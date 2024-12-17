import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:onegold/API/api_path.dart';
import 'package:onegold/Providers/customer_provider.dart';

import '../Models/customer.dart';

class AuthService {
  static final Logger logger = Logger();

  /// Login function
  Future<http.Response> login(String username, String password) async {
    try {
      logger.d('Attempting to log in user: $username');
      final response = await http.post(
        Uri.parse(APIPath.login()),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'username': username,
          'password': password,
        },
      );

      logger.i('Login response: ${response.statusCode}, ${response.body}');
      if (response.statusCode == 200) {
        return response; // return the successful http.Response
      } else {
        logger.e('Login failed: ${response.statusCode}, ${response.body}');
        return response; // return the failed http.Response for further handling
      }
    } catch (e) {
      logger.e('Login exception: $e');
      // Return a custom Response with error code to handle the exception case
      return http.Response('Exception: $e', 500);
    }
  }

  /// Fetch customer profile
  Future<Customer?> getProfile(int customerId, {String? token}) async {
    try {
      logger.d('Fetching profile for customerId: $customerId');
      final response = await http.get(
        Uri.parse(APIPath.profile(customerId.toString())),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        logger.d('Profile response: $jsonResponse');
        CustomerProvider().setWishlist(jsonResponse['wishlist']);
        return Customer.fromJson(jsonResponse);
      } else {
        logger.e(
            'Error fetching profile: ${response.statusCode}, ${response.body}');
        return null;
      }
    } catch (e) {
      logger.e('Exception while fetching profile: $e');
      return null;
    }
  }

  /// Signup function
  Future<http.Response> signup(
    String name,
    String phoneNo,
    String username,
    String password,
  ) async {
    try {
      logger.d('Signing up user: $username');
      final response = await http.post(
        Uri.parse(APIPath.signup()),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'name': name,
          'phone_no': phoneNo,
          'username': username,
          'password': password,
        },
      );

      logger.i('Signup response: ${response.statusCode}, ${response.body}');
      return response; // return the http.Response
    } catch (e) {
      logger.e('Signup exception: $e');
      return http.Response(
          'Exception: $e', 500); // Return a custom Response in case of failure
    }
  }
}
