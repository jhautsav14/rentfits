import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartwatch_rent_web/components/glass_card.dart';
import 'package:smartwatch_rent_web/components/watch_card.dart';
import 'package:smartwatch_rent_web/controllers/auth_controller.dart';
import 'package:smartwatch_rent_web/widgets/watch_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authCtrl = Get.find<AuthController>();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      authCtrl.fetchProfile();
      authCtrl.fetchLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0f172a), Color(0xFF4c1d95), Color(0xFF0f172a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authCtrl.userProfile['name'] ?? 'Welcome!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              foreground:
                                  Paint()
                                    ..shader = const LinearGradient(
                                      colors: [
                                        Colors.cyan,
                                        Colors.purpleAccent,
                                      ],
                                    ).createShader(
                                      Rect.fromLTWH(0, 0, 200, 70),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Smart watches on demand",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.notifications, color: Colors.white),
                        const SizedBox(width: 12),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.cyan,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(
                  () => GlassCard(
                    child: Row(
                      children: [
                        const Icon(Icons.location_pin, color: Colors.cyan),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            authCtrl.location.value.isNotEmpty
                                ? authCtrl.location.value
                                : "Fetching location...",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () => authCtrl.fetchLocation(),
                          child: const Text(
                            "Refresh",
                            style: TextStyle(color: Colors.cyanAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Available Near You",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: [
                      InkWell(
                        onTap:
                            () => Get.to(
                              () => WatchDetailsPage(
                                title: "Apple Watch Series 9",
                                subtitle: "45mm GPS",
                                imagePath: "assets/apple.jpg",
                                price: 150,
                                location:
                                    "Connaught Place, Delhi • 0.5 km away",
                                features: [
                                  "GPS",
                                  "Heart Rate",
                                  "ECG",
                                  "Always-On Display",
                                ],
                              ),
                            ),
                        child: const WatchCard(
                          title: "Apple Watch Series 9",
                          subtitle: "45mm GPS",
                          price: "₹150",
                          location: "Connaught Place, Delhi",
                        ),
                      ),
                      InkWell(
                        onTap:
                            () => Get.to(
                              () => WatchDetailsPage(
                                title: "Samsung Galaxy Watch 6",
                                subtitle: "44mm LTE",
                                imagePath:
                                    "assets/samsung.png", // You might want to add this image
                                price: 120,
                                location:
                                    "Bandra West, Mumbai • 1.2 km away", // Adjusted example
                                features: [
                                  "LTE",
                                  "Heart Rate",
                                  "ECG",
                                  "Sleep Tracking",
                                ],
                              ),
                            ),
                        child: const WatchCard(
                          title: "Samsung Galaxy Watch 6",
                          subtitle: "44mm LTE",
                          price: "₹120",
                          location: "Bandra West, Mumbai",
                        ),
                      ),
                      InkWell(
                        onTap:
                            () => Get.to(
                              () => WatchDetailsPage(
                                title: "Fitbit Versa 4",
                                subtitle: "Solar Edition",
                                imagePath:
                                    "assets/fit.jpg", // You might want to add this image
                                price: 200,
                                location:
                                    "Koramangala, Bangalore • 0.8 km away", // Adjusted example
                                features: [
                                  "Solar Charging",
                                  "GPS",
                                  "Advanced Running Metrics",
                                ],
                              ),
                            ),
                        child: const WatchCard(
                          title: "Fitbit Versa 4",
                          subtitle: "Solar Edition",
                          price: "₹200",
                          location: "Koramangala, Bangalore",
                        ),
                      ),
                    ],
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
