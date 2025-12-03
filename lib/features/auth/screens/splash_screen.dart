import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_colors.dart'; // update path if needed

class SplashScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Auto redirect after 2 seconds
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, AppRoutes.languageSelection);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Heading
              const Text(
                "Welcome to\nKrushiKranti",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.brandGreen,
                ),
              ),

              const SizedBox(height: 30),

              // Logo
              Image.asset(
                'assets/images/logo/krushi_logo.png', // update to match your asset
                height: 300,
                width: 300,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 40),

              // Tagline
              const Text(
                "THE FARMER IS SELF-SUFFICIENT",
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 1,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
