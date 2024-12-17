import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:onegold/Providers/address_provider.dart';
import 'package:onegold/Providers/customer_provider.dart';
import 'package:provider/provider.dart';
import '../API/auth.dart';
import 'main_store.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final Logger logger = Logger();

  bool isLogin = true;
  bool isLoading = false;

  // Controllers for form fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final AuthService authService = AuthService();

  // Toggle between Login and Sign Up
  void toggleMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  // Handle Login
  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    try {
      final response = await authService.login(
        usernameController.text,
        passwordController.text,
      );

      logger.d('Response received: ${response.statusCode}');
      logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          final int customerId = responseData['customer_id'];
          final String customerName = responseData['username'];

          logger.d('Customer ID: $customerId  Customer Name: $customerName');

          CustomerProvider().setCustomerInfo(customerId, customerName);
          await Provider.of<AddressProvider>(context, listen: false)
            .fetchAddresses(customerId);

          logger.i('Login successful! Navigating to Store.');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Store()),
          );
        } catch (e) {
          logger.e('Error decoding response or fetching profile: $e');
          showSnackBar('Error processing login: $e');
        }
      } else {
        logger.e('Login failed: ${response.body}');
        showSnackBar('Login failed: ${response.body}');
      }
    } catch (e) {
      logger.e('Error during login: $e');
      showSnackBar('An error occurred: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Handle Sign Up
  Future<void> signUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (passwordController.text != confirmPasswordController.text) {
      showSnackBar('Passwords do not match');
      return;
    }

    setState(() => isLoading = true);
    try {
      final response = await authService.signup(
        nameController.text,
        phoneController.text,
        usernameController.text,
        passwordController.text,
      );

      if (response.statusCode == 201) {
        showSnackBar('Signup successful! Please log in.');
        setState(() => isLogin = true);
      } else {
        showSnackBar('Signup failed: ${response.body}');
      }
    } catch (e) {
      showSnackBar('An error occurred: $e');
      logger.e('Signup error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Reusable Input Field Widget
  Widget buildTextField(TextEditingController controller, String label,
      {bool obscureText = false, bool autoFocus = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      autofocus: autoFocus,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      style: const TextStyle(color: Colors.white),
      validator: (value) => value!.isEmpty ? '$label is required' : null,
    );
  }

  // Reusable Submit Button
  Widget buildSubmitButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            )
          : Text(text,
              style: const TextStyle(color: Colors.black, fontSize: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLogin ? "Login to your account" : "Create a new account",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isLogin
                      ? "Enter your credentials to continue."
                      : "Fill in the details to sign up.",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 30),

                // Username Field
                buildTextField(usernameController, 'Username', autoFocus: true),
                const SizedBox(height: 15),

                if (!isLogin) ...[
                  buildTextField(nameController, 'Name'),
                  const SizedBox(height: 15),
                  buildTextField(phoneController, 'Phone No'),
                  const SizedBox(height: 15),
                ],

                // Password Field
                buildTextField(passwordController, 'Password',
                    obscureText: false),
                const SizedBox(height: 15),

                if (!isLogin)
                  buildTextField(confirmPasswordController, 'Confirm Password',
                      obscureText: true),

                const SizedBox(height: 30),

                // Submit Button
                buildSubmitButton(
                  isLogin ? 'Login' : 'Sign Up',
                  () => isLogin ? login() : signUp(),
                ),
                const SizedBox(height: 20),

                // Toggle between Login and Sign Up
                GestureDetector(
                  onTap: toggleMode,
                  child: Text(
                    isLogin
                        ? "Don't have an account? Sign up"
                        : "Already have an account? Login",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
