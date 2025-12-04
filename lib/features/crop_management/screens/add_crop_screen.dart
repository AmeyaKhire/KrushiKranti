import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart'; // ✅ Relative Import
import '../../../core/constants/app_colors.dart';
import '../../dashboard/models/crop_model.dart';
import '../../dashboard/services/crop_service.dart';

class AddCropScreen extends StatefulWidget {
  const AddCropScreen({super.key});

  @override
  State<AddCropScreen> createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {
  String? selectedCategory;
  String? selectedCrop;
  
  final TextEditingController acresController = TextEditingController();

  final Map<String, List<String>> cropData = {
    "Vegetables": ["Tomato", "Onion", "Potato", "Cauliflower", "Brinjal", "Okra"],
    "Fruits": ["Banana", "Mango", "Papaya", "Pomegranate", "Grapes"],
    "Grains": ["Wheat", "Rice", "Jowar", "Bajra"],
  };

  // ✅ HELPER 1: Translate Categories
  String _getCategoryDisplay(String key, AppLocalizations l10n) {
    switch (key) {
      case "Vegetables": return l10n.catVeg;
      case "Fruits": return l10n.catFruit;
      case "Grains": return l10n.catGrain;
      default: return key;
    }
  }

  // ✅ HELPER 2: Translate Crop Names (NEW)
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
    // ✅ Localization Shortcut
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.addNewCrop), // ✅ Translated
        backgroundColor: AppColors.brandGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.selectCategory, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), // ✅
            const SizedBox(height: 8),
            
            // 1. CATEGORY DROPDOWN
            DropdownButtonFormField<String>(
              key: ValueKey(selectedCategory ?? 'cat_reset'), 
              decoration: _inputDecoration(l10n.categoryLabel), // ✅
              initialValue: selectedCategory,
              // Map English keys to Translated Text widgets
              items: cropData.keys.map((c) => DropdownMenuItem(
                value: c, 
                child: Text(_getCategoryDisplay(c, l10n)) // ✅ Shows Hindi/Marathi Category
              )).toList(),
              onChanged: (val) => setState(() { 
                selectedCategory = val; 
                selectedCrop = null; 
              }),
            ),
            const SizedBox(height: 20),
            
            Text(l10n.selectCropName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), // ✅
            const SizedBox(height: 8),
            
            // 2. CROP NAME DROPDOWN
            DropdownButtonFormField<String>(
              key: ValueKey("${selectedCategory}_${selectedCrop ?? 'crop'}"), 
              decoration: _inputDecoration(l10n.cropNameLabel), // ✅
              initialValue: selectedCrop,
              items: selectedCategory == null 
                  ? [] 
                  : cropData[selectedCategory]!.map((c) => DropdownMenuItem(
                      value: c, 
                      child: Text(_getCropDisplay(c, l10n)) // ✅ Shows Hindi/Marathi Crop Name
                    )).toList(),
              onChanged: selectedCategory == null ? null : (val) => setState(() => selectedCrop = val),
            ),
            const SizedBox(height: 20),

            // 3. ACRES INPUT
            Text(l10n.landArea, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), // ✅
            const SizedBox(height: 8),
            TextFormField(
              controller: acresController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(l10n.acresHint).copyWith(suffixText: l10n.acresSuffix), // ✅
            ),
            
            const SizedBox(height: 40),
            
            // 4. SAVE BUTTON
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () => _saveCrop(l10n), // Pass translations to function
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(l10n.saveCropBtn, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // ✅
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }

  void _saveCrop(AppLocalizations l10n) async {
    if (selectedCategory == null || selectedCrop == null || acresController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.fillAllFields), // ✅ Translated Error
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newCrop = CropModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: selectedCrop!, // We save English Key to DB
      category: selectedCategory!, // We save English Key to DB
      acres: double.tryParse(acresController.text) ?? 0.0,
      plantingDate: DateTime.now(),
    );

    await CropService.addCrop(newCrop);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.cropAddedSuccess), // ✅ Translated Success
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }
}