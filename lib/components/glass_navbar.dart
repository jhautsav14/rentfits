import 'dart:ui';
import 'package:flutter/material.dart';

class GlassBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const GlassBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.cyanAccent,
            unselectedItemColor: Colors.white70,
            currentIndex: selectedIndex,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            onTap: onTap,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: "Explore",
              ),
              BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: "Scan"),
              BottomNavigationBarItem(
                icon: Icon(Icons.access_time),
                label: "Rentals",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
