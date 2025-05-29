import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartwatch_rent_web/controllers/nav_controller.dart';
import 'package:smartwatch_rent_web/pages/auth_gate.dart';
import 'package:smartwatch_rent_web/pages/main_home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'controllers/auth_controller.dart';
import 'pages/login_page.dart';
import 'pages/user_details_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: 'https://xlcifyhnyidxbmuxqhov.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhsY2lmeWhueWlkeGJtdXhxaG92Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg0NDY2NjgsImV4cCI6MjA2NDAyMjY2OH0.xz0jZapaRENbSIahllbNZk1q50Fde1oAn7kHnDLQlfw',
  );

  Get.put(AuthController());
  Get.put(NavController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RentFit',
      debugShowCheckedModeBanner: false,
      initialRoute: '/auth-gate',
      getPages: [
        GetPage(name: '/auth-gate', page: () => const AuthGate()),
        GetPage(name: '/', page: () => const LoginPage()),
        GetPage(name: '/details', page: () => const UserDetailsPage()),
        GetPage(name: '/home', page: () => MainHomePage()),
      ],
    );
  }
}
