import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../l10n/app_localizations.dart'; // ✅ Import Localization
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../dashboard/models/crop_model.dart';
import '../../dashboard/services/crop_service.dart';

class CropListScreen extends StatefulWidget {
  const CropListScreen({super.key});

  @override
  State<CropListScreen> createState() => _CropListScreenState();
}

class _CropListScreenState extends State<CropListScreen> {
  late Future<List<CropModel>> _cropsFuture;

  @override
  void initState() {
    super.initState();
    _loadCrops();
  }

  void _loadCrops() {
    setState(() {
      _cropsFuture = CropService.getCrops();
    });
  }

  // Helper to get display name (use displayName from API, fallback to name)
  String _getCropDisplay(CropModel crop, AppLocalizations l10n) {
    return crop.cropDisplayName ?? crop.name;
  }

  // Helper to get category display name
  String _getCategoryDisplay(CropModel crop, AppLocalizations l10n) {
    return crop.cropTypeName ?? crop.category;
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Shortcut for translations
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      
      // --- APP BAR ---
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.myCropsTitle, // ✅ Translated
          style: GoogleFonts.poppins(
            color: AppColors.brandGreen,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // --- BODY ---
      body: RefreshIndicator(
        onRefresh: () async => _loadCrops(),
        color: AppColors.brandGreen,
        child: FutureBuilder<List<CropModel>>(
          future: _cropsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: AppColors.brandGreen));
            }
            if (snapshot.hasError) {
              final errorMsg = snapshot.error.toString();
              // Check if it's a profile not found error
              if (errorMsg.contains("Farmer profile not found") || errorMsg.contains("complete your profile")) {
                return _buildProfileRequiredState(l10n);
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        "Error: ${snapshot.error}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              );
            }

            final crops = snapshot.data ?? [];
            if (crops.isEmpty) {
              return _buildEmptyState(l10n); // Pass translation
            }

            // --- LIST ---
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: crops.length,
              itemBuilder: (context, index) {
                final crop = crops[index];
                return _buildCropCard(crop, l10n); // Pass translation
              },
            );
          },
        ),
      ),
      
      // --- ADD BUTTON ---
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addCrop).then((_) {
            _loadCrops(); 
          });
        },
        backgroundColor: AppColors.brandGreen,
        label: Text(
          l10n.addCropBtn, 
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white)
        ),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // --- WIDGET: Crop Card (Localized) ---
  Widget _buildCropCard(CropModel crop, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.creamBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.grass, color: AppColors.brandGreen, size: 28),
          ),
          const SizedBox(width: 16),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getCropDisplay(crop, l10n),
                  style: GoogleFonts.poppins(
                    fontSize: 16, 
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${_getCategoryDisplay(crop, l10n)} • ${crop.acres.toStringAsFixed(2)} ${l10n.acresSuffix}",
                  style: GoogleFonts.poppins(
                    fontSize: 12, 
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.creamBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.grass, size: 64, color: AppColors.brandGreen.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noCropsAdded,
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black87)
          ),
          const SizedBox(height: 8),
          Text(
            l10n.addCropsSubtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRequiredState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.creamBackground,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_add, size: 64, color: AppColors.brandGreen),
            ),
            const SizedBox(height: 24),
            Text(
              "Profile Required",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Please complete your profile first before adding crops.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.onboardingPersonal);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Complete Profile",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}