import 'package:flutter/material.dart';
import 'package:onegold/Pages/ProductDisplay/product_display.dart';
import '../Models/product.dart';
import 'product_card.dart';

class CategoryCard extends StatefulWidget {
  final String category;
  final List<Product> products;

  const CategoryCard({
    super.key,
    required this.category,
    required this.products,
  });

  @override
  CategoryCardState createState() => CategoryCardState();
}

class CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category title with enhanced styling
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              widget.category,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Horizontal scrollable row of product cards
          Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.products.map((product) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to ProductDetailPage with productId
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDisplay(
                                productID: product.productId,
                              ),
                            ),
                          );
                        },
                        child: ProductCard(product: product),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Scroll indicator on the right side
              Positioned(
                right: 0,
                top: 50,
                bottom: 50,
                child: Container(
                  width: 16,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.transparent, Colors.black12],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
