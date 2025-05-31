import 'package:flutter/material.dart';
import 'glass_card.dart';

class WatchCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String location;
  final String imagePath;
  final bool availability;

  const WatchCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.location,
    required this.imagePath,
    required this.availability,
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
            child:
                imagePath.isEmpty
                    ? const Icon(Icons.watch, color: Colors.white, size: 28)
                    : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.watch,
                              color: Colors.white,
                              size: 28,
                            ),
                      ),
                    ),
          ),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subtitle, style: const TextStyle(color: Colors.white70)),
              Text(location, style: const TextStyle(color: Colors.white38)),
              const SizedBox(height: 4),
              Text(
                availability ? "Available" : "Not Available",
                style: TextStyle(
                  color: availability ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
