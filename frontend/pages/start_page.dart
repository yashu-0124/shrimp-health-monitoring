import 'package:flutter/material.dart';
import 'package:aqa_shrimp_ai/l10n/app_localizations.dart';
import 'signup_page.dart';
import 'login_page.dart';

/// Main start page of the app - shown after the intro splash
class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A4CA3), // Deep aquaculture blue
              Color(0xFF4EB5F1), // Light ocean blue
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating circular bubbles
            _buildFloatingBubbles(screenWidth, screenHeight),
            
            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          
                          // Logo with glowing ring
                          _buildLogoWithGlow(),
                          
                          const SizedBox(height: 48),
                          
                          // Title
                          const Text(
                            'AQA ShrimpAI',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Subtitle
                          Text(
                            'Shrimp Health & Productivity\nIntelligence',
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                              height: 1.5,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          
                          const SizedBox(height: 60),
                          
                          // Signup button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to signup page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF0A4CA3),
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                shadowColor: Colors.black26,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.signup,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: OutlinedButton(
                              onPressed: () {
                                // Navigate to login page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.login,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Bottom tagline
                          Text(
                            AppLocalizations.of(context)!.experienceMedicalGrade,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.6),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build logo with glowing circular ring effect
  Widget _buildLogoWithGlow() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glowing ring
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF4EB5F1).withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4EB5F1).withOpacity(0.5),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
        // Middle ring
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF4EB5F1).withOpacity(0.4),
              width: 2,
            ),
          ),
        ),
        // Inner circle with logo
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4EB5F1).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              'assets/aqa shrimp.png',
              width: 70,
              height: 70,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.waves,
                  size: 50,
                  color: Colors.white,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Build floating circular bubbles
  Widget _buildFloatingBubbles(double screenWidth, double screenHeight) {
    return Stack(
      children: [
        // Bubble 1
        Positioned(
          top: screenHeight * 0.15,
          left: screenWidth * 0.1,
          child: _buildBubble(60),
        ),
        // Bubble 2
        Positioned(
          top: screenHeight * 0.25,
          right: screenWidth * 0.15,
          child: _buildBubble(80),
        ),
        // Bubble 3
        Positioned(
          top: screenHeight * 0.45,
          left: screenWidth * 0.08,
          child: _buildBubble(50),
        ),
        // Bubble 4
        Positioned(
          bottom: screenHeight * 0.2,
          right: screenWidth * 0.1,
          child: _buildBubble(70),
        ),
        // Bubble 5
        Positioned(
          bottom: screenHeight * 0.35,
          left: screenWidth * 0.2,
          child: _buildBubble(40),
        ),
        // Bubble 6
        Positioned(
          top: screenHeight * 0.6,
          right: screenWidth * 0.25,
          child: _buildBubble(55),
        ),
      ],
    );
  }

  /// Build individual bubble
  Widget _buildBubble(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.05),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
    );
  }
}
