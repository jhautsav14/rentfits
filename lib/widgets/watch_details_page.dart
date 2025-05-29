import 'package:flutter/material.dart';

class WatchDetailsPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final int price;
  final String location;
  final List<String> features;

  const WatchDetailsPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.price,
    required this.location,
    required this.features,
  });

  @override
  State<WatchDetailsPage> createState() => _WatchDetailsPageState();
}

class _WatchDetailsPageState extends State<WatchDetailsPage> {
  int rentalHours = 1;

  int get total => widget.price * rentalHours + 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Container(
        padding: const EdgeInsets.only(
          top: 48,
          left: 16,
          right: 16,
          bottom: 80,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0f172a), Color(0xFF4c1d95)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          children: [
            // Top bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconBtn(Icons.arrow_back, () => Navigator.pop(context)),
                const Text(
                  "Watch Details",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                _iconBtn(Icons.favorite_border, () {}),
              ],
            ),
            const SizedBox(height: 20),

            // Watch image
            Center(
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        widget.imagePath,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      "Available",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.subtitle,
              style: const TextStyle(color: Colors.white60),
            ),

            const SizedBox(height: 12),
            Row(
              children: const [
                Icon(Icons.star, color: Colors.yellow, size: 16),
                SizedBox(width: 4),
                Text(
                  "4.8 (124 reviews)",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 16),
                Icon(Icons.battery_full, color: Colors.greenAccent, size: 16),
                SizedBox(width: 4),
                Text("95% charged", style: TextStyle(color: Colors.white)),
              ],
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_pin, color: Colors.cyan, size: 16),
                const SizedBox(width: 4),
                Text(
                  widget.location,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Text(
              "Features",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  widget.features
                      .map(
                        (feature) => Chip(
                          label: Text(feature),
                          backgroundColor: Colors.white10,
                          labelStyle: const TextStyle(color: Colors.black),
                          side: const BorderSide(color: Colors.white24),
                        ),
                      )
                      .toList(),
            ),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rental Duration",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _iconBtn(Icons.remove, () {
                            if (rentalHours > 1) setState(() => rentalHours--);
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "$rentalHours h",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          _iconBtn(
                            Icons.add,
                            () => setState(() => rentalHours++),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "₹${widget.price} x $rentalHours",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const Text(
                            "Security: ₹0",
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            "Total: ₹$total",
                            style: const TextStyle(
                              color: Colors.cyanAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.flash_on),
              label: Text("Rent Now ₹$total"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Handle rent action
              },
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.map),
              label: const Text("View on Map"),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Open map
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
