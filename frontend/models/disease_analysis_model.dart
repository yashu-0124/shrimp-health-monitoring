/// Disease Analysis Models for Shrimp Disease AI Detection
/// Structures for storing Gemini Vision API disease detection results

/// Main wrapper for disease detection response
class DiseaseAnalysisResult {
  final String detectionStatus; // success | no_disease_detected | no_shrimp_found | low_confidence
  final DiseaseInfo? diseaseInfo;
  final ConfidenceBreakdown? confidenceBreakdown;
  final VisualDiagnostics? visualDiagnostics;
  final TreatmentPlan? treatmentPlan;
  final ProductRecommendations? productRecommendations;
  final FarmerGuidance? farmerGuidance;
  final String disclaimer;
  final String? message;

  DiseaseAnalysisResult({
    required this.detectionStatus,
    this.diseaseInfo,
    this.confidenceBreakdown,
    this.visualDiagnostics,
    this.treatmentPlan,
    this.productRecommendations,
    this.farmerGuidance,
    required this.disclaimer,
    this.message,
  });

  factory DiseaseAnalysisResult.fromJson(Map<String, dynamic> json) {
    return DiseaseAnalysisResult(
      detectionStatus: json['detection_status'] ?? 'error',
      diseaseInfo: json['disease_info'] != null
          ? DiseaseInfo.fromJson(json['disease_info'])
          : null,
      confidenceBreakdown: json['confidence_breakdown'] != null
          ? ConfidenceBreakdown.fromJson(json['confidence_breakdown'])
          : null,
      visualDiagnostics: json['visual_diagnostics'] != null
          ? VisualDiagnostics.fromJson(json['visual_diagnostics'])
          : null,
      treatmentPlan: json['treatment_plan'] != null
          ? TreatmentPlan.fromJson(json['treatment_plan'])
          : null,
      productRecommendations: json['product_recommendations'] != null
          ? ProductRecommendations.fromJson(json['product_recommendations'])
          : null,
      farmerGuidance: json['farmer_guidance'] != null
          ? FarmerGuidance.fromJson(json['farmer_guidance'])
          : null,
      disclaimer: json['disclaimer'] ?? 'AI-based estimation. Consult aquaculture expert for confirmation.',
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detection_status': detectionStatus,
      'disease_info': diseaseInfo?.toJson(),
      'confidence_breakdown': confidenceBreakdown?.toJson(),
      'visual_diagnostics': visualDiagnostics?.toJson(),
      'treatment_plan': treatmentPlan?.toJson(),
      'product_recommendations': productRecommendations?.toJson(),
      'farmer_guidance': farmerGuidance?.toJson(),
      'disclaimer': disclaimer,
      'message': message,
    };
  }
}

/// Disease identification information
class DiseaseInfo {
  final String diseaseName;
  final String scientificName;
  final String diseaseType; // viral | bacterial | fungal | parasitic | environmental
  final String severity; // low | moderate | high | critical
  final double overallConfidence; // 0.0 to 1.0
  final List<String> visibleSymptoms;
  final String stage; // early | developing | advanced | critical

  DiseaseInfo({
    required this.diseaseName,
    required this.scientificName,
    required this.diseaseType,
    required this.severity,
    required this.overallConfidence,
    required this.visibleSymptoms,
    required this.stage,
  });

  factory DiseaseInfo.fromJson(Map<String, dynamic> json) {
    return DiseaseInfo(
      diseaseName: json['disease_name'] ?? 'Unknown',
      scientificName: json['scientific_name'] ?? 'N/A',
      diseaseType: json['disease_type'] ?? 'unknown',
      severity: json['severity'] ?? 'unknown',
      overallConfidence: (json['overall_confidence'] ?? 0.0).toDouble(),
      visibleSymptoms: List<String>.from(json['visible_symptoms'] ?? []),
      stage: json['stage'] ?? 'unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'disease_name': diseaseName,
      'scientific_name': scientificName,
      'disease_type': diseaseType,
      'severity': severity,
      'overall_confidence': overallConfidence,
      'visible_symptoms': visibleSymptoms,
      'stage': stage,
    };
  }

