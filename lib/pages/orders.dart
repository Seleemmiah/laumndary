import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Add search functionality here
            },
          ),
        ],
      ),
    );
  }
}
