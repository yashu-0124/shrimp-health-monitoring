import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:aqa_shrimp_ai/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../utils/auth_manager.dart';
import '../providers/locale_provider.dart';
import 'loading_screen.dart';
import 'login_page.dart';

/// Signup Page
/// Enhanced professional UI with modern design and animations
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _farmNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedLanguage = 'English';
  final List<String> _languages = [
    'English',
    'Telugu',
    'Hindi',
    'Tamil',
    'Kannada',
  ];

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Background animation controllers
  late AnimationController _bubbleController1;
  late AnimationController _bubbleController2;
  late AnimationController _bubbleController3;
  late AnimationController _bubbleController4;
  late Animation<Offset> _bubble1Animation;
  late Animation<Offset> _bubble2Animation;
  late Animation<Offset> _bubble3Animation;
  late Animation<Offset> _bubble4Animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    
    _animationController.forward();
    
    // Initialize bubble animations
    _bubbleController1 = AnimationController(
      duration: const Duration(seconds: 9),
      vsync: this,
    )..repeat(reverse: true);
    
    _bubbleController2 = AnimationController(
      duration: const Duration(seconds: 11),
      vsync: this,
    )..repeat(reverse: true);
    
    _bubbleController3 = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    )..repeat(reverse: true);
    
    _bubbleController4 = AnimationController(
      duration: const Duration(seconds: 13),
      vsync: this,
    )..repeat(reverse: true);
    
    _bubble1Animation = Tween<Offset>(
      begin: const Offset(-0.2, 0.7),
      end: const Offset(0.4, -0.1),
    ).animate(CurvedAnimation(parent: _bubbleController1, curve: Curves.easeInOut));
    
    _bubble2Animation = Tween<Offset>(
      begin: const Offset(0.5, 0.9),
      end: const Offset(-0.3, 0.2),
    ).animate(CurvedAnimation(parent: _bubbleController2, curve: Curves.easeInOut));
    
    _bubble3Animation = Tween<Offset>(
      begin: const Offset(0.7, 0.4),
      end: const Offset(-0.1, 0.6),
    ).animate(CurvedAnimation(parent: _bubbleController3, curve: Curves.easeInOut));
    
    _bubble4Animation = Tween<Offset>(
      begin: const Offset(-0.4, 0.3),
      end: const Offset(0.6, 0.8),
    ).animate(CurvedAnimation(parent: _bubbleController4, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bubbleController1.dispose();
    _bubbleController2.dispose();
    _bubbleController3.dispose();
    _bubbleController4.dispose();
    _fullNameController.dispose();
    _farmNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Handle signup button press
  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Password confirmation check
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.passwordsDoNotMatch),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.signup(
        fullName: _fullNameController.text.trim(),
        farmName: _farmNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        preferredLanguage: _selectedLanguage,
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (result['success']) {
        // Save JWT token
        await AuthManager.saveToken(result['token']);
        
        // Save selected language to locale provider
        final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
        final locale = localeProvider.getLocaleFromLanguageName(_selectedLanguage);
        await localeProvider.setLocale(locale);

        // Navigate to Loading Screen with animation
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoadingScreen()),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? AppLocalizations.of(context)!.signupFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2E5CB8),
              Color(0xFF4A90E2),
              Color(0xFF5BA3E8),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background bubbles
            _buildAnimatedBubble(_bubble1Animation, 180, 180, Colors.white.withOpacity(0.04)),
            _buildAnimatedBubble(_bubble2Animation, 220, 220, Colors.white.withOpacity(0.03)),
            _buildAnimatedBubble(_bubble3Animation, 150, 150, Colors.white.withOpacity(0.05)),
            _buildAnimatedBubble(_bubble4Animation, 200, 200, Colors.white.withOpacity(0.035)),
            
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Enhanced Header with back button
                  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, 
                          color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      AppLocalizations.of(context)!.back,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          const SizedBox(height: 8),

                          // Title with icon
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person_add_rounded,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(context)!.joinAQAShrimpAI,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Signup Form Card - Enhanced
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 40,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 20),
                                ),
                                BoxShadow(
                                  color: const Color(0xFF4A90E2).withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: -5,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(28),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Full Name
                                  _buildLabel(AppLocalizations.of(context)!.fullName, Icons.person_rounded),
                                  const SizedBox(height: 10),
                                  _buildEnhancedTextField(
                                    controller: _fullNameController,
                                    hintText: AppLocalizations.of(context)!.enterYourFullName,
                                    prefixIcon: Icons.person_outline_rounded,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppLocalizations.of(context)!.pleaseEnterYourFullName;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 18),

                                  // Farm Name / Pond ID
                                  _buildLabel(AppLocalizations.of(context)!.farmNamePondID, Icons.agriculture_rounded),
                                  const SizedBox(height: 10),
                                  _buildEnhancedTextField(
                                    controller: _farmNameController,
                                    hintText: AppLocalizations.of(context)!.enterFarmOrPondName,
                                    prefixIcon: Icons.business_outlined,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppLocalizations.of(context)!.pleaseEnterFarmNameOrPondID;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 18),

                                  // Email Address
                                  _buildLabel(AppLocalizations.of(context)!.emailAddress, Icons.email_rounded),
                                  const SizedBox(height: 10),
                                  _buildEnhancedTextField(
                                    controller: _emailController,
                                    hintText: AppLocalizations.of(context)!.enterYourEmail,
                                    prefixIcon: Icons.alternate_email_rounded,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppLocalizations.of(context)!.pleaseEnterYourEmail;
                                      }
                                      if (!value.contains('@') || !value.contains('.')) {
                                        return AppLocalizations.of(context)!.pleaseEnterValidEmail;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 18),

                                  // Phone Number
                                  _buildLabel(AppLocalizations.of(context)!.phoneNumber, Icons.phone_rounded),
                                  const SizedBox(height: 10),
                                  _buildEnhancedTextField(
                                    controller: _phoneController,
                                    hintText: AppLocalizations.of(context)!.enterYourPhoneNumber,
                                    prefixIcon: Icons.phone_outlined,
                                    keyboardType: TextInputType.phone,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppLocalizations.of(context)!.pleaseEnterYourPhoneNumber;
                                      }
                                      if (value.length < 10) {
                                        return AppLocalizations.of(context)!.pleaseEnterValidPhoneNumber;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 18),

                                  // Preferred Language
                                  _buildLabel(AppLocalizations.of(context)!.preferredLanguage, Icons.language_rounded),
                                  const SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF7FAFC),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: Colors.grey.withOpacity(0.1)),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 18),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedLanguage,
                                        isExpanded: true,
                                        icon: const Icon(Icons.keyboard_arrow_down_rounded, 
                                          color: Color(0xFF4A90E2)),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF2D3748),
                                        ),
                                        items: _languages.map((String language) {
                                          return DropdownMenuItem<String>(
                                            value: language,
                                            child: Row(
                                              children: [
                                                const Icon(Icons.translate_rounded, 
                                                  size: 20, color: Color(0xFF4A90E2)),
                                                const SizedBox(width: 12),
                                                Text(language),
                                              ],
                                            ),
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
                                  const SizedBox(height: 18),

                                  // Password
                                  _buildLabel(AppLocalizations.of(context)!.password, Icons.lock_rounded),
                                  const SizedBox(height: 10),
                                  _buildEnhancedTextField(
                                    controller: _passwordController,
                                    hintText: AppLocalizations.of(context)!.createStrongPassword,
                                    prefixIcon: Icons.lock_outline_rounded,
                                    obscureText: _obscurePassword,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_rounded
                                            : Icons.visibility_rounded,
                                        color: const Color(0xFF4A90E2),
                                        size: 22,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppLocalizations.of(context)!.pleaseEnterPassword;
                                      }
                                      if (value.length < 6) {
                                        return AppLocalizations.of(context)!.passwordMinLength;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 18),

                                  // Confirm Password
                                  _buildLabel(AppLocalizations.of(context)!.confirmPassword, Icons.lock_clock_rounded),
                                  const SizedBox(height: 10),
                                  _buildEnhancedTextField(
                                    controller: _confirmPasswordController,
                                    hintText: AppLocalizations.of(context)!.reEnterYourPassword,
                                    prefixIcon: Icons.lock_outline_rounded,
                                    obscureText: _obscureConfirmPassword,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword
                                            ? Icons.visibility_off_rounded
                                            : Icons.visibility_rounded,
                                        color: const Color(0xFF4A90E2),
                                        size: 22,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword =
                                              !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppLocalizations.of(context)!.pleaseConfirmYourPassword;
                                      }
                                      if (value != _passwordController.text) {
                                        return AppLocalizations.of(context)!.passwordsDoNotMatch;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 28),

                                  // Create Account Button - Enhanced
                                  Container(
                                    width: double.infinity,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF4A90E2), Color(0xFF2E5CB8)],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF4A90E2).withOpacity(0.5),
                                          blurRadius: 20,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 10),
                                        ),
                                        BoxShadow(
                                          color: const Color(0xFF2E5CB8).withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : _handleSignup,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
                                      child: _isLoading
                                          ? SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: Lottie.asset(
                                                'assets/loading.json',
                                                fit: BoxFit.contain,
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!.createAccount,
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    letterSpacing: 0.8,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Icon(Icons.arrow_forward_rounded, size: 20),
                                              ],
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Already have account - Enhanced
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.alreadyHaveAccount,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LoginPage()),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.logIn,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Terms & Privacy
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              AppLocalizations.of(context)!.termsAndPrivacySignup,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.85),
                                height: 1.5,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build enhanced labels
  Widget _buildLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF4A90E2)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3748),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  // Helper method to build enhanced text fields
  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Color(0xFF2D3748),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey.withOpacity(0.5),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: const Color(0xFF4A90E2),
          size: 22,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF7FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        errorStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      validator: validator,
    );
  }
  
  /// Build animated bubble for background
  Widget _buildAnimatedBubble(Animation<Offset> animation, double width, double height, Color color) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Positioned(
          left: MediaQuery.of(context).size.width * animation.value.dx,
          top: MediaQuery.of(context).size.height * animation.value.dy,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.08),
                  blurRadius: 40,
                  spreadRadius: 15,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