  // Helper getters
  int get confidencePercentage => (overallConfidence * 100).round();
  
  String get severityColor {
    switch (severity.toLowerCase()) {
      case 'low':
        return '#4CAF50'; // Green
      case 'moderate':
        return '#FF9800'; // Orange
      case 'high':
        return '#FF5722'; // Deep Orange
      case 'critical':
        return '#F44336'; // Red
      default:
        return '#9E9E9E'; // Grey
    }
  }
}

/// Confidence breakdown for visualization
class ConfidenceBreakdown {
  final double diseasePresenceConfidence;
  final double symptomMatchConfidence;
  final double imageQualityScore;
  final ChartData confidencePieChart;

  ConfidenceBreakdown({
    required this.diseasePresenceConfidence,
    required this.symptomMatchConfidence,
    required this.imageQualityScore,
    required this.confidencePieChart,
  });

  factory ConfidenceBreakdown.fromJson(Map<String, dynamic> json) {
    return ConfidenceBreakdown(
      diseasePresenceConfidence: (json['disease_presence_confidence'] ?? 0.0).toDouble(),
      symptomMatchConfidence: (json['symptom_match_confidence'] ?? 0.0).toDouble(),
      imageQualityScore: (json['image_quality_score'] ?? 0.0).toDouble(),
      confidencePieChart: ChartData.fromJson(json['confidence_pie_chart'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'disease_presence_confidence': diseasePresenceConfidence,
      'symptom_match_confidence': symptomMatchConfidence,
      'image_quality_score': imageQualityScore,
      'confidence_pie_chart': confidencePieChart.toJson(),
    };
  }
}

/// Visual diagnostics data for charts
class VisualDiagnostics {
  final List<String> affectedAreas;
  final ChartData symptomSeverityChart;
  final String imageQualityAssessment; // excellent | good | moderate | poor

  VisualDiagnostics({
    required this.affectedAreas,
    required this.symptomSeverityChart,
    required this.imageQualityAssessment,
  });

  factory VisualDiagnostics.fromJson(Map<String, dynamic> json) {
    return VisualDiagnostics(
      affectedAreas: List<String>.from(json['affected_areas'] ?? []),
      symptomSeverityChart: ChartData.fromJson(json['symptom_severity_chart'] ?? {}),
      imageQualityAssessment: json['image_quality_assessment'] ?? 'unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'affected_areas': affectedAreas,
      'symptom_severity_chart': symptomSeverityChart.toJson(),
      'image_quality_assessment': imageQualityAssessment,
    };
  }
}

/// Treatment plan with medications and procedures
class TreatmentPlan {
  final List<String> immediateActions;
  final List<MedicationDetail> medications;
  final List<String> preventiveMeasures;
  final String treatmentDuration;
  final List<String> monitoringSteps;

  TreatmentPlan({
    required this.immediateActions,
    required this.medications,
    required this.preventiveMeasures,
    required this.treatmentDuration,
    required this.monitoringSteps,
  });

  factory TreatmentPlan.fromJson(Map<String, dynamic> json) {
    return TreatmentPlan(
      immediateActions: List<String>.from(json['immediate_actions'] ?? []),
      medications: (json['medications'] as List<dynamic>?)
              ?.map((m) => MedicationDetail.fromJson(m))
              .toList() ??
          [],
      preventiveMeasures: List<String>.from(json['preventive_measures'] ?? []),
      treatmentDuration: json['treatment_duration'] ?? 'Consult expert',
      monitoringSteps: List<String>.from(json['monitoring_steps'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'immediate_actions': immediateActions,
      'medications': medications.map((m) => m.toJson()).toList(),
      'preventive_measures': preventiveMeasures,
      'treatment_duration': treatmentDuration,
      'monitoring_steps': monitoringSteps,
    };
  }
}

/// Medication details with dosage
class MedicationDetail {
  final String medicationName;
  final String purpose;
  final String dosage;
  final String applicationMethod;
  final String duration;

  MedicationDetail({
    required this.medicationName,
    required this.purpose,
    required this.dosage,
    required this.applicationMethod,
    required this.duration,
  });

  factory MedicationDetail.fromJson(Map<String, dynamic> json) {
    return MedicationDetail(
      medicationName: json['medication_name'] ?? 'Unknown',
      purpose: json['purpose'] ?? '',
      dosage: json['dosage'] ?? 'As per expert',
      applicationMethod: json['application_method'] ?? 'As directed',
      duration: json['duration'] ?? 'Consult expert',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medication_name': medicationName,
      'purpose': purpose,
      'dosage': dosage,
      'application_method': applicationMethod,
      'duration': duration,
    };
  }
}

/// Product recommendations with verified links
class ProductRecommendations {
  final List<ProductLink> amazonProducts;
  final List<ProductLink> flipkartProducts;
  final List<String> localAlternatives;

  ProductRecommendations({
    required this.amazonProducts,
    required this.flipkartProducts,
    required this.localAlternatives,
  });

  factory ProductRecommendations.fromJson(Map<String, dynamic> json) {
    return ProductRecommendations(
      amazonProducts: (json['amazon_products'] as List<dynamic>?)
              ?.map((p) => ProductLink.fromJson(p))
              .toList() ??
          [],
      flipkartProducts: (json['flipkart_products'] as List<dynamic>?)
              ?.map((p) => ProductLink.fromJson(p))
              .toList() ??
          [],
      localAlternatives: List<String>.from(json['local_alternatives'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amazon_products': amazonProducts.map((p) => p.toJson()).toList(),
      'flipkart_products': flipkartProducts.map((p) => p.toJson()).toList(),
      'local_alternatives': localAlternatives,
    };
  }
}

/// Product link with details
class ProductLink {
  final String productName;
  final String description;
  final String url;
  final String estimatedPrice;
  final bool verified;

  ProductLink({
    required this.productName,
    required this.description,
    required this.url,
    required this.estimatedPrice,
    this.verified = true,
  });

  factory ProductLink.fromJson(Map<String, dynamic> json) {
    return ProductLink(
      productName: json['product_name'] ?? 'Product',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      estimatedPrice: json['estimated_price'] ?? 'Check online',
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'description': description,
      'url': url,
      'estimated_price': estimatedPrice,
      'verified': verified,
    };
  }
}

/// Farmer-friendly guidance and summary
class FarmerGuidance {
  final String plainLanguageSummary;
  final String riskLevel; // low | medium | high | critical
  final List<String> dosList;
  final List<String> dontsList;
  final String expertConsultationAdvice;
  final String expectedOutcome;

  FarmerGuidance({
    required this.plainLanguageSummary,
    required this.riskLevel,
    required this.dosList,
    required this.dontsList,
    required this.expertConsultationAdvice,
    required this.expectedOutcome,
  });

  factory FarmerGuidance.fromJson(Map<String, dynamic> json) {
    return FarmerGuidance(
      plainLanguageSummary: json['plain_language_summary'] ?? '',
      riskLevel: json['risk_level'] ?? 'unknown',
      dosList: List<String>.from(json['dos_list'] ?? []),
      dontsList: List<String>.from(json['donts_list'] ?? []),
      expertConsultationAdvice: json['expert_consultation_advice'] ?? 'Consult an aquaculture expert immediately.',
      expectedOutcome: json['expected_outcome'] ?? 'Follow treatment plan for best results.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plain_language_summary': plainLanguageSummary,
      'risk_level': riskLevel,
      'dos_list': dosList,
      'donts_list': dontsList,
      'expert_consultation_advice': expertConsultationAdvice,
      'expected_outcome': expectedOutcome,
    };
  }
}

/// Chart data structure for visualizations
class ChartData {
  final String type; // pie | bar | line
  final List<String> labels;
  final List<double> values;

  ChartData({
    required this.type,
    required this.labels,
    required this.values,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      type: json['type'] ?? 'pie',
      labels: List<String>.from(json['labels'] ?? []),
      values: (json['values'] as List<dynamic>?)
              ?.map((v) => (v is num) ? v.toDouble() : 0.0)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'labels': labels,
      'values': values,
    };
  }

  bool get isValid => labels.isNotEmpty && values.isNotEmpty && labels.length == values.length;
}
