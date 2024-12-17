import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../API/api_main.dart';
import '../Models/category.dart';
import '../Models/product.dart';

class StoreProvider with ChangeNotifier {
  Logger logger = Logger();

  List<Category> _categories = [];
  Map<String, List<Product>> _categorizedProducts = {};

  List<Category> get categories => _categories;
  Map<String, List<Product>> get categorizedProducts => _categorizedProducts;

  Future<void> fetchCategories() async {
    try {
      final fetchedCategories = await ApiService.fetchCategories();
      _categories = fetchedCategories;
      notifyListeners();
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<void> fetchProducts() async {
    try {
      final categorizedProducts = await ApiService.fetchProducts();
      _categorizedProducts = categorizedProducts;
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
