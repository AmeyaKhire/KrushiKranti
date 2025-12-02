import 'dart:async';
import '../models/crop_model.dart';

class CropService {
  // ✅ FIX: Start with an EMPTY list so the Green Banner shows first
  static final List<CropModel> _mockCrops = []; 

  /* // (Previous code had data here - we removed it)
  [
    CropModel(id: '101', name: 'Tomato', ...),
    CropModel(id: '102', name: 'Wheat', ...),
  ];
  */

  // 1. GET ALL CROPS
  static Future<List<CropModel>> getCrops() async {
    await Future.delayed(const Duration(milliseconds: 500)); 
    return _mockCrops;
  }

  // 2. ADD NEW CROP
  static Future<void> addCrop(CropModel newCrop) async {
    await Future.delayed(const Duration(milliseconds: 500)); 
    _mockCrops.add(newCrop);
  }
}