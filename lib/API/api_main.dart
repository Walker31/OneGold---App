import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../Models/category.dart';
import '../Models/product.dart';
import 'api_path.dart';

class ApiService {
  static final Logger logger = Logger();

  // Fetch all products and categorize them
  static Future<Map<String, List<Product>>> fetchProducts() async {

    try {
      final response = await http.get(Uri.parse(APIPath.getAllProducts()));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['products'] ?? [];

        List<Product> products = data.map((productJson) {
          final product = Product.fromJson(productJson ?? {});

          return product;
        }).toList();

        Map<String, List<Product>> categorizedProducts = {};
        for (var product in products) {
          final categoryName = product.categoryName.isEmpty
              ? 'Uncategorized'
              : product.categoryName;

          if (categorizedProducts.containsKey(categoryName)) {
            categorizedProducts[categoryName]!.add(product);
          } else {
            categorizedProducts[categoryName] = [product];
          }
        }

        return categorizedProducts;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      logger.e('Error fetching products: $e');
      throw Exception('Error fetching products: $e');
    }
  }

  // Fetch a product by its ID
  static Future<Product> fetchProductById(int productId) async {
    logger.i('Fetching product by ID: $productId');

    try {
      final response = await http
          .get(Uri.parse(APIPath.getProductById(productId.toString())));

      if (response.statusCode != 200) {
        logger.e('Error: ${response.statusCode} - ${response.reasonPhrase}');
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> productData =
            json.decode(response.body) ?? {};
        return Product.fromJson(productData['product'] ?? {});
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      logger.e('Error fetching product: $e');
      throw Exception('Error fetching product: $e');
    }
  }

  // Fetch all categories
  static Future<List<Category>> fetchCategories() async {
    logger.i('Fetching all categories...');

    try {
      final response = await http.get(Uri.parse(APIPath.getCategories()));


      if (response.statusCode == 200) {
        final Map<String, dynamic> parsed =
            json.decode(response.body) ?? {'categories': []};

        final List<dynamic> categoriesJson = parsed['categories'] ?? [];

        final categories = categoriesJson
            .map((categoryJson) => Category.fromJson(categoryJson ?? {}))
            .toList();
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      logger.e('Error fetching categories: $e');
      throw Exception('Error fetching categories: $e');
    }
  }
}
