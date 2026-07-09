import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'presenter_page.dart';
import 'presensi_page.dart';
import 'riwayat_page.dart';
import 'profil_page.dart';
import '../config/app_theme.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final ValueNotifier<String?> _selectedPresenterNotifier = ValueNotifier<String?>(null);

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      PresenterPage(
        onPresenterSelected: (presenterName) {
          _selectedPresenterNotifier.value = presenterName;
          setState(() {
            _currentIndex = 2; // Switch to Presensi Tab
          });
        },
      ),
      PresensiPage(presenterNotifier: _selectedPresenterNotifier),
      const RiwayatPage(),
      const ProfilPage(),
    ];
  }

  @override
  void dispose() {
    _selectedPresenterNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.navySurface,
        selectedItemColor: AppColors.brass,
        unselectedItemColor: AppColors.charcoal,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: 'Presenter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Presensi',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
