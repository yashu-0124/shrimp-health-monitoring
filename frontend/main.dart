import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:aqa_shrimp_ai/l10n/app_localizations.dart';
import 'pages/splash_intro_page.dart';
import 'pages/main_page.dart';
import 'utils/auth_manager.dart';
import 'providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localeProvider = LocaleProvider();
  await localeProvider.loadSavedLocale();
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => localeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          title: 'AQA SHRIMP AI',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: LocaleProvider.supportedLocales,
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale == null) {
              return supportedLocales.first;
            }
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          home: const AuthCheck(),
        );
      },
    );
  }
}

/// Auth Check Widget
/// Checks if user is already logged in
/// If YES -> Navigate to Main Page
/// If NO -> Show Splash/Intro Page
class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  /// Check authentication status
  Future<void> _checkAuthStatus() async {
    // Small delay to show splash screen briefly
    await Future.delayed(const Duration(milliseconds: 500));

    final isLoggedIn = await AuthManager.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      // User is logged in, go to Main Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } else {
      // User not logged in, show Splash/Intro
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashIntroPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while checking auth
    return Scaffold(
      body: Container(
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
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
