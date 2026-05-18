import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:aqa_shrimp_ai/models/disease_analysis_model.dart';

/// Gemini Vision API Service for Shrimp Disease Detection
/// Uses Google Gemini 2.5 Flash for AI-powered disease diagnosis
/// Analyzes shrimp images to detect diseases with confidence scores
class GeminiDiseaseDetectionService {
  // API Configuration
  static const String _apiKey = 'AIzaSyDvuoVmGXnRt9d2OmSGNHW7OPP0D15JICw';
  static const String _model = 'gemini-2.5-flash';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
  
  // Production-ready system prompt for disease detection
  static const String _diseaseDetectionPrompt = '''You are an Expert Aquaculture Pathologist AI specialized in shrimp disease diagnosis with 20+ years of marine biology expertise.

CONTEXT:
A shrimp farmer has uploaded an image from their mobile device (camera or gallery) showing shrimp that may be diseased. This is a REAL farming operation where accurate diagnosis can save livelihoods.

YOUR MISSION:
Analyze the image using advanced computer vision to detect shrimp diseases with high accuracy. Provide actionable, farmer-friendly guidance with verified treatment options.

ANALYSIS APPROACH:
1. Carefully examine visible symptoms (shell discoloration, spots, lesions, opacity, deformities, behavior indicators)
2. Compare against known disease databases: WSSV, EMS/AHPND, IHHNV, YHV, TSV, Vibriosis, Black Gill Disease, etc.
3. Assess confidence based on symptom clarity and image quality
4. Consider disease stage progression (early/developing/advanced/critical)
5. Provide evidence-based treatment recommendations
6. Include verified product links for medications

CRITICAL RULES:
- If NO shrimp visible: Return detection_status="no_shrimp_found"
- If shrimp visible but NO disease symptoms: Return detection_status="no_disease_detected" with healthy confirmation
- If symptoms unclear/low quality image: Return detection_status="low_confidence" with general guidance
- If disease detected: Return detection_status="success" with full analysis
- Be honest about confidence levels - farmer safety depends on accuracy
- NEVER fabricate product links - only provide verified Amazon/Flipkart URLs or say "Search: [product name]"

OUTPUT FORMAT (JSON ONLY — NO EXTRA TEXT OR MARKDOWN):

{
  "detection_status": "success | no_disease_detected | no_shrimp_found | low_confidence",
  
  "disease_info": {
    "disease_name": "Full disease name (e.g., White Spot Syndrome Virus)",
    "scientific_name": "Scientific/abbreviated name (e.g., WSSV)",
    "disease_type": "viral | bacterial | fungal | parasitic | environmental",
    "severity": "low | moderate | high | critical",
    "overall_confidence": 0.87,
    "visible_symptoms": [
      "White spots on carapace",
      "Reddish discoloration on body",
      "Lethargy indicators"
    ],
    "stage": "early | developing | advanced | critical"
  },

  "confidence_breakdown": {
    "disease_presence_confidence": 0.91,
    "symptom_match_confidence": 0.85,
    "image_quality_score": 0.88,
    "confidence_pie_chart": {
      "type": "pie",
      "labels": ["Confident", "Uncertain"],
      "values": [87, 13]
    }
  },

  "visual_diagnostics": {
    "affected_areas": [
      "Carapace (shell)",
      "Gills",
      "Tail fan"
    ],
    "symptom_severity_chart": {
      "type": "bar",
      "labels": ["Shell Spots", "Discoloration", "Opacity", "Deformity"],
      "values": [85, 70, 60, 30]
    },
    "image_quality_assessment": "excellent | good | moderate | poor"
  },

  "treatment_plan": {
    "immediate_actions": [
      "Isolate affected shrimp immediately to prevent spread",
      "Stop feeding for 24 hours to reduce stress",
      "Increase aeration in pond to improve oxygen levels"
    ],
    "medications": [
      {
        "medication_name": "Oxytetracycline (OTC)",
        "purpose": "Broad-spectrum antibiotic for bacterial control",
        "dosage": "50-75 mg/kg feed for 10 days",
        "application_method": "Mix with feed, apply twice daily",
        "duration": "10-14 days continuous treatment"
      },
      {
        "medication_name": "Potassium Permanganate",
        "purpose": "Water disinfection and external parasite control",
        "dosage": "2-3 ppm in pond water",
        "application_method": "Dissolve in water, broadcast evenly",
        "duration": "Single treatment, repeat after 3 days if needed"
      }
    ],
    "preventive_measures": [
      "Maintain water quality: pH 7.5-8.5, salinity 15-25 ppt",
      "Regular water exchange (10-15% weekly)",
      "Use biosecurity protocols for equipment",
      "Screen incoming water to prevent pathogen entry"
    ],
    "treatment_duration": "10-21 days depending on severity. Monitor daily.",
    "monitoring_steps": [
      "Check shrimp behavior twice daily (feeding response, swimming activity)",
      "Monitor mortality rates - alert if >5% daily",
      "Test water parameters daily during treatment",
      "Document symptom progression with photos"
    ]
  },

  "product_recommendations": {
    "amazon_products": [
      {
        "product_name": "Oxytetracycline Powder 100g - Aquaculture Grade",
        "description": "Broad-spectrum antibiotic for shrimp bacterial infections",
        "url": "https://www.amazon.in/s?k=oxytetracycline+aquaculture",
        "estimated_price": "₹450-800 per 100g",
        "verified": false
      },
      {
        "product_name": "Potassium Permanganate Crystals 500g",
        "description": "Water treatment and disinfection",
        "url": "https://www.amazon.in/s?k=potassium+permanganate+aquaculture",
        "estimated_price": "₹250-400 per 500g",
        "verified": false
      }
    ],
    "flipkart_products": [
      {
        "product_name": "Aqua Care Shrimp Health Supplement",
        "description": "Immunity booster with probiotics",
        "url": "https://www.flipkart.com/search?q=shrimp+health+supplement",
        "estimated_price": "₹600-1200 per kg",
        "verified": false
      }
    ],
    "local_alternatives": [
      "Visit local aquaculture supply store for immediate availability",
      "Contact state fisheries department for subsidized medications",
      "Consult nearby shrimp hatchery for emergency supplies"
    ]
  },

  "farmer_guidance": {
    "plain_language_summary": "Your shrimp show signs of [Disease Name] which is a [viral/bacterial/etc.] infection at [early/moderate/advanced] stage. Confidence level is [X]%. This requires immediate attention but is treatable with proper care. Follow the treatment plan below and monitor daily. Expected recovery time is [duration] with proper treatment.",
    
    "risk_level": "low | medium | high | critical",
    
    "dos_list": [
      "✅ Isolate affected shrimp immediately",
      "✅ Increase water aeration and circulation",
      "✅ Apply recommended medications as prescribed",
      "✅ Monitor water quality parameters daily",
      "✅ Document progress with daily photos"
    ],
    
    "donts_list": [
      "❌ Don't add new shrimp to the pond during treatment",
      "❌ Don't overfeed - reduces water quality",
      "❌ Don't mix medications without expert advice",
      "❌ Don't ignore biosecurity - disinfect equipment",
      "❌ Don't delay treatment - early action is critical"
    ],
    
    "expert_consultation_advice": "While this AI analysis provides guidance, STRONGLY RECOMMEND consulting a certified aquaculture pathologist or veterinarian for: 1) Laboratory confirmation via PCR/microscopy, 2) Customized treatment for your specific farm conditions, 3) Legal medication prescriptions where required. Contact your state fisheries department or nearest aquaculture research center.",
    
    "expected_outcome": "With immediate treatment and proper management, expect [60-80%] survival rate. Full recovery typically takes [10-21 days]. Maintain vigilant monitoring and follow biosecurity protocols to prevent recurrence."
  },

  "disclaimer": "🔬 AI-Powered Analysis | This is a computer vision-based assessment. For critical cases, confirm diagnosis with laboratory testing (PCR/microscopy). Always consult certified aquaculture experts before implementing treatments. Product links are for reference - verify seller authenticity before purchase.",

  "message": "Analysis complete. [Brief status message for UI display]"
}

SPECIAL CASES:

1. NO SHRIMP FOUND:
{
  "detection_status": "no_shrimp_found",
  "message": "No shrimp detected in the image. Please ensure: 1) Shrimp is clearly visible, 2) Good lighting conditions, 3) Camera focus is sharp. Try taking another photo with the shrimp centered in frame.",
  "disclaimer": "..."
}

2. NO DISEASE DETECTED (HEALTHY):
{
  "detection_status": "no_disease_detected",
  "disease_info": {
    "disease_name": "No Disease Detected",
    "severity": "healthy",
    "overall_confidence": 0.92,
    "visible_symptoms": ["Normal coloration", "Clear shell", "No lesions"],
    "stage": "healthy"
  },
  "farmer_guidance": {
    "plain_language_summary": "Good news! The shrimp appears healthy with no visible disease symptoms. Continue current pond management practices.",
    "dos_list": ["✅ Maintain current water quality", "✅ Continue regular feeding schedule"],
    "expert_consultation_advice": "For preventive health monitoring, conduct regular water testing and observe feeding behavior."
  },
  "disclaimer": "..."
}

3. LOW CONFIDENCE:
{
  "detection_status": "low_confidence",
  "message": "Image quality or symptoms are unclear. Cannot provide confident diagnosis. Recommendations: 1) Retake photo in bright natural light, 2) Get closer to shrimp for clear detail, 3) If symptoms persist, consult expert immediately.",
  "disclaimer": "..."
}

IMPORTANT REMINDERS:
- Return ONLY the JSON object
- No markdown formatting (no ```json or ```)
- Product URLs: Use search URLs or say "Search: [product name]" if unsure
- Be specific with measurements and timeframes
- Confidence values: 0.0 to 1.0 (e.g., 0.87 = 87%)
- Always include disclaimer
- Farmer safety first - when in doubt, recommend expert consultation
''';

