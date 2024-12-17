import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:onegold/API/api_main.dart';
import 'package:provider/provider.dart';
import '../../API/cart_service.dart';
import '../../API/customer_service.dart';
import '../../Components/action_button.dart';
import '../../Components/rating_stars.dart';
import '../../Models/cart.dart';
import '../../Models/product.dart';
import '../../Providers/customer_provider.dart';
import '../Order/checkout.dart';

class ProductDisplay extends StatefulWidget {
  const ProductDisplay({super.key, this.productID});

  final int? productID;

  @override
  ProductDisplayState createState() => ProductDisplayState();
}

class ProductDisplayState extends State<ProductDisplay> {
  Logger logger = Logger();
  late Future<Product> _productFuture;
  bool _isExpanded = false;
  bool favorite = false;

  @override
  void initState() {
    super.initState();
    final productId = widget.productID ?? 1;
    logger.i('Fetching product with ID: $productId');
    _productFuture = ApiService.fetchProductById(productId);
    final customerProvider = Provider.of<CustomerProvider>(context, listen: false);
    favorite = customerProvider.wishlist.contains(productId);
  }

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

  // Buy Now functionality to navigate to Checkout page
  void buyNow(Product product) {
    final customerId =
        Provider.of<CustomerProvider>(context, listen: false).customerId;

    if (customerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please log in to proceed with the purchase.')),
      );
      return;
    }

    // Create a Cart object
    final cartItem = Cart(
      id: 1, // Set this appropriately if needed
      customerId: customerId,
      product: product,
      quantity: 1,
      productId: product.productId,
      total: product.productPrice * 1, // Assuming quantity is 1
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Checkout(
          cartItems: [cartItem], // Pass the list of Cart items
        ),
      ),
    );
  }

  // Handle favorite toggle to add/remove from wishlist
  void toggleFavorite() {
    setState(() {
      favorite = !favorite;
    });

    final customerId =
        Provider.of<CustomerProvider>(context, listen: false).customerId;

    if (customerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to manage wishlist.')),
      );
      return;
    }

    if (favorite) {
      CustomerService.addToWishlist(widget.productID);
    } else {
      CustomerService.removeToWishlist(widget.productID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              toggleFavorite();
            },
            icon: Icon(
                !favorite ? Icons.favorite_border_outlined : Icons.favorite),
            tooltip: 'Add to Wishlist',
          ),
          IconButton(
            onPressed: () {}, // Share Product
            icon: const Icon(Icons.ios_share_rounded),
            tooltip: 'Share Product',
          ),
        ],
        leading: IconButton(
          tooltip: favorite ? 'Remove from Wishlist' : 'Add to Wishlist',
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        title: const Text(
          'Product Details',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            Product product = snapshot.data!;

            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset('assets/necklace.jpg'),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Product Name and Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '₹${product.productPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Rating Stars
                        RatingStars(rating: product.averageRating),

                        const SizedBox(height: 8),

                        // Product Description
                        Text(
                          _isExpanded ||
                                  product.productDescription.length <= 100
                              ? product.productDescription
                              : '${product.productDescription.substring(0, 100)}...',
                          style: const TextStyle(fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Text(
                            _isExpanded ? 'Read Less' : 'Read More',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ActionButton(
                              text: 'Buy Now',
                              bgColor: Colors.white,
                              textColor: Colors.black,
                              onPressed: () {
                                buyNow(product); // Use the buyNow function here
                              },
                            ),
                            ActionButton(
                              text: 'Add to Cart',
                              bgColor: Colors.black,
                              textColor: Colors.white,
                              onPressed: () {
                                addToCart(product.productId);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text('No product found.'));
          }
        },
      ),
    );
  }
}
