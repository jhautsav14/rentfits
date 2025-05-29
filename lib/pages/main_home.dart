import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartwatch_rent_web/components/glass_navbar.dart';
import 'package:smartwatch_rent_web/controllers/nav_controller.dart';
import 'package:smartwatch_rent_web/pages/home_page.dart';
import 'package:smartwatch_rent_web/pages/scan_page.dart';
import 'package:smartwatch_rent_web/pages/rentals_page.dart';
import 'package:smartwatch_rent_web/pages/profile_page.dart';

class MainHomePage extends StatelessWidget {
  MainHomePage({super.key});

  final List<Widget> pages = [
    const HomePage(),
    const ScanPage(),
    const RentalsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final navCtrl = Get.find<NavController>();

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
        body: SafeArea(child: Obx(() => pages[navCtrl.selectedIndex.value])),
        bottomNavigationBar: Obx(
          () => GlassBottomNavBar(
            selectedIndex: navCtrl.selectedIndex.value,
            onTap: navCtrl.changePage,
          ),
        ),
      ),
    );
  }
}
