import 'package:flutter/material.dart';
import 'Address/saved_address.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.amber.shade100, // Lighter background for better contrast
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined)),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('assets/profilePic.png'),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  'Aditya Janga',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  'aditya@example.com',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(
                  height: 24,
                ),
                // Account Information Section
                ProfileOption(
                  title: 'Account Information',
                  icon: Icons.person,
                  onTap: () {
                    // Navigate to the account info page
                  },
                ),
                const SizedBox(height: 12),
                // Saved Address Section
                ProfileOption(
                  title: 'Saved Address',
                  icon: Icons.location_on,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SavedAddress()));
                  },
                ),
                const SizedBox(height: 12),
                // Payment Method Section
                ProfileOption(
                  title: 'Payment Method',
                  icon: Icons.payment,
                  onTap: () {
                    // Navigate to payment method page
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ProfileOption({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          leading: Icon(
            icon,
            color: Colors.black,
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
