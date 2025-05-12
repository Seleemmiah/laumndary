import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taste_app/pages/login_page.dart'; // Update if needed

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = 'Guest';

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  // ✅ Fetch and update the user's display name
  void fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload(); // Ensure we get the latest user data
    final updatedUser = FirebaseAuth.instance.currentUser;

    setState(() {
      userName = updatedUser?.displayName ?? 'Guest';
    });
  }

  // ✅ Sign out method
  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signUserOut,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome $userName',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Navigate to other pages if needed
              },
              child: const Text('Go to Other Page'),
            ),
          ],
        ),
      ),
    );
  }
}
