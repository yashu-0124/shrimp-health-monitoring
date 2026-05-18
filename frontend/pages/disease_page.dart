import 'package:flutter/material.dart';
import 'package:aqa_shrimp_ai/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:aqa_shrimp_ai/services/gemini_disease_detection_service.dart';
import 'package:aqa_shrimp_ai/models/disease_analysis_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart';

/// Shrimp Disease Detection Page
/// AI-powered disease detection from shrimp images using Gemini Vision
class DiseasePage extends StatefulWidget {
  const DiseasePage({super.key});

  @override
  State<DiseasePage> createState() => _DiseasePageState();
}

class _DiseasePageState extends State<DiseasePage> {
  File? _selectedImage;
  bool _isAnalyzing = false;
  DiseaseAnalysisResult? _analysisResult;

  final ImagePicker _picker = ImagePicker();
  final GeminiDiseaseDetectionService _diseaseService =
      GeminiDiseaseDetectionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.shrimpDiseaseAI,
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
                            AppLocalizations.of(context)!.uploadShrimpImage,
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
                      onPressed: _isAnalyzing ? null : _analyzeImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isAnalyzing
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
                              AppLocalizations.of(context)!.analyzeDisease,
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

                  // Analysis Result
                  if (_analysisResult != null) ...[
                    const SizedBox(height: 20),

                    // Disease Info Card
                    if (_analysisResult!.diseaseInfo != null) ...[
                      _buildDiseaseInfoCard(_analysisResult!.diseaseInfo!),
                      const SizedBox(height: 16),
                    ],

                    // Confidence Breakdown with Pie Chart
                    if (_analysisResult!.confidenceBreakdown != null) ...[
                      _buildConfidenceCard(
                        _analysisResult!.confidenceBreakdown!,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Visual Diagnostics
                    if (_analysisResult!.visualDiagnostics != null) ...[
                      _buildVisualDiagnosticsCard(
                        _analysisResult!.visualDiagnostics!,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Treatment Plan
                    if (_analysisResult!.treatmentPlan != null) ...[
                      _buildTreatmentPlanCard(_analysisResult!.treatmentPlan!),
                      const SizedBox(height: 16),
                    ],

                    // Product Recommendations
                    if (_analysisResult!.productRecommendations != null) ...[
                      _buildProductRecommendationsCard(
                        _analysisResult!.productRecommendations!,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Farmer Guidance
                    if (_analysisResult!.farmerGuidance != null) ...[
                      _buildFarmerGuidanceCard(
                        _analysisResult!.farmerGuidance!,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Disclaimer
                    _buildDisclaimerCard(_analysisResult!.disclaimer),
                    const SizedBox(height: 16),

                    // Message (for special cases like no shrimp found)
                    if (_analysisResult!.message != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _analysisResult!.message!,
                                style: TextStyle(
                                  color: Colors.blue.shade900,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ],
              ),
            ),
          ),
          // Loading Overlay
          if (_isAnalyzing)
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
                      AppLocalizations.of(context)!.analyzingDisease,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)!.pleaseWaitAIAnalyzing,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Disease Info Card
  Widget _buildDiseaseInfoCard(DiseaseInfo info) {
    return Container(
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
              Icon(
                info.severity == 'healthy'
                    ? Icons.check_circle
                    : Icons.medical_services,
                color: _getSeverityColor(info.severity),
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.diseaseName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      info.scientificName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChip(
                'Type: ${info.diseaseType.toUpperCase()}',
                Colors.blue,
              ),
              _buildChip(
                'Severity: ${info.severity.toUpperCase()}',
                _getSeverityColor(info.severity),
              ),
              _buildChip('Stage: ${info.stage.toUpperCase()}', Colors.orange),
              _buildChip(
                'Confidence: ${info.confidencePercentage}%',
                Colors.green,
              ),
            ],
          ),
          if (info.visibleSymptoms.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Visible Symptoms:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...info.visibleSymptoms.map(
              (symptom) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        symptom,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Confidence Breakdown Card with Pie Chart
  Widget _buildConfidenceCard(ConfidenceBreakdown confidence) {
    return Container(
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
          const Row(
            children: [
              Icon(Icons.pie_chart, color: Color(0xFF4A90E2), size: 28),
              SizedBox(width: 12),
              Text(
                'Confidence Analysis',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProgressBar(
            'Disease Presence',
            confidence.diseasePresenceConfidence,
          ),
          const SizedBox(height: 12),
          _buildProgressBar('Symptom Match', confidence.symptomMatchConfidence),
          const SizedBox(height: 12),
          _buildProgressBar('Image Quality', confidence.imageQualityScore),

          // Visual Pie Chart representation
          if (confidence.confidencePieChart.isValid) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _buildSimplePieChart(confidence.confidencePieChart),
          ],
        ],
      ),
    );
  }

  // Visual Diagnostics Card
  Widget _buildVisualDiagnosticsCard(VisualDiagnostics diagnostics) {
    return Container(
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
          const Row(
            children: [
              Icon(Icons.visibility, color: Color(0xFF4A90E2), size: 28),
              SizedBox(width: 12),
              Text(
                'Visual Diagnostics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildChip(
            'Image Quality: ${diagnostics.imageQualityAssessment.toUpperCase()}',
            _getQualityColor(diagnostics.imageQualityAssessment),
          ),

          if (diagnostics.affectedAreas.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Affected Areas:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: diagnostics.affectedAreas
                  .map(
                    (area) => Chip(
                      label: Text(area, style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.red.shade50,
                      labelStyle: TextStyle(color: Colors.red.shade900),
                    ),
                  )
                  .toList(),
            ),
          ],

          // Symptom Severity Chart
          if (diagnostics.symptomSeverityChart.isValid) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Symptom Severity Analysis:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildBarChart(diagnostics.symptomSeverityChart),
          ],
        ],
      ),
    );
  }

  // Treatment Plan Card
  Widget _buildTreatmentPlanCard(TreatmentPlan plan) {
    return Container(
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
          const Row(
            children: [
              Icon(Icons.healing, color: Color(0xFF4A90E2), size: 28),
              SizedBox(width: 12),
              Text(
                'Treatment Plan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildChip('Duration: ${plan.treatmentDuration}', Colors.purple),

          if (plan.immediateActions.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildListSection(
              '⚡ Immediate Actions',
              plan.immediateActions,
              Colors.red,
            ),
          ],

          if (plan.medications.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              '💊 Medications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            ...plan.medications.map((med) => _buildMedicationCard(med)),
          ],

          if (plan.preventiveMeasures.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildListSection(
              '🛡️ Preventive Measures',
              plan.preventiveMeasures,
              Colors.green,
            ),
          ],

          if (plan.monitoringSteps.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildListSection(
              '📊 Monitoring Steps',
              plan.monitoringSteps,
              Colors.blue,
            ),
          ],
        ],
      ),
    );
  }

  // Product Recommendations Card
  Widget _buildProductRecommendationsCard(ProductRecommendations products) {
    return Container(
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
          const Row(
            children: [
              Icon(Icons.shopping_cart, color: Color(0xFF4A90E2), size: 28),
              SizedBox(width: 12),
              Text(
                'Product Recommendations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),

          if (products.amazonProducts.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              '🛒 Amazon Products',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...products.amazonProducts.map(
              (product) => _buildProductCard(product, Colors.orange),
            ),
          ],

          if (products.flipkartProducts.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              '🛍️ Flipkart Products',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...products.flipkartProducts.map(
              (product) => _buildProductCard(product, Colors.blue),
            ),
          ],

          if (products.localAlternatives.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              '🏪 Local Alternatives',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...products.localAlternatives.map(
              (alt) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(alt, style: const TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Farmer Guidance Card
  Widget _buildFarmerGuidanceCard(FarmerGuidance guidance) {
    return Container(
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
              Icon(
                Icons.lightbulb,
                color: _getRiskLevelColor(guidance.riskLevel),
                size: 28,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Farmer Guidance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildChip(
            'Risk Level: ${guidance.riskLevel.toUpperCase()}',
            _getRiskLevelColor(guidance.riskLevel),
          ),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              guidance.plainLanguageSummary,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),

          if (guidance.dosList.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildListSection('✅ DO\'s', guidance.dosList, Colors.green),
          ],

          if (guidance.dontsList.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildListSection('❌ DON\'Ts', guidance.dontsList, Colors.red),
          ],

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.support_agent,
                      color: Colors.orange.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Expert Consultation',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  guidance.expertConsultationAdvice,
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.trending_up, color: Colors.green.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Expected Outcome: ${guidance.expectedOutcome}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Disclaimer Card
  Widget _buildDisclaimerCard(String disclaimer) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber, color: Colors.amber.shade700, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              disclaimer,
              style: TextStyle(
                fontSize: 12,
                color: Colors.amber.shade900,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Medication Card
  Widget _buildMedicationCard(MedicationDetail med) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            med.medicationName,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            med.purpose,
            style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 8),
          _buildMedDetailRow('💊 Dosage', med.dosage),
          _buildMedDetailRow('📋 Method', med.applicationMethod),
          _buildMedDetailRow('⏱️ Duration', med.duration),
        ],
      ),
    );
  }

  Widget _buildMedDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  // Helper: Product Card
  Widget _buildProductCard(ProductLink product, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accentColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  product.productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (product.verified)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'VERIFIED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            product.description,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.estimatedPrice,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
              InkWell(
                onTap: () => _launchUrl(product.url),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'View Product',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.open_in_new, color: Colors.white, size: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper: List Section
  Widget _buildListSection(String title, List<String> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 14, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper: Chip Widget
  Widget _buildChip(String label, Color color) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color.withOpacity(0.9)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  // Helper: Progress Bar
  Widget _buildProgressBar(String label, double value) {
    final percentage = (value * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              '$percentage%',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(_getConfidenceColor(value)),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  // Helper: Simple Pie Chart
  Widget _buildSimplePieChart(ChartData chartData) {
    if (!chartData.isValid || chartData.values.isEmpty) return const SizedBox();

    final total = chartData.values.reduce((a, b) => a + b);
    return Column(
      children: [
        const Text(
          'Confidence Distribution',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(chartData.labels.length, (index) {
            final percentage = ((chartData.values[index] / total) * 100)
                .round();
            final color = index == 0 ? Colors.green : Colors.orange;
            return Expanded(
              flex: percentage,
              child: Container(
                height: 40,
                color: color,
                child: Center(
                  child: Text(
                    '$percentage%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(chartData.labels.length, (index) {
            final color = index == 0 ? Colors.green : Colors.orange;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    chartData.labels[index],
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  // Helper: Bar Chart
  Widget _buildBarChart(ChartData chartData) {
    if (!chartData.isValid) return const SizedBox();

    return Column(
      children: List.generate(chartData.labels.length, (index) {
        final value = chartData.values[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      chartData.labels[index],
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Text(
                    '${value.round()}%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: value / 100,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getSeverityColorFromValue(value),
                ),
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Color Helpers
  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'low':
      case 'healthy':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'high':
        return Colors.deepOrange;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getQualityColor(String quality) {
    switch (quality.toLowerCase()) {
      case 'excellent':
      case 'good':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getRiskLevelColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.deepOrange;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    return Colors.red;
  }

  Color _getSeverityColorFromValue(double value) {
    if (value >= 80) return Colors.red;
    if (value >= 60) return Colors.orange;
    if (value >= 40) return Colors.yellow;
    return Colors.green;
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

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isAnalyzing = true;
      _analysisResult = null;
    });

    try {
      print('🔬 Starting disease analysis...');
      final result = await _diseaseService.analyzeDisease(_selectedImage!);

      setState(() {
        _analysisResult = result;
        _isAnalyzing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.analysisComplete),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('❌ Analysis error: $e');
      setState(() {
        _isAnalyzing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Analysis failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _launchUrl(String urlString) async {
    try {
      final uri = Uri.parse(urlString);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch URL';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open link: $e'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }
}
