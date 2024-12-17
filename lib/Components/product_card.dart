import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:onegold/API/cart_service.dart';
import 'package:onegold/Providers/customer_provider.dart';
import 'package:provider/provider.dart';
import '../Models/product.dart';
import 'buy_now.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  ProductCardState createState() => ProductCardState();
}

class ProductCardState extends State<ProductCard> {
  Logger logger = Logger();
  CartService cartService = CartService(); // Instantiate ApiService

  final String imgAsset = "assets/necklace.jpg";

  Future<void> addToCart(int productId) async {
    final customerId =
        Provider.of<CustomerProvider>(context, listen: false).customerId;

    if (customerId == null) {
      logger.e('Customer ID is null. User might not be logged in.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please log in to add items to the cart.')),
      );
      return;
    }

    try {
      final cart = await CartService.addToCart(customerId, productId);
      logger.i('Product added to cart: $cart');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added to cart successfully!')),
      );
    } catch (e) {
      logger.e('Failed to add product to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to cart: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerId = Provider.of<CustomerProvider>(context).customerId;

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.black, width: 2),
      ),
      shadowColor: Colors.black.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox.square(
                dimension: 200, child: Image.asset('assets/necklace.jpg')),
            Text(
              widget.product.productName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${widget.product.productPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  BuyNowButton(
                      product:
                          widget.product), // Use the new BuyNowButton widget
                  const SizedBox(height: 10),
                  Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    height: 40,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        )),
                      ),
                      onPressed: customerId != null
                          ? () => addToCart(widget.product.productId)
                          : null, // Disable if customerId is null
                      child: Container(
                        width: 150,
                        height: 50,
                        alignment: Alignment.center,
                        child: const Text(
                          'Add to Cart',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
