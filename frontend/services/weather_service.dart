import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

/// Weather Service
/// Handles all weather API interactions
class WeatherService {
  // OpenWeatherMap API Key
  static const String _apiKey = '0c5e45f24e7695cf3ba945f73dddb634';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  /// Fetch weather data for a specific location
  Future<WeatherModel?> getWeatherByCity(String city) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl?q=$city,IN&appid=$_apiKey&units=metric',
      );

      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        // Log error for debugging
        print('Weather API Error: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Weather API Exception: $e');
      return null;
    }
  }

  /// Generate shrimp farming advisory based on weather conditions
  String generateShrimpAdvisory(
    WeatherModel weather,
    String languageCode,
  ) {
    final temp = int.tryParse(weather.temperature) ?? 0;
    final humidity = int.tryParse(weather.humidity) ?? 0;
    final windSpeed = int.tryParse(weather.windSpeed) ?? 0;
    final rainfall = int.tryParse(weather.rainfall) ?? 0;
    final condition = weather.condition.toLowerCase();

    // High temperature alert
    if (temp > 35) {
      return _getLocalizedAdvisory(
        'highTemp',
        languageCode,
        'High temperature detected. Reduce afternoon feeding and increase aeration.',
      );
    }

    // Heavy rainfall alert
    if (rainfall > 70 || condition.contains('rain') || condition.contains('thunder')) {
      return _getLocalizedAdvisory(
        'heavyRain',
        languageCode,
        'Rainfall expected. Monitor salinity levels and water quality closely.',
      );
    }

    // High humidity alert
    if (humidity > 85) {
      return _getLocalizedAdvisory(
        'highHumidity',
        languageCode,
        'High humidity detected. Increase water circulation and monitor dissolved oxygen.',
      );
    }

    // Strong wind alert
    if (windSpeed > 25) {
      return _getLocalizedAdvisory(
        'strongWind',
        languageCode,
        'Strong winds detected. Secure pond covers and check aerators.',
      );
    }

    // Low temperature alert
    if (temp < 20) {
      return _getLocalizedAdvisory(
        'lowTemp',
        languageCode,
        'Low temperature detected. Reduce feeding and monitor shrimp activity.',
      );
    }

    // Ideal conditions
    return _getLocalizedAdvisory(
      'ideal',
      languageCode,
      'Ideal conditions for shrimp farming. Maintain regular feeding schedule.',
    );
  }

  /// Get localized advisory message
  String _getLocalizedAdvisory(String key, String languageCode, String defaultMessage) {
    final advisories = {
      'en': {
        'highTemp': 'High temperature detected. Reduce afternoon feeding and increase aeration.',
        'heavyRain': 'Rainfall expected. Monitor salinity levels and water quality closely.',
        'highHumidity': 'High humidity detected. Increase water circulation and monitor dissolved oxygen.',
        'strongWind': 'Strong winds detected. Secure pond covers and check aerators.',
        'lowTemp': 'Low temperature detected. Reduce feeding and monitor shrimp activity.',
        'ideal': 'Ideal conditions for shrimp farming. Maintain regular feeding schedule.',
      },
      'te': {
        'highTemp': 'అధిక ఉష్ణోగ్రత గుర్తించబడింది. మధ్యాహ్నం ఆహారాన్ని తగ్గించండి మరియు గాలిని పెంచండి.',
        'heavyRain': 'వర్షం అంచనా. లవణత్వ స్థాయిలు మరియు నీటి నాణ్యతను నిశితంగా పర్యవేక్షించండి.',
        'highHumidity': 'అధిక తేమ గుర్తించబడింది. నీటి ప్రసరణను పెంచండి మరియు కరిగిన ఆక్సిజన్‌ను పర్యవేక్షించండి.',
        'strongWind': 'బలమైన గాలులు గుర్తించబడ్డాయి. చెరువు కవర్లను భద్రపరచండి మరియు ఏరేటర్లను తనిఖీ చేయండి.',
        'lowTemp': 'తక్కువ ఉష్ణోగ్రత గుర్తించబడింది. ఆహారాన్ని తగ్గించండి మరియు రొయ్యల కార్యాచరణను పర్యవేక్షించండి.',
        'ideal': 'రొయ్యల పెంపకానికి అనువైన పరిస్థితులు. సాధారణ దాణా షెడ్యూల్‌ను కొనసాగించండి.',
      },
      'ta': {
        'highTemp': 'அதிக வெப்பநிலை கண்டறியப்பட்டது. மதிய உணவைக் குறைத்து காற்றோட்டத்தை அதிகரிக்கவும்.',
        'heavyRain': 'மழை எதிர்பார்க்கப்படுகிறது. உப்புத்தன்மை அளவுகள் மற்றும் நீர் தரத்தை நெருக்கமாக கண்காணிக்கவும்.',
        'highHumidity': 'அதிக ஈரப்பதம் கண்டறியப்பட்டது. நீர் சுழற்சியை அதிகரித்து கரைந்த ஆக்ஸிஜனை கண்காணிக்கவும்.',
        'strongWind': 'வலுவான காற்று கண்டறியப்பட்டது. குளம் கவர்களைப் பாதுகாத்து காற்றோட்டிகளை சரிபார்க்கவும்.',
        'lowTemp': 'குறைந்த வெப்பநிலை கண்டறியப்பட்டது. உணவைக் குறைத்து இறால் செயல்பாட்டை கண்காணிக்கவும்.',
        'ideal': 'இறால் வளர்ப்புக்கு ஏற்ற சூழல். வழக்கமான உணவு அட்டவணையை பராமரிக்கவும்.',
      },
      'hi': {
        'highTemp': 'उच्च तापमान का पता चला। दोपहर का भोजन कम करें और वातन बढ़ाएं।',
        'heavyRain': 'बारिश की संभावना। लवणता के स्तर और पानी की गुणवत्ता की बारीकी से निगरानी करें।',
        'highHumidity': 'उच्च आर्द्रता का पता चला। पानी के संचलन को बढ़ाएं और घुलित ऑक्सीजन की निगरानी करें।',
        'strongWind': 'तेज हवाओं का पता चला। तालाब के कवर को सुरक्षित करें और एरेटर की जांच करें।',
        'lowTemp': 'कम तापमान का पता चला। भोजन कम करें और झींगा गतिविधि की निगरानी करें।',
        'ideal': 'झींगा पालन के लिए आदर्श स्थिति। नियमित भोजन कार्यक्रम बनाए रखें।',
      },
      'kn': {
        'highTemp': 'ಹೆಚ್ಚಿನ ತಾಪಮಾನ ಪತ್ತೆಯಾಗಿದೆ. ಮಧ್ಯಾಹ್ನದ ಆಹಾರವನ್ನು ಕಡಿಮೆ ಮಾಡಿ ಮತ್ತು ಗಾಳಿಯನ್ನು ಹೆಚ್ಚಿಸಿ.',
        'heavyRain': 'ಮಳೆ ನಿರೀಕ್ಷಿತ. ಉಪ್ಪು ಮಟ್ಟಗಳು ಮತ್ತು ನೀರಿನ ಗುಣಮಟ್ಟವನ್ನು ನಿಕಟವಾಗಿ ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ.',
        'highHumidity': 'ಹೆಚ್ಚಿನ ತೇವಾಂಶ ಪತ್ತೆಯಾಗಿದೆ. ನೀರಿನ ಪರಿಚಲನೆಯನ್ನು ಹೆಚ್ಚಿಸಿ ಮತ್ತು ಕರಗಿದ ಆಮ್ಲಜನಕವನ್ನು ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ.',
        'strongWind': 'ಬಲವಾದ ಗಾಳಿ ಪತ್ತೆಯಾಗಿದೆ. ಕೊಳದ ಕವರ್‌ಗಳನ್ನು ಸುರಕ್ಷಿತಗೊಳಿಸಿ ಮತ್ತು ಏರೇಟರ್‌ಗಳನ್ನು ಪರಿಶೀಲಿಸಿ.',
        'lowTemp': 'ಕಡಿಮೆ ತಾಪಮಾನ ಪತ್ತೆಯಾಗಿದೆ. ಆಹಾರವನ್ನು ಕಡಿಮೆ ಮಾಡಿ ಮತ್ತು ಸೀಗಡಿ ಚಟುವಟಿಕೆಯನ್ನು ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ.',
        'ideal': 'ಸೀಗಡಿ ಸಾಕಣೆಗೆ ಸೂಕ್ತ ಪರಿಸ್ಥಿತಿಗಳು. ನಿಯಮಿತ ಆಹಾರ ವೇಳಾಪಟ್ಟಿಯನ್ನು ನಿರ್ವಹಿಸಿ.',
      },
    };

    return advisories[languageCode]?[key] ?? defaultMessage;
  }
}
