import 'package:flutter/material.dart';
import 'glass_card.dart';

class WatchCard extends StatelessWidget {
  final String title, subtitle, price, location;

  const WatchCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: GlassCard(
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          leading: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white24,
            ),
            child: const Icon(Icons.watch, color: Colors.white),
          ),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subtitle, style: const TextStyle(color: Colors.white70)),
              Text(location, style: const TextStyle(color: Colors.white38)),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text("per hour", style: TextStyle(color: Colors.white54)),
            ],
          ),
        ),
      ),
    );
  }
}
