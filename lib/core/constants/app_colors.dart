import 'package:flutter/material.dart';

class AppColors {
  // --- ACTION COLORS ---
  static const Color primary = Color(0xFF2E7D32); // Main Green (Buttons/Logo)
  static const Color accent = Color(0xFFFFD600); // Yellow/Amber highlights

  // --- BRAND COLORS ---
  static const Color brandGreen = Color(0xFF2E7D32);
  static const Color darkGreen = Color(0xFF1B5E20);

  // --- UI COLORS ---
  static const Color background =
      Color(0xFFF9FAFB); // Very light grey background

  // ✅ FIX 1: Added 'surface' (Used in main.dart theme)
  static const Color surface = Colors.white;
  static const Color cardSurface = Colors.white;

  static const Color creamBackground =
      Color(0xFFFFF8E1); // The Beige Weather Card
  static const Color pendingStatus =
      Color(0xFFFF7043); // The Red/Orange "Pending" text

  // --- TEXT ---
  static const Color textPrimary = Color(0xFF1B1B1B);
  static const Color textSecondary = Color(0xFF757575);

  // ✅ FIX 2: Added 'textOnButton' (Used in main.dart button theme)
  static const Color textOnButton =
      Colors.white; // Or Colors.black if using Yellow buttons

  // --- BORDERS & ALERTS ---
  static const Color border = Color(0xFFEEEEEE);
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
}
