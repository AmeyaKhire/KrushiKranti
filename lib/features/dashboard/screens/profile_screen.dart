import 'dart:io'; // ✅ REQUIRED for FileImage
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/services/storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Loading...";
  String userEmail = "";
  String userPhone = "";
  String userPicPath = ""; // ✅ Variable to hold image path

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await StorageService.getUserDetails();
      
      if (mounted) {
        setState(() {
          // Combine Name
          String first = userData['firstName'] ?? "";
          String last = userData['lastName'] ?? "";
          
          if (first.isEmpty && last.isEmpty) {
            userName = "Guest Farmer";
          } else {
            userName = "$first $last"; 
          }

          userEmail = userData['email'] ?? "";
          userPhone = userData['phone'] ?? "";
          userPicPath = userData['pic'] ?? ""; // ✅ Fetch Image Path
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          userName = "Guest Farmer";
          userEmail = "No Email";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white, 
      
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.krushiKranti, 
          style: GoogleFonts.poppins(
            color: AppColors.brandGreen,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 30),
            
            _buildMenuItem(Icons.shopping_bag_outlined, l10n.orders, onTap: () {}),
            _buildDivider(),
            _buildMenuItem(Icons.person_outline, l10n.myDetails, onTap: () {}),
            _buildDivider(),
            _buildMenuItem(Icons.location_on_outlined, l10n.farmDetails, onTap: () {}),
            _buildDivider(),
            _buildMenuItem(Icons.payment, l10n.finance, onTap: () {}),
            _buildDivider(),
            _buildMenuItem(Icons.local_offer_outlined, l10n.subscription, onTap: () {}),
            _buildDivider(),
            _buildMenuItem(Icons.notifications_none, l10n.notifications, onTap: () {}),
            _buildDivider(),
            _buildMenuItem(Icons.help_outline, l10n.help, onTap: () {}),
            _buildDivider(),
            _buildMenuItem(Icons.info_outline, l10n.about, onTap: () {}),
            _buildDivider(),

            const SizedBox(height: 40),
            _buildLogoutButton(context, l10n),
            const SizedBox(height: 50), 
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    // ✅ LOGIC: Check if file exists on phone
    bool hasImage = userPicPath.isNotEmpty && File(userPicPath).existsSync();

    return Row(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
            // ✅ DISPLAY IMAGE IF AVAILABLE
            image: hasImage 
              ? DecorationImage(
                  image: FileImage(File(userPicPath)),
                  fit: BoxFit.cover,
                )
              : null,
          ),
          // Show Icon if no image
          child: !hasImage 
              ? const Icon(Icons.person, size: 40, color: Colors.grey) 
              : null,
        ),
        const SizedBox(width: 16),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      userName, 
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.edit, size: 16, color: Colors.green), 
                ],
              ),
              if (userEmail.isNotEmpty)
                Text(
                  userEmail, 
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              if (userPhone.isNotEmpty)
                Text(
                  userPhone, 
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
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
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey.shade200, height: 1, thickness: 1);
  }

  Widget _buildLogoutButton(BuildContext context, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () async {
        await StorageService.clearSession();
        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context, 
          AppRoutes.splash, 
          (route) => false,
        );
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
              l10n.logout,
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