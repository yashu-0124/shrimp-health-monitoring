import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:aqa_shrimp_ai/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../utils/auth_manager.dart';
import '../providers/locale_provider.dart';
import 'start_page.dart';

/// Profile Page
/// Displays and allows editing of user profile information
/// Includes Sign Out functionality
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _farmNameController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedLanguage = 'English';
  final List<String> _languages = [
    'English',
    'Telugu',
    'Hindi',
    'Tamil',
    'Kannada',
  ];

  bool _isLoading = true;
  bool _isSaving = false;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _farmNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Load user profile from API
  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = await AuthManager.getToken();
      if (token == null) {
        _handleLogout();
        return;
      }

      final result = await ApiService.getUserProfile(token);

      if (!mounted) return;

      if (result['success']) {
        final user = result['user'] as UserModel;
        setState(() {
          _email = user.email;
          _fullNameController.text = user.fullName;
          _farmNameController.text = user.farmName;
          _phoneController.text = user.phone;
          _selectedLanguage = user.preferredLanguage;
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? AppLocalizations.of(context)!.failedToLoadProfile),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Save updated profile
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final token = await AuthManager.getToken();
      if (token == null) {
        _handleLogout();
        return;
      }

      final result = await ApiService.updateUserProfile(
        token: token,
        fullName: _fullNameController.text.trim(),
        farmName: _farmNameController.text.trim(),
        phone: _phoneController.text.trim(),
        preferredLanguage: _selectedLanguage,
      );

      if (!mounted) return;

      if (result['success']) {
        // Update language preference in locale provider
        final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
        final locale = localeProvider.getLocaleFromLanguageName(_selectedLanguage);
        await localeProvider.setLocale(locale);
        
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.profileUpdatedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
        // Reload profile to get latest data
        _loadUserProfile();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? AppLocalizations.of(context)!.failedToUpdateProfile),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  /// Handle logout
  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.signOutConfirmTitle),
        content: Text(AppLocalizations.of(context)!.signOutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppLocalizations.of(context)!.signOut,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Clear JWT token
      await AuthManager.clearToken();

      if (!mounted) return;

      // Navigate to Start Page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const StartPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.myProfile,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? Center(
              child: Lottie.asset(
                'assets/loading.json',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF4A90E2),
                    Color(0xFF5BA3E8),
                  ],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Profile Avatar
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Color(0xFF4A90E2),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Email (non-editable)
                      if (_email != null && _email!.isNotEmpty)
                        Text(
                          _email!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      const SizedBox(height: 32),

                      // Profile Form Card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Full Name
                              _buildLabel(AppLocalizations.of(context)!.fullName),
                              const SizedBox(height: 10),
                              _buildTextField(
                                controller: _fullNameController,
                                hintText: AppLocalizations.of(context)!.enterYourFullName,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!.pleaseEnterYourFullName;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Farm Name
                              _buildLabel(AppLocalizations.of(context)!.farmName),
                              const SizedBox(height: 10),
                              _buildTextField(
                                controller: _farmNameController,
                                hintText: AppLocalizations.of(context)!.enterYourFarmName,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!.pleaseEnterYourFarmName;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Phone
                              _buildLabel(AppLocalizations.of(context)!.phoneNumber),
                              const SizedBox(height: 10),
                              _buildTextField(
                                controller: _phoneController,
                                hintText: AppLocalizations.of(context)!.enterYourPhoneNumber,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!.pleaseEnterYourPhoneNumber;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Preferred Language
                              _buildLabel(AppLocalizations.of(context)!.preferredLanguage),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedLanguage,
                                    isExpanded: true,
                                    items: _languages.map((String language) {
                                      return DropdownMenuItem<String>(
                                        value: language,
                                        child: Text(language),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          _selectedLanguage = newValue;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Save Changes Button
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _isSaving ? null : _saveProfile,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4A90E2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _isSaving
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          AppLocalizations.of(context)!.saveChanges,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Sign Out Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: _handleLogout,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                AppLocalizations.of(context)!.signOut,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF333333),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator: validator,
    );
  }
}
