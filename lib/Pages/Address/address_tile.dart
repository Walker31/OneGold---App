import 'package:flutter/material.dart';
import 'package:onegold/Models/address.dart';

Widget addressTile(Address address) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 4, // To match the overall elevation used in the checkout page
    color: Colors.white, // A clean white background for each card
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location (Bold and primary color)
          Text(
            address.location,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87, // Dark text for the location
            ),
          ),
          const SizedBox(height: 6),

          // City, State, and Pincode with matching icons
          Row(
            children: [
              Icon(Icons.location_city,
                  size: 22,
                  color: Colors.blue.shade700), // Using the primary color
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${address.city}, ${address.state} - ${address.pincode}',
                  style: TextStyle(
                      fontSize: 16,
                      color:
                          Colors.blueGrey.shade700), // Color to match the theme
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Landmark (optional)
          Row(
            children: [
              Icon(Icons.landscape,
                  size: 22,
                  color: Colors.blue.shade700), // Using the primary color again
              const SizedBox(width: 8),
              Text(
                address.landmark != 'Unknown'
                    ? address.landmark!
                    : 'No Landmark',
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color:
                      Colors.blueGrey, // A slightly lighter color for landmark
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Created At with adjusted color
          Row(
            children: [
              Icon(Icons.access_time,
                  size: 22, color: Colors.blue.shade700), // Matching icon color
              const SizedBox(width: 8),
              Text(
                'Added on: ${address.createdAt.toLocal().toString().split(' ')[0]}', // Date format adjustment
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey), // A lighter color for the date
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
