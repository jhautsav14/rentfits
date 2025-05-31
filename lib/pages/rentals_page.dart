import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/glass_card.dart';

class RentalsPage extends StatefulWidget {
  const RentalsPage({super.key});

  @override
  State<RentalsPage> createState() => _RentalsPageState();
}

class _RentalsPageState extends State<RentalsPage> {
  final supabase = Supabase.instance.client;
  List<dynamic> rentals = [];
  bool isLoading = true;

  String formatDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    final formattedDate =
        "${dateTime.day.toString().padLeft(2, '0')}-"
        "${dateTime.month.toString().padLeft(2, '0')}-"
        "${dateTime.year}";
    final formattedTime =
        "${dateTime.hour.toString().padLeft(2, '0')}:"
        "${dateTime.minute.toString().padLeft(2, '0')}";
    return "$formattedDate at $formattedTime";
  }

  @override
  void initState() {
    super.initState();
    fetchRentals();
  }

  Future<void> fetchRentals() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        Get.snackbar("Error", "User not authenticated");
        return;
      }

      final response = await supabase
          .from('rentals')
          .select('*, watches (title,image_url)')
          .eq('user_id', user.id)
          .order('otp_sent_time', ascending: false);

      setState(() {
        rentals = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar("Error", "Failed to fetch rentals: $e");
    }
  }

  void _showQrBottomSheet(BuildContext context, String otp, String watchTitle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                // Watch title
                Text(
                  watchTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // QR Code with white background
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: QrImageView(
                    data: otp,
                    version: QrVersions.auto,
                    size: 200,
                  ),
                ),
                const SizedBox(height: 20),

                // OTP Text
                const Text(
                  "Your OTP",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  otp,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 24),

                // Close button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.repeat, color: Colors.white),
            const SizedBox(width: 8),
            const Text("Your Rentals", style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.transparent,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : rentals.isEmpty
              ? const Center(
                child: Text(
                  "No rentals found",
                  style: TextStyle(color: Colors.white70),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                reverse: false,
                itemCount: rentals.length,
                itemBuilder: (context, index) {
                  final rental = rentals[index];
                  final watchTitle =
                      rental['watches']?['title'] ?? 'Unknown Watch';
                  final status = rental['status'] ?? 'Unknown';
                  final otp = rental['otp'] ?? 'N/A';
                  final startTime =
                      rental['start_time'] != null
                          ? DateTime.parse(
                            rental['start_time'],
                          ).toLocal().toString()
                          : 'N/A';
                  final endTime =
                      rental['end_time'] != null
                          ? DateTime.parse(
                            rental['end_time'],
                          ).toLocal().toString()
                          : 'N/A';
                  final duration =
                      rental['rental_duration']?.toString() ?? 'N/A';
                  final cost = rental['cost']?.toString() ?? 'N/A';
                  final bookingDateTime =
                      rental['otp_sent_time'] != null
                          ? formatDateTime(rental['otp_sent_time'])
                          : 'N/A';
                  final watchImageUrl = rental['watches']?['image_url'] ?? '';

                  return GestureDetector(
                    onTap: () => _showQrBottomSheet(context, otp, watchTitle),
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: GlassCard(
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Watch Image
                              watchImageUrl.isNotEmpty
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      watchImageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                            Icons.watch,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                    ),
                                  )
                                  : Icon(
                                    Icons.watch,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                              const SizedBox(width: 12),

                              // Booking Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      watchTitle,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Booking: $bookingDateTime",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Text(
                                          "Status: ",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          status,
                                          style: TextStyle(
                                            color:
                                                status == 'pending'
                                                    ? Colors.orange
                                                    : status == 'active'
                                                    ? Colors.green
                                                    : Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "startTime - endTime (hrs)",
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "$startTime - $endTime ($duration hrs)",
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "Cost: ₹$cost",
                                      style: const TextStyle(
                                        color: Colors.cyanAccent,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),

                              // OTP Indicator
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "OTP $otp",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  const Icon(
                                    Icons.qr_code_2,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
