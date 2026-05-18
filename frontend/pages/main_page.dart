import 'package:flutter/material.dart';
import 'package:aqa_shrimp_ai/l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'disease_page.dart';
import 'size_calculation_page.dart';
import 'feed_calculator_page.dart';
import 'shrimp_chatbot_page.dart';
import '../widgets/disease_info_section.dart';
import '../widgets/market_prices_section.dart';
import '../widgets/weather_section.dart';

/// Main Dashboard Page
/// Production-ready landing page after successful authentication
/// Features: Disease AI, Size Calculation, Feed Calculator, Market Prices, Weather, and Disease Info
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ShrimpChatbotPage(),
            ),
          );
        },
        backgroundColor: Colors.white,
        child: Lottie.asset(
          'assets/chatbot.json',
          width: 32,
          height: 32,
          fit: BoxFit.contain,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A90E2),
              Color(0xFFE8F4F8),
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome Header
                _buildWelcomeHeader(),
                
                // Main Feature Cards Grid
                _buildFeatureCardsSection(),
                
                const SizedBox(height: 24),
                
                // Weather Section
                const WeatherSection(),
                
                const SizedBox(height: 24),
                
                // Market Prices Section
                const MarketPricesSection(),
                
                const SizedBox(height: 24),
                
                // Disease Information Section
                const DiseaseInfoSection(),
                
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// App Bar with title and action icons
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                'assets/aqa_shrimp.png',
                width: 20,
                height: 20,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'AQA SHRIMP AI',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF4A90E2),
      elevation: 0,
      actions: [
        // Account Icon
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_circle,
              size: 24,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
          tooltip: AppLocalizations.of(context)!.account,
        ),
        // Settings Icon
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.settings,
              size: 24,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
          tooltip: AppLocalizations.of(context)!.settings,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Welcome header section
  Widget _buildWelcomeHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.welcomeTo,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!.dashboard,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Main feature cards grid section
  Widget _buildFeatureCardsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Disease Detection Card (Full Width)
          _buildFeatureCard(
            lottieAsset: 'assets/search.json',
            title: AppLocalizations.of(context)!.shrimpDiseaseAI,
            description: AppLocalizations.of(context)!.shrimpDiseaseDesc,
            color: const Color(0xFFE74C3C),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DiseasePage()),
              );
            },
          ),
          const SizedBox(height: 12),

          // Size Calculation & Feed Calculator Row
          Row(
            children: [
              Expanded(
                child: _buildCompactFeatureCard(
                  lottieAsset: 'assets/scale.json',
                  title: AppLocalizations.of(context)!.sizeCalculation,
                  color: const Color(0xFF5CB85C),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SizeCalculationPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCompactFeatureCard(
                  lottieAsset: 'assets/calculating.json',
                  title: AppLocalizations.of(context)!.feedCalculator,
                  color: const Color(0xFFF0AD4E),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FeedCalculatorPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Feature card widget for main features
  Widget _buildFeatureCard({
    required String lottieAsset,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Lottie.asset(
                    lottieAsset,
                    width: 36,
                    height: 36,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 16),
                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF666666),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Arrow Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Compact feature card for smaller grid items
  Widget _buildCompactFeatureCard({
    required String lottieAsset,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Lottie.asset(
                    lottieAsset,
                    width: 32,
                    height: 32,
                    fit: BoxFit.contain,
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: color,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Refresh data method for pull-to-refresh
  Future<void> _refreshData() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));
    
    // TODO: Add actual data refresh logic here
    // - Reload weather data
    // - Reload market prices
    // - Reload user profile info
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.dataRefreshed),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFF4A90E2),
        ),
      );
    }
  }
}
