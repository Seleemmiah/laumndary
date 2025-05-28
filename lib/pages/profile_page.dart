import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.grey[200],
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Add edit profile functionality here
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
