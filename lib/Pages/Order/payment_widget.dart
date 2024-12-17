import 'package:flutter/material.dart';

class PaymentMethodWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;
  final Color boxColor;
  final Color borderColor;
  final bool isSelected; // Indicates if this payment method is selected
  final VoidCallback onTap; // Callback for user interaction

  const PaymentMethodWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
    required this.boxColor,
    required this.borderColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle taps
      child: Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : boxColor, // Highlight selected
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : borderColor, // Highlight border
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? Colors.black : iconColor, // Highlight icon
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 160, // Control the width of the description
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(color: iconColor),
                maxLines: 3, // Optional: Handle overflow gracefully
              ),
            ),
          ],
        ),
      ),
    );
  }
}
