import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taste_app/pages/chat_page.dart';
import 'package:taste_app/pages/orders.dart';
import 'package:taste_app/pages/profile_page.dart';
import 'package:taste_app/components/bottom_nav.dart';
import 'package:taste_app/pages/login_page.dart';
import 'package:taste_app/pages/request_page.dart';
import 'package:taste_app/screens/home_screen.dart'; // Update if needed

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = 'Guest'; // Default to 'Guest' if empty

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  // this selected index controls the bottom bar
  int _selectedIndex = 0;

  // this function updates our selected index when the user tap on the selected bar
  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // pages to display
  List<Widget> get _pages => [
        HomeScreen(userName: userName),
        OrdersPage(),
        RequestPickupPage(),
        ChatPage(),
        ProfilePage()
      ];

  //  Fetch and update the user's display name
  void fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload(); // Ensure we get the latest user data
    final updatedUser = FirebaseAuth.instance.currentUser;

    setState(() {
      userName = updatedUser?.displayName ?? 'Guest';
    });
  }

  //  Sign out method
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
      backgroundColor: Colors.grey[350],
      bottomNavigationBar: BottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      appBar: AppBar(
        title: const Text('Home Page'),
        leading: Container(),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signUserOut,
          ),
        ],
      ),
      // body: _pages[_selectedIndex],
      body: userName == 'Guest' &&
              FirebaseAuth.instance.currentUser?.displayName != 'Guest'
          ? const Center(child: CircularProgressIndicator())
          : _pages[_selectedIndex],
    );
  }
}
