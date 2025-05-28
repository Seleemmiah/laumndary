import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taste_app/pages/chat_page.dart';
import 'package:taste_app/pages/orders.dart';
import 'package:taste_app/pages/profile_page.dart';
import 'package:taste_app/components/bottom_nav.dart';
import 'package:taste_app/pages/login_page.dart';
import 'package:taste_app/pages/request_page.dart';
import 'package:taste_app/screens/home_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = 'Guest';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _pages => [
        HomeScreen(userName: userName),
        OrdersPage(),
        RequestPickupPage(),
        ChatPage(),
        ProfilePage(),
      ];

  void fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload(); // Refresh user data
    final updatedUser = FirebaseAuth.instance.currentUser;

    setState(() {
      userName = updatedUser?.displayName ?? 'Guest';
    });
  }

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
      bottomNavigationBar: BottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      body: userName == 'Guest' &&
              FirebaseAuth.instance.currentUser?.displayName != 'Guest'
          ? const Center(child: CircularProgressIndicator())
          : _pages[_selectedIndex],
    );
  }
}
