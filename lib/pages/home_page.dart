import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  final supabase = Supabase.instance.client;

  bool isLoading = true;
  List<dynamic> watches = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      authCtrl.fetchProfile();
      authCtrl.fetchLocation();
      fetchWatches();
    });
  }

  Future<void> fetchWatches() async {
    try {
      final response = await supabase.from('watches').select('*');
      setState(() {
        watches = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar("Error", "Failed to fetch watches: $e");
    }
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
                                      const Rect.fromLTWH(0, 0, 200, 70),
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
                  child:
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : watches.isEmpty
                          ? const Center(
                            child: Text(
                              "No watches available",
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                          : ListView(
                            children:
                                watches.map((watch) {
                                  return InkWell(
                                    onTap: () async {
                                      await fetchWatches();
                                      Get.to(
                                        () => WatchDetailsPage(
                                          watchId:
                                              watch['id'], // 🔥 Pass watchId
                                          title: watch['title'],
                                          subtitle: watch['subtitle'],
                                          imagePath: watch['image_url'] ?? '',
                                          price: watch['price_per_hour'] ?? 0,
                                          location: watch['location'] ?? '',
                                          availability:
                                              watch['availability'] ?? false,
                                          features: List<String>.from(
                                            watch['features'] ?? [],
                                          ),
                                        ),
                                      );
                                    },
                                    child: WatchCard(
                                      title: watch['title'],
                                      subtitle: watch['subtitle'],
                                      price: "₹${watch['price_per_hour'] ?? 0}",
                                      location: watch['location'] ?? '',
                                      imagePath: watch['image_url'] ?? '',
                                      availability:
                                          watch['availability'] ?? false,
                                    ),
                                  );
                                }).toList(),
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
