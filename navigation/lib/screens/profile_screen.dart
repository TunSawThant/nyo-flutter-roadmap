import 'package:flutter/material.dart';

// Pass Data Screen ၏ named route version
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF8),
      appBar: AppBar(
        title: const Text('Profile Screen'),
        backgroundColor: const Color(0xFF00C896),
      ),
      body: const Center(
        child: Text(
          'Profile Screen\n(Named Route Version)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
