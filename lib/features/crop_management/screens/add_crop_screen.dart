import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Add New Crop"),
        backgroundColor: AppColors.brandGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Select Category", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            
            // 1. CATEGORY DROPDOWN
            DropdownButtonFormField<String>(
              // ✅ FIX: Use 'key' to force rebuild if value changes programmatically
              key: ValueKey(selectedCategory ?? 'cat_reset'), 
              decoration: _inputDecoration("Category (Veg/Fruit/Grain)"),
              // ✅ FIX: Replaced 'value' with 'initialValue'
              initialValue: selectedCategory,
              items: cropData.keys.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() { 
                selectedCategory = val; 
                selectedCrop = null; // Reset crop
              }),
            ),
            const SizedBox(height: 20),
            
            const Text("Select Crop Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            
            // 2. CROP NAME DROPDOWN
            DropdownButtonFormField<String>(
              // ✅ FIX: Key includes Category to force reset when Category changes
              key: ValueKey("${selectedCategory}_${selectedCrop ?? 'crop'}"), 
              decoration: _inputDecoration("Crop Name"),
              // ✅ FIX: Replaced 'value' with 'initialValue'
              initialValue: selectedCrop,
              items: selectedCategory == null 
                  ? [] 
                  : cropData[selectedCategory]!.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: selectedCategory == null ? null : (val) => setState(() => selectedCrop = val),
            ),
            const SizedBox(height: 20),

            // 3. ACRES INPUT
            const Text("Land Area", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextFormField(
              controller: acresController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration("How many acres?").copyWith(suffixText: "Acres"),
            ),
            
            const SizedBox(height: 40),
            
            // 4. SAVE BUTTON
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _saveCrop,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Save Crop Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  void _saveCrop() async {
    if (selectedCategory == null || selectedCrop == null || acresController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Please select Category, Crop Name, and Enter Acres!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newCrop = CropModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: selectedCrop!,
      category: selectedCategory!,
      acres: double.tryParse(acresController.text) ?? 0.0,
      plantingDate: DateTime.now(),
    );

    await CropService.addCrop(newCrop);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Crop Added Successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }
}