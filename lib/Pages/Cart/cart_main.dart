import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:onegold/Pages/Order/checkout.dart';
import 'package:onegold/Pages/ProductDisplay/product_display.dart';
import 'package:provider/provider.dart'; // For CustomerProvider
import '../../API/cart_service.dart';
import '../../Models/cart.dart'; // Cart model
import '../../Providers/customer_provider.dart'; // CustomerProvider
import 'cart_item.dart'; // CartItemWidget

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  final Logger logger = Logger();
  List<Cart> cartItems = [];
  double totalPrice = 0.00;
  double totalItems = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final customerId =
          Provider.of<CustomerProvider>(context, listen: false).customerId;
      if (customerId != null) {
        loadCartItems(customerId);
      } else {
        logger.w('Customer ID is null. Cannot load cart items.');
      }
    });
  }

  Future<void> loadCartItems(int customerId) async {
    try {
      final cartDetails = await CartService.viewCart(customerId);
      setState(() {
        cartItems = cartDetails['cart_items'];
        totalPrice = cartDetails['total_cost'];
        totalItems = cartDetails['total_qty'];
      });
    } catch (e) {
      logger.e('Error fetching cart items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final productList = cartItems;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Cart",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
        ),
        backgroundColor: Colors.green.shade200,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: productList.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: productList.length,
                    itemBuilder: (context, index) {
                      final product = productList[index];
                      return GestureDetector(
                        onTap: () {
                          int productId = product.productId;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDisplay(
                                        productID: productId,
                                      )));
                        },
                        child: CartItemWidget(
                          item: product,
                          onItemRemoved: () {
                            // Refresh the cart when item is removed
                            loadCartItems(Provider.of<CustomerProvider>(context,
                                        listen: false)
                                    .customerId ??
                                0);
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Subtotal",
                              style: TextStyle(fontSize: 16)),
                          Text(
                            "\$${totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Discount", style: TextStyle(fontSize: 16)),
                          Text("\$0.00", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Grand Total",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                            "\$${totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Checkout(cartItems: productList),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 0),
                        ),
                        child: const Text(
                          "Checkout now",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
