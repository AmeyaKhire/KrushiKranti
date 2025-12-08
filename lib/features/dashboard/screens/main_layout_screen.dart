import 'package:flutter/material.dart';
// ✅ Use the generated package import (Standard Flutter way)
import '../../../l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';

// --- IMPORT YOUR TABS ---
import 'home_screen.dart';
import 'profile_screen.dart';
import '../../sell/screens/sell_screen.dart'; 
import '../../orders/screens/orders_screen.dart'; // ✅ Imported Orders
// import '../../crop_management/screens/crop_list_screen.dart'; // Keep commented until Crop List is built

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;

  // --- LIST OF SCREENS ---
  // The order must match the BottomNavigationBar items below
  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text("Crops Screen Coming Soon")), // Placeholder for Crops
    const SellScreen(), 
    const OrdersScreen(), // ✅ REPLACED Placeholder with Real Screen
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      // ✅ This switches the body when you click a tab
      body: _screens[_currentIndex], 
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Needed for 4+ items
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.brandGreen,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          // 1. Home
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: l10n.home, 
          ),
          // 2. Crops
          BottomNavigationBarItem(
            icon: const Icon(Icons.grass_outlined),
            activeIcon: const Icon(Icons.grass),
            label: l10n.crops, 
          ),
          // 3. Sell (Center Highlighted)
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.brandGreen, // Make "Sell" stand out
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
            label: l10n.sell,
          ),
          // 4. Orders
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_bag_outlined),
            activeIcon: const Icon(Icons.shopping_bag),
            label: l10n.orders, 
          ),
          // 5. Profile
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: l10n.profile, 
          ),
        ],
      ),
    );
  }
}