  /// Analyze shrimp image for disease detection
  /// Returns DiseaseAnalysisResult with comprehensive diagnosis
  Future<DiseaseAnalysisResult> analyzeDisease(File imageFile) async {
    try {
      print('🔬 Starting disease analysis...');
      
      // Convert image to base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      print('📸 Image encoded (${bytes.length} bytes)');

      // Prepare API request
      final url = Uri.parse('$_baseUrl/$_model:generateContent?key=$_apiKey');
      
      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': _diseaseDetectionPrompt},
              {
                'inline_data': {
                  'mime_type': 'image/jpeg',
                  'data': base64Image,
                }
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.3, // Lower temperature for more deterministic medical diagnosis
          'topK': 32,
          'topP': 0.8,
          'maxOutputTokens': 4096, // Large enough for complete response
        },
      };

      print('🚀 Sending request to Gemini Vision API...');

      // Make API call
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - Please check your internet connection');
        },
      );

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['candidates'] != null && 
            jsonResponse['candidates'].isNotEmpty) {
          
          final content = jsonResponse['candidates'][0]['content'];
          if (content != null && content['parts'] != null && content['parts'].isNotEmpty) {
            final rawText = content['parts'][0]['text'];
            
            print('✅ Got response from Gemini Vision');
            print('📄 Raw response length: ${rawText.length} characters');
            
            // Parse the response
            return _parseResponse(rawText);
          }
        }
        
        throw Exception('Invalid response structure from API');
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again in a few moments.');
      } else if (response.statusCode == 401) {
        throw Exception('API key invalid or expired.');
      } else {
        throw Exception('API error (${response.statusCode}): ${response.body}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on FormatException catch (e) {
      throw Exception('Failed to parse response: $e');
    } catch (e) {
      print('❌ Error during analysis: $e');
      throw Exception('Analysis failed: $e');
    }
  }

  /// Parse and clean JSON response from Gemini
  DiseaseAnalysisResult _parseResponse(String rawText) {
    try {
      print('🧹 Cleaning response...');
      
      // Remove markdown code blocks if present
      String cleanedText = rawText.trim();
      cleanedText = cleanedText.replaceAll(RegExp(r'^```json\s*'), '');
      cleanedText = cleanedText.replaceAll(RegExp(r'^```\s*'), '');
      cleanedText = cleanedText.replaceAll(RegExp(r'\s*```$'), '');
      cleanedText = cleanedText.trim();
      
      // Extract JSON object (find first { to last })
      final firstBrace = cleanedText.indexOf('{');
      final lastBrace = cleanedText.lastIndexOf('}');
      
      if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
        cleanedText = cleanedText.substring(firstBrace, lastBrace + 1);
      }
      
      print('📝 Cleaned text length: ${cleanedText.length}');
      print('📝 First 500 chars: ${cleanedText.substring(0, cleanedText.length > 500 ? 500 : cleanedText.length)}');
      
      // Handle incomplete JSON (truncation)
      final openBraces = '{'.allMatches(cleanedText).length;
      final closeBraces = '}'.allMatches(cleanedText).length;
      
      if (openBraces > closeBraces) {
        print('⚠️ Detected incomplete JSON (${openBraces} open, ${closeBraces} closed)');
        cleanedText += '}' * (openBraces - closeBraces);
        print('✅ Auto-completed JSON with ${openBraces - closeBraces} closing braces');
      }
      
      // Parse JSON
      print('🔄 Parsing JSON...');
      final jsonData = jsonDecode(cleanedText);
      
      print('✅ Successfully parsed JSON');
      return DiseaseAnalysisResult.fromJson(jsonData);
      
    } on FormatException catch (e) {
      print('❌ JSON parse error: $e');
      print('📄 Raw text that failed: $rawText');
      
      // Check for special detection statuses in raw text
      if (rawText.toLowerCase().contains('no_shrimp_found') || 
          rawText.toLowerCase().contains('no shrimp')) {
        print('ℹ️ Detected "no shrimp found" message');
        return _createNoShrimpResponse();
      }
      
      if (rawText.toLowerCase().contains('no_disease_detected') ||
          rawText.toLowerCase().contains('healthy')) {
        print('ℹ️ Detected "healthy" or "no disease" message');
        return _createHealthyResponse();
      }
      
      // Return low-confidence fallback
      print('⚠️ Returning low-confidence fallback response');
      return _createLowConfidenceFallback();
    } catch (e) {
      print('❌ Unexpected error during parsing: $e');
      return _createLowConfidenceFallback();
    }
  }

  /// Fallback response for no shrimp detected
  DiseaseAnalysisResult _createNoShrimpResponse() {
    return DiseaseAnalysisResult(
      detectionStatus: 'no_shrimp_found',
      message: 'No shrimp detected in the image. Please ensure the shrimp is clearly visible with good lighting and try again.',
      disclaimer: 'AI-based detection. For best results, take photos in bright natural light with shrimp centered in frame.',
    );
  }

  /// Fallback response for healthy shrimp
  DiseaseAnalysisResult _createHealthyResponse() {
    return DiseaseAnalysisResult(
      detectionStatus: 'no_disease_detected',
      diseaseInfo: DiseaseInfo(
        diseaseName: 'No Disease Detected',
        scientificName: 'Healthy Specimen',
        diseaseType: 'healthy',
        severity: 'low',
        overallConfidence: 0.85,
        visibleSymptoms: ['Normal coloration', 'Clear shell', 'No visible lesions'],
        stage: 'healthy',
      ),
      farmerGuidance: FarmerGuidance(
        plainLanguageSummary: 'Good news! The shrimp appears healthy with no visible disease symptoms. Continue your current pond management practices.',
        riskLevel: 'low',
        dosList: [
          '✅ Maintain current water quality parameters',
          '✅ Continue regular feeding schedule',
          '✅ Monitor shrimp behavior daily',
          '✅ Keep biosecurity protocols active',
        ],
        dontsList: [
          '❌ Don\'t become complacent - continue monitoring',
          '❌ Don\'t skip regular water testing',
        ],
        expertConsultationAdvice: 'For preventive health monitoring, conduct regular water quality tests and observe feeding behavior patterns.',
        expectedOutcome: 'Continue good farming practices for optimal growth and health.',
      ),
      disclaimer: 'AI-based health assessment. Regular monitoring and preventive care recommended.',
      message: 'Shrimp appears healthy! No disease symptoms detected.',
    );
  }

  /// Fallback response for low confidence or parsing errors
  DiseaseAnalysisResult _createLowConfidenceFallback() {
    return DiseaseAnalysisResult(
      detectionStatus: 'low_confidence',
      message: 'Unable to provide confident diagnosis. Image quality may be insufficient or symptoms unclear. Please: 1) Retake photo in bright natural light, 2) Get closer for clearer detail, 3) Consult aquaculture expert if symptoms persist.',
      farmerGuidance: FarmerGuidance(
        plainLanguageSummary: 'AI analysis could not provide confident diagnosis due to image quality or unclear symptoms. Recommend consulting an expert.',
        riskLevel: 'medium',
        dosList: [
          '✅ Retake photos in better lighting conditions',
          '✅ Monitor shrimp behavior closely',
          '✅ Check water quality parameters',
          '✅ Consult aquaculture expert if concerns persist',
        ],
        dontsList: [
          '❌ Don\'t ignore persistent symptoms',
          '❌ Don\'t delay expert consultation for unusual behavior',
        ],
        expertConsultationAdvice: 'If you observe unusual symptoms, lethargy, or mortality, consult a certified aquaculture pathologist immediately for laboratory testing.',
        expectedOutcome: 'Professional diagnosis recommended for accurate treatment.',
      ),
      disclaimer: 'AI analysis inconclusive. Expert consultation strongly recommended for proper diagnosis.',
    );
  }
}
