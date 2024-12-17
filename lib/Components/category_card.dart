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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category title
          Text(
            widget.category,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          // Horizontal scrollable row of product cards
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
                    child: ProductCard(
                      product: product
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
