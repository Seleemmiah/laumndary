import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.onTabChange,
  });

  final void Function(int)? onTabChange;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GNav(
      // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      color: Colors.grey[350],
      backgroundColor: Colors.grey.shade300,
      activeColor: Colors.grey.shade700,
      tabActiveBorder: Border.all(color: Colors.white),
      tabBackgroundColor: Colors.grey.shade100,
      mainAxisAlignment: MainAxisAlignment.center,
      tabBorderRadius: 20,
      //gap: 8,
      onTabChange: (value) => onTabChange!(value),
      tabs: [
        GButton(icon: Icons.home, text: 'Home'),
        GButton(icon: Icons.local_laundry_service, text: 'Orders'),
        GButton(icon: Icons.add_circle_outline, text: 'Request'),
        GButton(icon: Icons.chat, text: 'Chat'),
        GButton(icon: Icons.person, text: 'Profile'),
      ],
    ));
  }
}
