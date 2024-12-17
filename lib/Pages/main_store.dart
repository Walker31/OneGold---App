import 'package:flutter/material.dart';
import 'package:onegold/Pages/Cart/cart_main.dart';
import 'package:onegold/Pages/profile.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import '../Components/category_card.dart';
import '../Providers/category_provider.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => StoreState();
}

class StoreState extends State<Store> {
  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    logger.d('Initializing Store page...');

    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    storeProvider.fetchCategories();
    storeProvider.fetchProducts();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            // Custom Header Section with only Profile Picture
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.blueAccent,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/profilePic.png', // Replace with actual profile picture path
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover, // Ensures the image fits the circle
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),

            // Drawer Menu Items
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Profile()));
              },
              leading: const Icon(Icons.settings),
              title: const Text(
                'Settings',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const Divider(),

            // Additional Options
            ListTile(
              onTap: () {
                // Handle Log Out
              },
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
            ),
            ListTile(
              onTap: () {
                // Handle Help or FAQs
              },
              leading: const Icon(Icons.help_outline),
              title: const Text('Help'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartPage()));
            },
            icon: const Icon(
              Icons.shopping_cart,
              size: 28,
            ),
          ),
        ],
        backgroundColor: Colors.green.shade200,
        centerTitle: true,
        title: const Text(
          "SHOP",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
        ),
      ),
      body: Consumer<StoreProvider>(
        builder: (context, storeProvider, child) {
          if (storeProvider.categorizedProducts.isEmpty) {
            logger.d('Waiting for products...');
            return const Center(child: CircularProgressIndicator());
          }

          final categories = storeProvider.categorizedProducts;

          return CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = categories.keys.elementAt(index);
                    final products = categories[category];

                    if (products == null || products.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    // Using the `CategoryCard` widget
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                      child: CategoryCard(
                        category: category,
                        products: products,
                      ),
                    );
                  },
                  childCount: categories.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
