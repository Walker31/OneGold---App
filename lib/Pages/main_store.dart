import 'package:flutter/material.dart';
import 'package:onegold/Pages/Cart/cart_main.dart';
import 'package:onegold/Pages/profile.dart';
import 'package:provider/provider.dart';
import '../Components/category_card.dart';
import '../Providers/category_provider.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => StoreState();
}

class StoreState extends State<Store> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
            // Custom Header Section
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/profilePic.png', // Replace with actual profile picture path
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Welcome, User!', // Replace with dynamic user name
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),

            // Drawer Menu Items
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Profile()),
                );
              },
              leading: const Icon(Icons.settings, color: Colors.blueAccent),
              title: const Text('Settings', style: TextStyle(fontSize: 18)),
            ),
            ListTile(
              onTap: () {
                // Handle Help or FAQs
              },
              leading: const Icon(Icons.help_outline, color: Colors.blueAccent),
              title: const Text('Help', style: TextStyle(fontSize: 18)),
            ),
            ListTile(
              onTap: () {
                // Handle Log Out
              },
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Log Out', style: TextStyle(fontSize: 18)),
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
              color: Colors.black,
            ),
          ),
        ],
        backgroundColor: Colors.green.shade200,
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.black26,
        title: const Text(
          "SHOP",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Consumer<StoreProvider>(
        builder: (context, storeProvider, child) {
          if (storeProvider.categorizedProducts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final categories = storeProvider.categorizedProducts;

          if (categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/empty_state.png', // Add a friendly image
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "No products available",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

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

                    // Using the `CategoryCard` widget with updated padding
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: CategoryCard(
                            category: category,
                            products: products,
                          ),
                        ),
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
