import 'package:flutter/material.dart';

import '../pages/home_page.dart'; // Or AuthPage()

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Create the animation controller for the sliding animation
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Animation duration
      vsync: this,
    );

    // Slide animation (moves from bottom to top)
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1), // Start from bottom (outside screen)
      end: Offset(0, 0), // End at the center of the screen
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start the animation
    _controller.forward();

    // Navigate to the next screen after splash duration
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        // Check if the widget is still active
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), // Or AuthPage()
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.white], // Gradient colors
          ),
        ),
        child: Center(
          child: SlideTransition(
            position: _slideAnimation, // Apply the sliding animation
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Circular Progress Indicator (spinning)
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      strokeWidth: 5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Text message below the animation
                const Text(
                  'NeuroAssist',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
