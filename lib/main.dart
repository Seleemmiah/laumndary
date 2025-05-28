import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'screens/splash_screen.dart';
import 'pages/chat_page.dart';
import 'pages/orders.dart';
import 'pages/profile_page.dart';
import 'pages/request_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taste App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreenWrapper(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/chat': (context) => ChatPage(),
        '/orders': (context) => OrdersPage(),
        '/request': (context) => RequestPickupPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}

class SplashScreenWrapper extends StatefulWidget {
  const SplashScreenWrapper({super.key});

  @override
  State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  @override
  void initState() {
    super.initState();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await Future.delayed(const Duration(seconds: 2)); // Splash delay

    final user = FirebaseAuth.instance.currentUser;

    if (mounted) {
      Navigator.pushReplacementNamed(
          context, user == null ? '/login' : '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
