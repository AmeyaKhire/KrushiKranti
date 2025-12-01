import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
// import '../../../core/constants/app_routes.dart'; // Uncomment when you link sub-pages

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      
      // --- 1. APP BAR ---
      appBar: AppBar(
        backgroundColor: AppColors.brandGreen,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Namaste, Farmer", // Todo: Replace with User Name
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              "Pimpri-Chinchwad, Pune", // Todo: Replace with User Village
              // Fixed: Using withValues for Flutter 3.27+
              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.9)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),

      // --- 2. BODY CONTENT ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // A. Weather Widget
            _buildWeatherCard(),
            const SizedBox(height: 24),

            // B. Quick Actions Grid
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildActionGrid(context),
            
            const SizedBox(height: 24),

            // C. Recent Activity
            const Text(
              "Your Farm Status",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatusCard(
              title: "Active Loan Request",
              status: "Pending",
              date: "Applied on 28 Nov",
              color: Colors.orange.shade100,
              textColor: Colors.orange.shade800,
            ),
          ],
        ),
      ),
      
      // --- 3. FLOATING ACTION BUTTON ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.chat_bubble_outline, color: Colors.black),
      ),
    );
  }

  // --- WIDGET: Weather Card ---
  Widget _buildWeatherCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.brandGreen, 
            AppColors.brandGreen.withValues(alpha: 0.8)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      // ✅ FIXED: Added 'const' to the Row (this fixes the list error too)
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Today's Weather", style: TextStyle(color: Colors.white70)),
              SizedBox(height: 4),
              Text("28°C", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              Text("Sunny • Humidity 45%", style: TextStyle(color: Colors.white)),
            ],
          ),
          Icon(Icons.wb_sunny, size: 64, color: Colors.yellowAccent),
        ],
      ),
    );
  }

  // --- WIDGET: Action Grid ---
  Widget _buildActionGrid(BuildContext context) {
    final actions = [
      {"icon": Icons.grass, "label": "My Crops", "color": Colors.green.shade50},
      {"icon": Icons.scale, "label": "Daily Sales", "color": Colors.blue.shade50},
      {"icon": Icons.monetization_on, "label": "Request Funds", "color": Colors.amber.shade50},
      {"icon": Icons.water_drop, "label": "Irrigation", "color": Colors.cyan.shade50},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // ✅ FIXED: Added 'const' here
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        return _buildActionCard(
          icon: actions[index]["icon"] as IconData,
          label: actions[index]["label"] as String,
          color: actions[index]["color"] as Color,
          onTap: () {
            // Handle Navigation later
          },
        );
      },
    );
  }

  Widget _buildActionCard({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          // Fixed: using withValues
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: AppColors.textPrimary),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // --- WIDGET: Status Card ---
  Widget _buildStatusCard({required String title, required String status, required String date, required Color color, required Color textColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(Icons.history, color: textColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}