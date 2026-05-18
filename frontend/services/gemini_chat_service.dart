import 'dart:convert';
import 'package:http/http.dart' as http;

/// Gemini Chat Service
/// Handles real-time conversations with Google Gemini 2.5 Flash model
/// Specialized for shrimp farming & disease guidance
class GeminiChatService {
  // API Configuration
  static const String _apiKey = 'AIzaSyCV9QpMxWnb_k_tJgyD-WIsiDW4DrZu1Rc';
  static const String _model = 'gemini-2.5-flash';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
  
  // System prompt for specialized shrimp farming guidance
  static const String _systemPrompt = '''You are an expert aquaculture assistant specialized in shrimp farming.
You help farmers diagnose shrimp diseases, improve yield, prevent losses,
and follow best cultivation practices.

Always respond in:
- Simple language
- Step-by-step format
- Clear headings when needed
- Practical advice suitable for Indian shrimp farmers

If disease-related:
- Mention symptoms
- Possible causes
- Immediate actions
- Preventive measures

If unsure:
- Say "Based on common shrimp farming patterns…"
- Never give unsafe or harmful advice''';

  /// Send message to Gemini and get response
  /// 
  /// [userMessage] - The farmer's question or input
  /// [conversationHistory] - Previous messages for context
  /// 
  /// Returns the AI response text or throws an error
  Future<String> sendMessage({
    required String userMessage,
    List<Map<String, String>>? conversationHistory,
  }) async {
    try {
      // Build conversation contents with system prompt
      final List<Map<String, dynamic>> contents = [];
      
      // Add system instruction as first user message
      contents.add({
        'role': 'user',
        'parts': [{'text': _systemPrompt}],
      });
      
      contents.add({
        'role': 'model',
        'parts': [{'text': 'I understand. I am an expert aquaculture assistant specializing in shrimp farming. I will provide simple, practical advice to help farmers with diseases, cultivation practices, and farm management. How can I help you today?'}],
      });
      
      // Add conversation history if provided
      if (conversationHistory != null && conversationHistory.isNotEmpty) {
        for (var message in conversationHistory) {
          contents.add({
            'role': message['role'] == 'user' ? 'user' : 'model',
            'parts': [{'text': message['content']}],
          });
        }
      }
      
      // Add current user message
      contents.add({
        'role': 'user',
        'parts': [{'text': userMessage}],
      });
      
      // Build request body
      final requestBody = {
        'contents': contents,
        'generationConfig': {
          'temperature': 0.7,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 1024,
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
          },
          {
            'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
          },
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
          },
        ],
      };
      
      // Make API request
      final url = Uri.parse('$_baseUrl/$_model:generateContent?key=$_apiKey');
      
      print('🤖 Sending request to Gemini API...');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );
      
      print('📡 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Extract text from response
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final candidate = data['candidates'][0];
          if (candidate['content'] != null && 
              candidate['content']['parts'] != null && 
              candidate['content']['parts'].isNotEmpty) {
            final text = candidate['content']['parts'][0]['text'];
            print('✅ Got response from Gemini: ${text.substring(0, text.length > 100 ? 100 : text.length)}...');
            return text;
          }
        }
        
        throw Exception('Invalid response format from Gemini API');
      } else if (response.statusCode == 429) {
        throw Exception('API rate limit reached. Please try again in a few moments.');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your configuration.');
      } else {
        print('❌ Error response: ${response.body}');
        throw Exception('Failed to get response from AI. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Gemini API Error: $e');
      if (e.toString().contains('SocketException') || 
          e.toString().contains('NetworkException')) {
        throw Exception('Network error. Please check your internet connection.');
      }
      rethrow;
    }
  }
  
  /// Quick test method to verify API connectivity
  Future<bool> testConnection() async {
    try {
      final response = await sendMessage(
        userMessage: 'Hello',
        conversationHistory: [],
      );
      return response.isNotEmpty;
    } catch (e) {
      print('❌ Connection test failed: $e');
      return false;
    }
  }
}
