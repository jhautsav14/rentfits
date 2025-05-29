// lib/pages/auth_gate.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    // Check if user is logged in
    if (user != null) {
      // Navigate to Home
      Future.microtask(() => Get.offAllNamed('/home'));
    } else {
      // Navigate to Login
      Future.microtask(() => Get.offAllNamed('/'));
    }

    // While redirecting, show a splash loader
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: CircularProgressIndicator(color: Colors.cyanAccent)),
    );
  }
}
