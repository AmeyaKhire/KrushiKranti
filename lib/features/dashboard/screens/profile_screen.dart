import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      
      // --- APP BAR (UPDATED) ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true, // Centers the title nicely
        
        // ✅ 1. Added Back Button (Top Left)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        
        title: Text(
          "KrushiKranti",
          style: GoogleFonts.poppins(
            color: AppColors.brandGreen,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        
        // ✅ 2. Removed 'actions' (The three lines button is gone)
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            // --- USER HEADER ---
            _buildProfileHeader(),
            
            const SizedBox(height: 30),
            
            // --- MENU LIST ---
            _buildMenuItem(Icons.shopping_bag_outlined, "Orders", onTap: () {}),
            _buildDivider(),
            _buildMenuItem(Icons.person_outline, "My Details", onTap: () {}),
            _buildDivider(),
            _buildMenuItem(Icons.location_on_outlined, "Farm Details", onTap: () {}),
            _buildDivider(),
            _buildMenuItem(Icons.payment, "Finance", onTap: () {}),
            _buildDivider(),
            _buildMenuItem(Icons.local_offer_outlined, "Subscription", onTap: () {}),
            _buildDivider(),
            _buildMenuItem(Icons.notifications_none, "Notifications", onTap: () {}),
            _buildDivider(),
            _buildMenuItem(Icons.help_outline, "Help", onTap: () {}),
            _buildDivider(),
            _buildMenuItem(Icons.info_outline, "About", onTap: () {}),
            _buildDivider(),

            const SizedBox(height: 40),

            // --- LOGOUT BUTTON ---
            _buildLogoutButton(),
            
            const SizedBox(height: 50), 
          ],
        ),
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildProfileHeader() {
    return Row(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20), 
          ),
          child: const Icon(Icons.person, size: 40, color: Colors.grey),
        ),
        const SizedBox(width: 16),
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Rajendra Pawar",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.edit, size: 16, color: Colors.green), 
              ],
            ),
            Text(
              "jitendrapawar@gmail.com",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.black87, size: 26),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600, 
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey), // Added arrow for cleaner look
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey.shade200, height: 1, thickness: 1);
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {
        // TODO: Handle Logout
      },
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.grey.shade100, 
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.green.shade700),
            const SizedBox(width: 10),
            Text(
              "Log Out",
              style: GoogleFonts.poppins(
                color: Colors.green.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}