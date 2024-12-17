import 'package:flutter/material.dart';
import 'package:onegold/Providers/customer_provider.dart';
import 'package:provider/provider.dart';
import '../Models/product.dart';
import '../Models/cart.dart'; // Ensure the Cart model is imported
import '../Pages/Order/checkout.dart';

class BuyNowButton extends StatelessWidget {
  final Product product;

  const BuyNowButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    
    final customerProvider = Provider.of<CustomerProvider>(context);
    // Create a new Cart item with the updated stockQuantity
    final cartItem = Cart(
      product: product,
      quantity: 1, id: 1,customerId: customerProvider.customerId ?? 0, productId: product.productId, total: product.productPrice, // Assume quantity is 1 for the "Buy Now" button
    );

    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      height: 40,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          foregroundColor: MaterialStateProperty.all(Colors.black),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          )),
        ),
        onPressed: () {
          // Navigate to the Checkout page, passing the CartItem wrapped in a list
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Checkout(
                cartItems: [cartItem], // Pass the CartItem in a list
              ),
            ),
          );
        },
        child: Container(
          width: 150,
          height: 50,
          alignment: Alignment.center,
          child: const Text(
            'Buy Now',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
