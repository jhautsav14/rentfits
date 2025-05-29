import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';

class AuthController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;

  var email = ''.obs;
  var isOtpSent = false.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var userProfile = {}.obs;

  var location = ''.obs;

  // Send OTP to Email
  Future<void> sendOtp(String emailInput) async {
    try {
      isLoading.value = true;
      email.value = emailInput;
      await _client.auth.signInWithOtp(email: emailInput);
      isOtpSent.value = true;
    } catch (e) {
      errorMessage.value = 'Failed to send OTP: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Verify OTP
  Future<void> verifyOtp(String otp) async {
    try {
      isLoading.value = true;
      final res = await _client.auth.verifyOTP(
        type: OtpType.email,
        email: email.value,
        token: otp,
      );

      if (res.user != null) {
        final exists = await checkUserExists(res.user!.id);
        if (exists) {
          Get.offAllNamed('/home');
        } else {
          Get.offAllNamed('/details');
        }
      } else {
        errorMessage.value = 'Invalid OTP';
      }
    } catch (e) {
      errorMessage.value = 'OTP verification failed: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Check if user exists in DB
  Future<bool> checkUserExists(String userId) async {
    final res =
        await _client.from('users').select('id').eq('id', userId).maybeSingle();
    return res != null;
  }

  // Save user details on first login
  Future<void> saveUserDetails({
    required String name,
    required String phone,
    required String dob,
  }) async {
    final id = _client.auth.currentUser!.id;
    await _client.from('users').insert({
      'id': id,
      'email': email.value,
      'name': name,
      'phone': phone,
      'dob': dob,
    });
    Get.offAllNamed('/home');
  }

  // Fetch user profile
  Future<void> fetchProfile() async {
    final id = _client.auth.currentUser!.id;
    final res = await _client.from('users').select().eq('id', id).single();
    userProfile.value = res;
  }

  // Logout
  Future<void> signOut() async {
    await _client.auth.signOut();
    Get.offAllNamed('/');
  }

  // location
  Future<void> fetchLocation() async {
    try {
      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) {
        location.value = 'Permission denied';
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final latitude = position.latitude;
      final longitude = position.longitude;

      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json',
      );

      final response = await http.get(
        url,
        headers: {'User-Agent': 'RentFitFlutterApp/1.0 (your@email.com)'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final city =
            data['address']['city'] ??
            data['address']['town'] ??
            data['address']['village'] ??
            data['address']['state'] ??
            'Unknown';
        final state = data['address']['state'] ?? '';
        location.value = "$city, $state";
      } else {
        location.value = "Location unavailable";
      }
    } catch (e) {
      print("Location API error: $e");
      location.value = "Failed to get location";
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }
}
