import 'package:flutter/material.dart';

import '../../API/cart_service.dart';
import '../../Models/cart.dart';

class CartItemWidget extends StatelessWidget {
  final Cart item;
  final int productId;
  final Function() onItemRemoved; // Callback function

  // Constructor initialization
  CartItemWidget({super.key, required this.item, required this.onItemRemoved})
      : productId = item.product.productId;

  Future<void> deleteItem(BuildContext context, int productId) async {
    try {
      // Update the cart by removing the item
      await CartService.updateCart(productId, CartAction.delete, context); // 'delete' is the action
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removed from cart')),
      );
      onItemRemoved(); // Notify parent to refresh the cart
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove item: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Product image placeholder using an asset
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: item.product.productImages.isNotEmpty
                ? Image.asset(
                    'assets/necklace.jpg', // Display the asset image (update path as needed)
                    fit: BoxFit.cover,
                  )
                : const Center(
                    child: Icon(Icons.image, color: Colors.white),
                  ),
          ),
          const SizedBox(width: 16),
          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${item.product.categoryName} | ${item.product.productDescription.substring(0, 20)}...", // Display truncated description
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "\$${item.product.productPrice.toStringAsFixed(2)} x ${item.quantity}",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  "Rating: ${item.product.averageRating.toStringAsFixed(1)} ⭐", // Display average rating
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () {
              // Trigger the deleteItem function to remove the item from the cart
              deleteItem(context, productId);
            },
          ),
        ],
      ),
    );
  }
}
