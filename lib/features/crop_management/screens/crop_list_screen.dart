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

  // ✅ HELPER 1: Translate Category (Vegetables -> भाजीपाला)
  String _getCategoryDisplay(String key, AppLocalizations l10n) {
    switch (key) {
      case "Vegetables": return l10n.catVeg;
      case "Fruits": return l10n.catFruit;
      case "Grains": return l10n.catGrain;
      default: return key;
    }
  }

  // ✅ HELPER 2: Translate Crop Name (Tomato -> टोमॅटो)
  String _getCropDisplay(String key, AppLocalizations l10n) {
    switch (key) {
      case "Tomato": return l10n.cropTomato;
      case "Onion": return l10n.cropOnion;
      case "Potato": return l10n.cropPotato;
      case "Cauliflower": return l10n.cropCauliflower;
      case "Brinjal": return l10n.cropBrinjal;
      case "Okra": return l10n.cropOkra;
      case "Banana": return l10n.cropBanana;
      case "Mango": return l10n.cropMango;
      case "Papaya": return l10n.cropPapaya;
      case "Pomegranate": return l10n.cropPomegranate;
      case "Grapes": return l10n.cropGrapes;
      case "Wheat": return l10n.cropWheat;
      case "Rice": return l10n.cropRice;
      case "Jowar": return l10n.cropJowar;
      case "Bajra": return l10n.cropBajra;
      default: return key;
    }
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
              return Center(child: Text("Error: ${snapshot.error}"));
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
                  _getCropDisplay(crop.name, l10n), // ✅ Translated Name (e.g. टोमॅटो)
                  style: GoogleFonts.poppins(
                    fontSize: 16, 
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  // ✅ Translated Category + Acres
                  "${_getCategoryDisplay(crop.category, l10n)} • ${crop.acres} ${l10n.acresSuffix}",
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
}