import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:logger/logger.dart';
import 'package:onegold/API/address_service.dart';
import 'package:onegold/Models/address.dart';
import 'package:onegold/Providers/address_provider.dart';
import 'package:onegold/Providers/customer_provider.dart';

import 'address_tile.dart';
import 'add_address_dialog.dart'; // Import the dialog for adding an address

class SavedAddress extends StatefulWidget {
  const SavedAddress({super.key});

  @override
  SavedState createState() => SavedState();
}

class SavedState extends State<SavedAddress> {
  Logger logger = Logger();
  List<Address> addresses = [];
  int? customerId;

  @override
  void initState() {
    super.initState();
    // Fetch customerId from CustomerProvider and update state
    customerId = CustomerProvider().customerId;
    if (customerId != null) {
      fetchAddress(customerId.toString());
    } else {
      logger.e('Customer ID is null');
    }
  }

  // Fetch saved addresses
  Future<void> fetchAddress(String customerId) async {
    try {
      final fetchedAddresses =
          await AddressService().fetchAddresses(customerId);
      setState(() {
        addresses = fetchedAddresses;
      });
    } catch (e) {
      logger.e('Error: $e');
    }
  }

  // Open the Add Address Dialog
  void openAddAddressDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddAddressDialog(
          onSave: (location, landmark, city, postalCode, state) {
            setState(() {
              Address newAddress = Address(
                state: state,
                createdAt: DateTime.now(),
                location: location,
                pincode: postalCode,
                landmark: landmark,
                city: city,
              );
              addAddress(newAddress);
              addresses.add(newAddress);
            });
          },
        );
      },
    );
  }

  // Add a new address using the AddressService
  Future<void> addAddress(Address address) async {
    try {
      final response = await AddressService().addAddress(address);

      if (response.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add address: ${response['error']}'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address added successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh addresses
        if (customerId != null) {
          await fetchAddress(customerId.toString());
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> deleteAddress(int addressId) async {
    try {
      final response = await AddressService().deleteAddress(addressId);

      if (response.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete address: ${response['error']}'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address Deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh addresses
        if (customerId != null) {
          await fetchAddress(customerId.toString());
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Set an address as the default
  void setAsDefaultAddress(Address address) {
    AddressProvider().setDefaultAddress(address);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Address set as default: ${address.location}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        title: const Text(
          "Saved Addresses",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade700,
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            if (addresses.isEmpty)
              Center(
                child: Text(
                  'No saved addresses yet.',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.green.shade600,
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return GestureDetector(
                      onLongPress: () => setAsDefaultAddress(address),
                      child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: 1.0,
                          child: Slidable(
                            startActionPane: ActionPane(
                              motion:
                                  const DrawerMotion(), // Defines the sliding animation
                              children: [
                                SlidableAction(
                                  borderRadius: BorderRadius.circular(8),
                                  onPressed: (context) {
                                    deleteAddress(address.addressId);
                                  },
                                  backgroundColor: Colors
                                      .red, // Background color for delete action
                                  foregroundColor:
                                      Colors.white, // Icon and text color
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: addressTile(address),
                          )),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Transform.scale(
        scale: 1.2,
        child: FloatingActionButton(
          onPressed: openAddAddressDialog,
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.add, size: 30),
        ),
      ),
    );
  }
}
