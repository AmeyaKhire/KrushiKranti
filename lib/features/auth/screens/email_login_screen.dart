import 'package:flutter/material.dart';
// ✅ 1. Import Localization
import '../../../l10n/app_localizations.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/services/storage_service.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    // ✅ Access localization for logic (SnackBar)
    final l10n = AppLocalizations.of(context)!;

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        // ✅ Replaced hardcoded error with "Please fill all fields" key
        SnackBar(content: Text(l10n.fillAllFields)), 
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API Call
    await Future.delayed(const Duration(seconds: 1));

    // Save Dummy Token
    await StorageService.saveToken("email_login_token_123");

    // Also save email for profile display
    await StorageService.saveAuthDetails(
      email: _emailController.text.trim(),
      phone: "", 
    );

    setState(() => _isLoading = false);

    if (!mounted) return;
    
    // Navigate to Dashboard
    Navigator.pushNamedAndRemoveUntil(
      context, 
      AppRoutes.dashboard, 
      (route) => false
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 2. Initialize Localization Helper
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 20),

                // ✅ 3. Localized Header
                Text(
                  l10n.welcomeBack, // "Welcome Back!"
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                Text(
                  l10n.emailLoginTitle, // "Log in with Email"
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.brandGreen),
                ),

                const SizedBox(height: 40),

                // Email Field
                _inputField(
                  controller: _emailController,
                  hint: l10n.emailHint, // ✅ "Enter Email Address"
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 20),

                // Password Field
                _inputField(
                  controller: _passwordController,
                  hint: l10n.passwordHint, // ✅ "Enter Password"
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),

                // ✅ NEW: FORGOT PASSWORD LINK ADDED HERE
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // ✅ UPDATED: Navigate to Forgot Password Phone Screen
                      Navigator.pushNamed(context, AppRoutes.forgotPasswordPhone);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // Remove default padding to align perfectly
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      l10n.forgotPassword, // Uses the localization key
                      style: const TextStyle(
                        color: AppColors.brandGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30), // Adjusted spacing

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black, // Ensure text is visible on primary color
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.black)
                      : Text(
                          l10n.loginBtn, // ✅ "Log In"
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.brandGreen, width: 1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.brandGreen),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                hintText: hint, // This hint is now localized when passed from build()
                border: InputBorder.none,
                hintStyle: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}