import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;

  const SquareTile({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[250],
      ),
      child: Image.asset(imagePath),
      height: 40,
      // padding: EdgeInsets.all(20),
      // margin: EdgeInsets.only(right: 20),
    );
  }
}
