import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:aqa_shrimp_ai/l10n/app_localizations.dart';
import 'start_page.dart';

/// Full-screen intro splash page that plays a video and navigates to StartPage
class SplashIntroPage extends StatefulWidget {
  const SplashIntroPage({super.key});

  @override
  State<SplashIntroPage> createState() => _SplashIntroPageState();
}

class _SplashIntroPageState extends State<SplashIntroPage> {
  VideoPlayerController? _controller;
  bool _isVideoInitialized = false;
  bool _hasError = false;
  double _opacity = 1.0; // For fade-out transition

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _hideSystemUI(); // Immersive fullscreen mode
  }

  /// Hide system UI (status bar, navigation bar) for immersive experience
  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersive,
      overlays: [],
    );
  }

  /// Restore system UI when leaving this page
  void _restoreSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );
  }

  /// Initialize and play the intro video
  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.asset('assets/aqashrimpvideo-intro.mp4');
      
      await _controller!.initialize();
      
      setState(() {
        _isVideoInitialized = true;
      });

      // Start playing the video with audio
      await _controller!.setVolume(1.0);
      await _controller!.play();

      // Listen for video completion
      _controller!.addListener(_videoListener);
    } catch (e) {
      // If video fails to load, show fallback
      setState(() {
        _hasError = true;
      });
      _navigateAfterDelay(const Duration(seconds: 1));
    }
  }

  /// Monitor video playback and navigate when complete
  void _videoListener() {
    if (_controller != null && 
        _controller!.value.position >= _controller!.value.duration) {
      _controller!.removeListener(_videoListener);
      _fadeOutAndNavigate();
    }
  }

  /// Perform smooth fade-out transition before navigating
  Future<void> _fadeOutAndNavigate() async {
    setState(() {
      _opacity = 0.0;
    });
    
    // Wait for fade animation to complete
    await Future.delayed(const Duration(milliseconds: 600));
    
    if (mounted) {
      _navigateToStartPage();
    }
  }

  /// Navigate to StartPage after a delay (used for fallback)
  void _navigateAfterDelay(Duration delay) async {
    await Future.delayed(delay);
    if (mounted) {
      _navigateToStartPage();
    }
  }

  /// Navigate to StartPage and remove splash from back stack
  void _navigateToStartPage() {
    _restoreSystemUI();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const StartPage()),
    );
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    _restoreSystemUI();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 600),
        child: _buildContent(),
      ),
    );
  }

  /// Build content based on video state (playing, error, or loading)
  Widget _buildContent() {
    if (_hasError) {
      // Fallback: Show logo and app name
      return _buildFallbackView();
    }

    if (_isVideoInitialized && _controller != null) {
      // Show video player
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller!.value.size.width,
            height: _controller!.value.size.height,
            child: VideoPlayer(_controller!),
          ),
        ),
      );
    }

    // Loading state
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }

  /// Fallback view when video fails to load
  Widget _buildFallbackView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App logo
          Image.asset(
            'assets/aqa_shrimp.png',
            width: 200,
            height: 200,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.image_not_supported,
                size: 100,
                color: Colors.white54,
              );
            },
          ),
          const SizedBox(height: 24),
          // App name
          Text(
            AppLocalizations.of(context)!.appName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
