import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  // Check if user exists in 'users' table
  Future<bool> checkUserExists(String userId) async {
    final response =
        await _client.from('users').select('id').eq('id', userId).maybeSingle();

    return response != null;
  }

  // Save user details on first login
  Future<void> saveUserDetails({
    required String name,
    required String phone,
    required String dob,
    required String email,
  }) async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('users').insert({
      'id': userId,
      'name': name,
      'phone': phone,
      'dob': dob,
      'email': email,
    });
  }

  // Get user profile for Home page
  Future<Map<String, dynamic>> getUserProfile() async {
    final userId = _client.auth.currentUser!.id;
    final data = await _client.from('users').select().eq('id', userId).single();
    return data;
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
