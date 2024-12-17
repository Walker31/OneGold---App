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
    final url = APIPath.login();
    final body = {'username': username, 'password': password};

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );
      if (response.statusCode == 200) {
      } else {
        logger.w('Login failed: ${response.statusCode}, ${response.body}');
      }
      return response;
    } catch (e) {
      logger.e('Exception during login: $e, URL=$url');
      return http.Response('Exception: $e', 500);
    }
  }

  /// Fetch customer profile
  Future<Customer?> getProfile(int customerId) async {
    final url = APIPath.profile(customerId.toString());
    try {
      final headers = {
        'Content-Type': 'application/json',
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        CustomerProvider().setWishlist(jsonResponse['wishlist']);

        return Customer.fromJson(jsonResponse);
      } else {
        logger.w('Failed to fetch profile: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      logger.e('Exception fetching profile: $e, URL=$url');
      return null;
    }
  }

  /// Signup function
  Future<http.Response> signup(
      String name, String phoneNo, String username, String password) async {
    final url = APIPath.signup();
    final body = {
      'name': name,
      'phone_no': phoneNo,
      'username': username,
      'password': password,
    };

    try {
      logger.d('Attempting signup: URL=$url, Body=$body');
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      logger.i('Signup Response: ${response.statusCode}, ${response.body}');
      if (response.statusCode == 201) {
        logger.d('Signup successful for user: $username');
      } else {
        logger.w('Signup failed: ${response.statusCode}, ${response.body}');
      }
      return response;
    } catch (e) {
      logger.e('Exception during signup: $e, URL=$url');
      return http.Response('Exception: $e', 500);
    }
  }
}
