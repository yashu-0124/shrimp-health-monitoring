import 'package:flutter/material.dart';
import 'package:aqa_shrimp_ai/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/gemini_size_analysis_service.dart';
import '../models/size_analysis_model.dart';
import 'package:lottie/lottie.dart';

/// Shrimp Size Calculation Page
/// Calculate shrimp size, weight, and biomass from images
class SizeCalculationPage extends StatefulWidget {
  const SizeCalculationPage({super.key});

  @override
  State<SizeCalculationPage> createState() => _SizeCalculationPageState();
}

class _SizeCalculationPageState extends State<SizeCalculationPage> {
  File? _selectedImage;
  bool _isCalculating = false;
  SizeAnalysisResult? _analysisResult;

  final ImagePicker _picker = ImagePicker();
  final GeminiSizeAnalysisService _analysisService =
      GeminiSizeAnalysisService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.shrimpSizeCalculation,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4A90E2),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF4A90E2), Color(0xFFE8F4F8)],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color(0xFF4A90E2),
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!.uploadShrimpImageForSize,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Image Preview or Upload Box
                  GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF4A90E2).withOpacity(0.3),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: _selectedImage == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.tapToUploadImage,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons
                  if (_selectedImage != null) ...[
                    ElevatedButton(
                      onPressed: _isCalculating ? null : _calculateSize,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isCalculating
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: Lottie.asset(
                                'assets/loading.json',
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Text(
                              AppLocalizations.of(context)!.calculateSize,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedImage = null;
                          _analysisResult = null;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF4A90E2)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.clearImage,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A90E2),
                        ),
                      ),
                    ),
                  ],

                  // Calculation Result
                  if (_analysisResult != null &&
                      _analysisResult!.isSuccess) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.straighten,
                                color: Color(0xFF4A90E2),
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                AppLocalizations.of(context)!.calculationResult,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildResultCard(
                            icon: Icons.straighten,
                            label: AppLocalizations.of(context)!.averageLength,
                            value:
                                '${_analysisResult!.shrimpAnalysis!.averageLength.displayValue} cm',
                            confidence: _analysisResult!
                                .shrimpAnalysis!
                                .averageLength
                                .confidencePercentage,
                            color: const Color(0xFF4A90E2),
                          ),
                          const SizedBox(height: 12),
                          _buildResultCard(
                            icon: Icons.fitness_center,
                            label: AppLocalizations.of(context)!.averageWeight,
                            value:
                                '${_analysisResult!.shrimpAnalysis!.averageWeight.displayValue} g',
                            confidence: _analysisResult!
                                .shrimpAnalysis!
                                .averageWeight
                                .confidencePercentage,
                            color: const Color(0xFF5CB85C),
                          ),
                          const SizedBox(height: 12),
                          _buildResultCard(
                            icon: Icons.speed,
                            label: AppLocalizations.of(
                              context,
                            )!.estimatedBiomass,
                            value:
                                '${_analysisResult!.shrimpAnalysis!.totalBiomass.displayValue} kg',
                            confidence: _analysisResult!
                                .shrimpAnalysis!
                                .totalBiomass
                                .confidencePercentage,
                            color: const Color(0xFFF0AD4E),
                          ),
                          const SizedBox(height: 12),
                          _buildResultCard(
                            icon: Icons.numbers,
                            label: AppLocalizations.of(context)!.shrimpCount,
                            value:
                                '${_analysisResult!.shrimpAnalysis!.shrimpCount.displayValue} pieces/kg',
                            confidence: _analysisResult!
                                .shrimpAnalysis!
                                .shrimpCount
                                .confidencePercentage,
                            color: const Color(0xFF5BC0DE),
                          ),

                          // Farmer Summary
                          if (_analysisResult!.farmerSummary != null) ...[
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F4F8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(
                                    0xFF4A90E2,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.lightbulb_outline,
                                        color: Color(0xFF4A90E2),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'AI Summary',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xFF4A90E2),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _analysisResult!
                                        .farmerSummary!
                                        .plainLanguage,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF333333),
                                      height: 1.5,
                                    ),
                                  ),
                                  if (_analysisResult!
                                      .farmerSummary!
                                      .recommendedActions
                                      .isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Recommended Actions:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Color(0xFF666666),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ...(_analysisResult!
                                        .farmerSummary!
                                        .recommendedActions
                                        .map(
                                          (action) => Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 4,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  '• ',
                                                  style: TextStyle(
                                                    color: Color(0xFF4A90E2),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    action,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF666666),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                  ],
                                ],
                              ),
                            ),
                          ],

                          // Data Quality Indicator
                          if (_analysisResult!.dataQuality != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    _analysisResult!.dataQuality!.isGoodQuality
                                    ? Colors.green.withOpacity(0.1)
                                    : _analysisResult!
                                          .dataQuality!
                                          .isModerateQuality
                                    ? Colors.orange.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _analysisResult!.dataQuality!.isGoodQuality
                                        ? Icons.check_circle
                                        : Icons.info,
                                    color:
                                        _analysisResult!
                                            .dataQuality!
                                            .isGoodQuality
                                        ? Colors.green
                                        : _analysisResult!
                                              .dataQuality!
                                              .isModerateQuality
                                        ? Colors.orange
                                        : Colors.red,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Image Quality: ${_analysisResult!.dataQuality!.imageQuality}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            _analysisResult!
                                                .dataQuality!
                                                .isGoodQuality
                                            ? Colors.green.shade700
                                            : _analysisResult!
                                                  .dataQuality!
                                                  .isModerateQuality
                                            ? Colors.orange.shade700
                                            : Colors.red.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // Disclaimer
                          if (_analysisResult!.disclaimer != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _analysisResult!.disclaimer!,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Loading Overlay
          if (_isCalculating)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/loading.json',
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.calculatingSize,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Please wait while AI analyzes the image',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    int? confidence,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (confidence != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$confidence%',
                          style: TextStyle(
                            fontSize: 10,
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF4A90E2)),
              title: Text(AppLocalizations.of(context)!.takePhoto),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Color(0xFF4A90E2),
              ),
              title: Text(AppLocalizations.of(context)!.chooseFromGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _analysisResult = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.errorPickingImage}: $e',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _calculateSize() async {
    if (_selectedImage == null) return;

    setState(() {
      _isCalculating = true;
    });

    try {
      print('🔬 Starting Gemini Vision analysis...');

      // Call Gemini Vision API
      final result = await _analysisService.analyzeShrimp(_selectedImage!);

      setState(() {
        _analysisResult = SizeAnalysisResult.fromJson(result);
        _isCalculating = false;
      });

      if (mounted) {
        if (_analysisResult!.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.calculationComplete),
              backgroundColor: Colors.green,
            ),
          );
        } else if (_analysisResult!.noShrimpDetected) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_analysisResult!.message ?? 'No shrimp detected'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Analysis error: $e');

      setState(() {
        _isCalculating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Analysis failed: ${e.toString().replaceAll('Exception: ', '')}',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }
}
