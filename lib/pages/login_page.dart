import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    final emailCtrl = TextEditingController();
    final otpCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0f172a), Color(0xFF4c1d95), Color(0xFF0f172a)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Obx(() {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "RentFit",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      foreground:
                          Paint()
                            ..shader = LinearGradient(
                              colors: [Colors.cyan, Colors.purpleAccent],
                            ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Smartwatch Rentals, Simplified",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 40),

                  // Email field
                  TextField(
                    controller: emailCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  // OTP field (conditional)
                  if (authCtrl.isOtpSent.value)
                    TextField(
                      controller: otpCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Enter OTP',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),

                  const SizedBox(height: 24),

                  // Action button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed:
                        authCtrl.isLoading.value
                            ? null
                            : () {
                              if (authCtrl.isOtpSent.value) {
                                authCtrl.verifyOtp(otpCtrl.text.trim());
                              } else {
                                authCtrl.sendOtp(emailCtrl.text.trim());
                              }
                            },
                    child:
                        authCtrl.isLoading.value
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                              authCtrl.isOtpSent.value
                                  ? 'Verify OTP'
                                  : 'Send OTP',
                              style: const TextStyle(fontSize: 16),
                            ),
                  ),

                  if (authCtrl.errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      authCtrl.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
