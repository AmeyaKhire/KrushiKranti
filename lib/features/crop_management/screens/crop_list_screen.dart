import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  // ✅ FIXED: Removed print() statement for production code
  void _loadCrops() {
    setState(() {
      _cropsFuture = CropService.getCrops();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      
      // --- APP BAR ---
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "My Crops",
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
        onRefresh: () async => _loadCrops(), // Pull down to refresh
        color: AppColors.brandGreen,
        child: FutureBuilder<List<CropModel>>(
          future: _cropsFuture,
          builder: (context, snapshot) {
            // 1. Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: AppColors.brandGreen));
            }

            // 2. Error
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            // 3. Empty State
            final crops = snapshot.data ?? [];
            if (crops.isEmpty) {
              return _buildEmptyState();
            }

            // 4. Success List
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: crops.length,
              itemBuilder: (context, index) {
                final crop = crops[index];
                return _buildCropCard(crop);
              },
            );
          },
        ),
      ),
      
      // --- ADD BUTTON ---
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Wait for result, then refresh!
          Navigator.pushNamed(context, AppRoutes.addCrop).then((_) {
            _loadCrops(); // Refresh list when coming back
          });
        },
        backgroundColor: AppColors.brandGreen,
        label: Text(
          "Add Crop", 
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white)
        ),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // --- WIDGET: Crop Card (Styled) ---
  Widget _buildCropCard(CropModel crop) {
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
                  crop.name,
                  style: GoogleFonts.poppins(
                    fontSize: 16, 
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${crop.category} • ${crop.acres} Acres",
                  style: GoogleFonts.poppins(
                    fontSize: 12, 
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          // Edit/Arrow
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  // --- WIDGET: Empty State ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            // ✅ FIXED: Added 'const' here for performance
            decoration: const BoxDecoration(
              color: AppColors.creamBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.grass, size: 64, color: AppColors.brandGreen.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 24),
          Text(
            "No crops added yet", 
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black87)
          ),
          const SizedBox(height: 8),
          Text(
            "Add your vegetables or fruits\nto start selling.", 
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}