import 'dart:async';
import '../models/crop_model.dart';

class CropService {
  // MOCK DATABASE (Temporary)
  static final List<CropModel> _mockCrops = [
    CropModel(
      id: '101',
      name: 'Tomato',
      category: 'Vegetable',
      acres: 2.5,
      plantingDate: DateTime.now().subtract(const Duration(days: 20)),
      imageUrl: null,
    ),
    CropModel(
      id: '102',
      name: 'Wheat',
      category: 'Grain',
      acres: 5.0,
      plantingDate: DateTime.now().subtract(const Duration(days: 45)),
      imageUrl: null,
    ),
  ];

  // 1. GET ALL CROPS
  static Future<List<CropModel>> getCrops() async {
    // Simulate network delay (1 second) so you can test loading spinners
    await Future.delayed(const Duration(seconds: 1)); 
    return _mockCrops;
  }

  // 2. ADD NEW CROP
  static Future<void> addCrop(CropModel newCrop) async {
    await Future.delayed(const Duration(seconds: 1)); // Fake network call
    _mockCrops.add(newCrop);
  }
}