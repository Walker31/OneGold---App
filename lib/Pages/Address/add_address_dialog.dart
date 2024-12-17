import 'package:flutter/material.dart';

class AddAddressDialog extends StatefulWidget {
  final Function(String, String, String, String, String) onSave;

  const AddAddressDialog({super.key, required this.onSave});

  @override
  AddAddressDialogState createState() => AddAddressDialogState();
}

class AddAddressDialogState extends State<AddAddressDialog> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Address'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: landmarkController,
              decoration: const InputDecoration(labelText: 'Landmark'),
            ),
            TextField(
              controller: cityController,
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: stateController,
              decoration: const InputDecoration(labelText: 'State'),
            ),
            TextField(
              controller: postalCodeController,
              decoration: const InputDecoration(labelText: 'Postal Code'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(
                locationController.text,
                landmarkController.text,
                cityController.text,
                postalCodeController.text,
                stateController.text);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
