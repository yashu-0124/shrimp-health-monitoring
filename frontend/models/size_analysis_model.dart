/// Size Analysis Models
/// Data structures for shrimp size calculation response

class SizeAnalysisResult {
  final String detectionStatus;
  final ShrimpAnalysis? shrimpAnalysis;
  final VisualInsights? visualInsights;
  final FarmerSummary? farmerSummary;
  final DataQuality? dataQuality;
  final String? disclaimer;
  final String? message; // For error cases

  SizeAnalysisResult({
    required this.detectionStatus,
    this.shrimpAnalysis,
    this.visualInsights,
    this.farmerSummary,
    this.dataQuality,
    this.disclaimer,
    this.message,
  });

  factory SizeAnalysisResult.fromJson(Map<String, dynamic> json) {
    return SizeAnalysisResult(
      detectionStatus: json['detection_status'] ?? 'unknown',
      shrimpAnalysis: json['shrimp_analysis'] != null
          ? ShrimpAnalysis.fromJson(json['shrimp_analysis'])
          : null,
      visualInsights: json['visual_insights'] != null
          ? VisualInsights.fromJson(json['visual_insights'])
          : null,
      farmerSummary: json['farmer_summary'] != null
          ? FarmerSummary.fromJson(json['farmer_summary'])
          : null,
      dataQuality: json['data_quality'] != null
          ? DataQuality.fromJson(json['data_quality'])
          : null,
      disclaimer: json['disclaimer'],
      message: json['message'],
    );
  }

  bool get isSuccess => detectionStatus == 'success';
  bool get noShrimpDetected => detectionStatus == 'no_shrimp_detected';
  bool get lowConfidence => detectionStatus == 'low_confidence';
}

class ShrimpAnalysis {
  final MetricWithConfidence averageLength;
  final MetricWithConfidence averageWeight;
  final MetricWithConfidence shrimpCount;
  final MetricWithConfidence totalBiomass;

  ShrimpAnalysis({
    required this.averageLength,
    required this.averageWeight,
    required this.shrimpCount,
    required this.totalBiomass,
  });

  factory ShrimpAnalysis.fromJson(Map<String, dynamic> json) {
    return ShrimpAnalysis(
      averageLength: MetricWithConfidence.fromJson(
        json['average_length_cm'] ?? {'value': 0.0, 'confidence': 0.0},
      ),
      averageWeight: MetricWithConfidence.fromJson(
        json['average_weight_g'] ?? {'value': 0.0, 'confidence': 0.0},
      ),
      shrimpCount: MetricWithConfidence.fromJson(
        json['shrimp_count_estimated'] ?? {'value': 0, 'confidence': 0.0},
      ),
      totalBiomass: MetricWithConfidence.fromJson(
        json['total_biomass_kg'] ?? {'value': 0.0, 'confidence': 0.0},
      ),
    );
  }
}

class MetricWithConfidence {
  final dynamic value; // Can be int or double
  final double confidence;

  MetricWithConfidence({
    required this.value,
    required this.confidence,
  });

  factory MetricWithConfidence.fromJson(Map<String, dynamic> json) {
    return MetricWithConfidence(
      value: json['value'],
      confidence: (json['confidence'] ?? 0.0).toDouble(),
    );
  }

  String get displayValue {
    if (value is int) return value.toString();
    if (value is double) return value.toStringAsFixed(1);
    return value.toString();
  }

  int get confidencePercentage => (confidence * 100).round();
}

class VisualInsights {
  final ChartData? sizeDistribution;
  final ChartData? biomassContribution;

  VisualInsights({
    this.sizeDistribution,
    this.biomassContribution,
  });

  factory VisualInsights.fromJson(Map<String, dynamic> json) {
    return VisualInsights(
      sizeDistribution: json['size_distribution_chart'] != null
          ? ChartData.fromJson(json['size_distribution_chart'])
          : null,
      biomassContribution: json['biomass_contribution_chart'] != null
          ? ChartData.fromJson(json['biomass_contribution_chart'])
          : null,
    );
  }
}

class ChartData {
  final String type; // 'bar', 'pie', etc.
  final List<String> labels;
  final List<int> values;

  ChartData({
    required this.type,
    required this.labels,
    required this.values,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      type: json['type'] ?? 'bar',
      labels: (json['labels'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      values: (json['values'] as List<dynamic>?)
              ?.map((e) => (e is int) ? e : (e as num).toInt())
              .toList() ??
          [],
    );
  }

  bool get isValid => labels.isNotEmpty && values.isNotEmpty && labels.length == values.length;
}

class FarmerSummary {
  final String plainLanguage;
  final List<String> recommendedActions;

  FarmerSummary({
    required this.plainLanguage,
    required this.recommendedActions,
  });

  factory FarmerSummary.fromJson(Map<String, dynamic> json) {
    return FarmerSummary(
      plainLanguage: json['plain_language'] ?? '',
      recommendedActions: (json['recommended_actions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          (json['recommended_action'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class DataQuality {
  final String imageQuality;
  final List<String> limitations;

  DataQuality({
    required this.imageQuality,
    required this.limitations,
  });

  factory DataQuality.fromJson(Map<String, dynamic> json) {
    return DataQuality(
      imageQuality: json['image_quality'] ?? 'unknown',
      limitations: (json['estimation_limitations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          (json['limitations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  bool get isGoodQuality => imageQuality == 'good';
  bool get isModerateQuality => imageQuality == 'moderate';
  bool get isPoorQuality => imageQuality == 'poor';
}
