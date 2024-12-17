import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;

  const RatingStars({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ..._buildStars(),
        const SizedBox(width: 8), // Spacing between stars and text
        Text(
          rating.toStringAsFixed(1), // Display rating with one decimal place
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  List<Widget> _buildStars() {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      if (i <= rating) {
        stars.add(const Icon(Icons.star, color: Colors.yellow, size: 24));
      } else if (i - rating < 1) {
        stars.add(const Icon(Icons.star_half, color: Colors.yellow, size: 24));
      } else {
        stars.add(const Icon(Icons.star_border, color: Colors.yellow, size: 24));
      }
    }
    return stars;
  }
}
