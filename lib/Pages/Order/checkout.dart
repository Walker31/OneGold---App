import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:onegold/API/order_service.dart';
import 'package:onegold/Models/address.dart';
import 'package:onegold/Models/cart.dart';
import 'package:onegold/Pages/Address/saved_address.dart';
import 'package:onegold/Providers/customer_provider.dart';
import 'package:provider/provider.dart';
import '../../Models/order.dart';
import '../../Models/order_item.dart';
import '../../Providers/address_provider.dart';
import 'product_item.dart';
import 'payment_widget.dart';

class Checkout extends StatefulWidget {
  final List<Cart> cartItems;
  const Checkout({super.key, required this.cartItems});

  @override
  CheckoutState createState() => CheckoutState();
}

class CheckoutState extends State<Checkout> {
  final TextEditingController noteController = TextEditingController();

  String selectedPaymentType = 'Cash';

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();
    final addressProvider = Provider.of<AddressProvider>(context);
    final customerProvider = Provider.of<CustomerProvider>(context);
    Address? address = addressProvider.defaultAddress;
    int? customerId = customerProvider.customerId;

    // Calculate total price dynamically based on the CartItems list
    double calculateTotal() {
      return widget.cartItems.fold(0.0, (total, cartItem) {
        // Calculate the total price based on each cart item's product price and quantity
        return total + (cartItem.product.productPrice * cartItem.quantity);
      });
    }

    Future<void> placeOrder() async {
      try {
        if (customerId == null || address == null) {
          logger.e('Customer ID or Address is missing.');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select an address.')),
          );
          return;
        }
        logger.i(address);
        final order = Order(
          customerId: customerId,
          addressId: address.addressId,
          orderTotal: calculateTotal(),
          orderStatus: 'Pending',
          paymentType: selectedPaymentType, // You can update this dynamically
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final items = widget.cartItems.map((cartItem) {
          return OrderItem(
            productId: cartItem.product.productId,
            quantity: cartItem.quantity,
          );
        }).toList();

        final response = await OrderService.placeOrder(order, items);

        if (response.containsKey('error')) {
          logger.e('Order failed: ${response['message']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order failed: ${response['message']}')),
          );
        } else {
          logger.i('Order placed successfully: ${response['order_id']}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order placed successfully!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        logger.e('An error occurred: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('An error occurred while placing the order.')),
        );
      }
    }

    // Calculate the total number of items in the cart
    int calculateItemCount() {
      return widget.cartItems.fold(0, (count, cartItem) {
        return count + cartItem.quantity;
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
        ),
        backgroundColor: Colors.green[900], // Darker green for AppBar
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.green[50], // Light green background
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shipping Address Section
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors
                      .green[50], // Lighter green for the section background
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.green),
                            SizedBox(width: 16),
                            Text(
                              'Shipping Address',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SavedAddress()));
                          },
                          icon: const Icon(
                            Icons.navigate_next,
                            size: 32,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _formatAddress(
                          address), // Format the address for cleaner display
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),

              // Product List
              SizedBox(
                height: 400,
                child: ListView.builder(
                  itemCount: widget.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = widget.cartItems[index];
                    return ProductItem(
                      imageUrl: cartItem.product.productImages.isEmpty
                          ? 'assets/necklace.jpg'
                          : cartItem.product.productImages[0],
                      title: cartItem.product.productName,
                      description: cartItem.product.productDescription,
                      price: cartItem.product.productPrice.toString(),
                      quantity: cartItem.quantity.toString(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Note Field
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Note: ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      child: TextFormField(
                        controller: noteController,
                        decoration: const InputDecoration(
                          hintText: 'Type any message....',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.zero),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Total Price and Checkout Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal, ${calculateItemCount()} items',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'IDR ${calculateTotal()}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Payment Options
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Use the reusable PaymentMethodWidget
                    PaymentMethodWidget(
                      onTap: () {
                        setState(() {
                          selectedPaymentType = 'Cash';
                        });
                      },
                      isSelected: selectedPaymentType == 'Cash',
                      icon: Icons.money,
                      title: 'Cash',
                      description:
                          'Pay cash when the package arrives at the destination.',
                      iconColor: Colors.orange,
                      boxColor: Colors.orange[100]!,
                      borderColor: Colors.orange,
                    ),
                    PaymentMethodWidget(
                      icon: Icons.account_balance,
                      title: 'Bank Transfer',
                      description:
                          'Log in to your online account and make payment.',
                      iconColor: Colors.blue,
                      boxColor: Colors.blue[100]!,
                      borderColor: Colors.blue,
                      isSelected: selectedPaymentType == 'Bank Transfer',
                      onTap: () {
                        setState(() {
                          selectedPaymentType = 'Bank Transfer';
                        });
                      },
                    ),
                    PaymentMethodWidget(
                      isSelected: selectedPaymentType == 'Card',
                      icon: Icons.credit_card,
                      title: 'Card',
                      description: 'Pay using your credit or debit card.',
                      iconColor: Colors.green,
                      boxColor: Colors.green[100]!,
                      borderColor: Colors.green,
                      onTap: () {
                        setState(() {
                          selectedPaymentType = 'Card';
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
          height: 80,
          padding: const EdgeInsets.all(16),
          color: Colors.green[600], // Slightly darker green for bottom sheet
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹ ${calculateTotal()}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator()),
                  );
                  await placeOrder();
                  Navigator.pop(context); // Close dialog after completion
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade800,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text('Order', style: TextStyle(fontSize: 20)),
              ),
            ],
          )),
    );
  }

  // Helper method to format the address
  String _formatAddress(Address? address) {
    if (address == null) {
      return 'No address available';
    }

    final addressParts = [
      address.location,
      address.landmark ?? '', // Default to empty string if null
      address.city,
      address.state,
      address.pincode,
    ];

    // Join non-null and non-empty address parts with a comma
    return addressParts.where((part) => part.isNotEmpty).join(', ');
  }
}
