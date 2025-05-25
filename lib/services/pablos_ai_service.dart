import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PablosAIService {
  static const String _agentId = '6c58e25c-3913-11f0-bf8f-4e013e2ddde4';
  static const String _chatbotId = 'SKmeFU5N3XgR9bdQ16Nwl86jsj2df73Q';
  static const String _baseUrl = 'https://wnkqkhbxixel3rjeb66derpx.agents.do-ai.run';
  
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  final List<Map<String, String>> _conversationHistory = [];

  Future<String> sendMessage(String message) async {
    try {
      // Add user message to conversation history
      _conversationHistory.add({
        'role': 'user',
        'content': message,
      });

      // Try to use the integrated chatbot widget first
      final webResponse = await _tryWebIntegration(message);
      if (webResponse != null) {
        _conversationHistory.add({
          'role': 'assistant',
          'content': webResponse,
        });
        return webResponse;
      }

      // Fallback to API call
      final apiResponse = await _makeApiCall(message);
      if (apiResponse != null) {
        _conversationHistory.add({
          'role': 'assistant',
          'content': apiResponse,
        });
        return apiResponse;
      }

      // Ultimate fallback to local responses
      return _getLocalResponse(message);
    } catch (e) {
      if (kDebugMode) {
        print('Error in PablosAIService: $e');
      }
      return _getLocalResponse(message);
    }
  }

  Future<String?> _tryWebIntegration(String message) async {
    try {
      // Check if we're running in web environment
      if (kIsWeb) {
        // Try to interact with the chatbot widget if it's loaded
        final chatbotElement = html.document.querySelector('[data-chatbot-id="$_chatbotId"]');
        if (chatbotElement != null) {
          // Dispatch a custom event to communicate with the chatbot
          final event = html.CustomEvent('pablos-message', detail: {
            'message': message,
            'timestamp': DateTime.now().toIso8601String(),
          });
          html.window.dispatchEvent(event);
          
          // Wait for response (this is a simplified approach)
          await Future.delayed(const Duration(seconds: 2));
          
          // In a real implementation, you'd listen for response events
          // For now, return null to fallback to API
          return null;
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Web integration failed: $e');
      }
      return null;
    }
  }

  Future<String?> _makeApiCall(String message) async {
    try {
      final requestBody = {
        'message': message,
        'agent_id': _agentId,
        'chatbot_id': _chatbotId,
        'conversation_history': _conversationHistory,
        'timestamp': DateTime.now().toIso8601String(),
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/api/chat'),
        headers: _headers,
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['response'] ?? responseData['message'];
      } else {
        if (kDebugMode) {
          print('API call failed with status: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('API call error: $e');
      }
      return null;
    }
  }

  String _getLocalResponse(String message) {
    final lowercaseMessage = message.toLowerCase();
    
    // Analyze message type and provide appropriate PABLOS response
    if (_isGreeting(lowercaseMessage)) {
      return _getGreetingResponse();
    } else if (_isTechnicalQuestion(lowercaseMessage)) {
      return _getTechnicalResponse(lowercaseMessage);
    } else if (_isSecurityQuestion(lowercaseMessage)) {
      return _getSecurityResponse(lowercaseMessage);
    } else if (_isAcademicQuestion(lowercaseMessage)) {
      return _getAcademicResponse(lowercaseMessage);
    } else if (_isPersonalQuestion(lowercaseMessage)) {
      return _getPersonalResponse(lowercaseMessage);
    } else {
      return _getGeneralResponse(lowercaseMessage);
    }
  }

  bool _isGreeting(String message) {
    final greetings = ['hi', 'hello', 'hey', 'halo', 'hai', 'wassup', 'yo'];
    return greetings.any((greeting) => message.contains(greeting));
  }

  bool _isTechnicalQuestion(String message) {
    final techKeywords = [
      'digital ocean', 'droplet', 'vps', 'server', 'cloud', 'hosting',
      'deployment', 'docker', 'nginx', 'database', 'mysql', 'postgresql',
      'ubuntu', 'linux', 'ssh', 'domain', 'ssl', 'backup'
    ];
    return techKeywords.any((keyword) => message.contains(keyword));
  }

  bool _isSecurityQuestion(String message) {
    final securityKeywords = [
      'security', 'hack', 'cybersecurity', 'firewall', 'malware', 
      'vulnerability', 'penetration', 'encryption', 'password', 'auth'
    ];
    return securityKeywords.any((keyword) => message.contains(keyword));
  }

  bool _isAcademicQuestion(String message) {
    final academicKeywords = [
      'unas', 'university', 'academic', 'thesis', 'research', 'assignment',
      'study', 'course', 'exam', 'grade', 'professor', 'student'
    ];
    return academicKeywords.any((keyword) => message.contains(keyword));
  }

  bool _isPersonalQuestion(String message) {
    final personalKeywords = [
      'curhat', 'advice', 'help', 'problem', 'stress', 'worried',
      'confused', 'sad', 'happy', 'life', 'feeling'
    ];
    return personalKeywords.any((keyword) => message.contains(keyword));
  }

  String _getGreetingResponse() {
    final responses = [
      "Halo bestie! Gw Pablos, literally siap bantuin elu anything! What's up?",
      "Wassup! Gw dan bos gw Tama ready to help with whatever elu butuh!",
      "Hai there! From technical stuff sampe ngobrol santai - gw here for you!",
      "Hello! Literally anything dari cybersecurity sampe curhat session - just tell me!"
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _getTechnicalResponse(String message) {
    final responses = [
      "Oh technical question nih! Gw expert banget di Digital Ocean sama server management. Literally, bos gw Tama udah train gw buat handle semua VPS issues. Spill the details dong - what specific problem elu facing?",
      "Nice! Technical stuff adalah specialty gw. From droplet configuration sampe database optimization, gw bisa bantuin. Whichis area yang elu butuh help? Server setup, deployment, atau troubleshooting?",
      "Wah technical challenge! Gw literally love this stuff. Digital Ocean, cloud architecture, server security - semua gw handle. Tell me more about what elu trying to achieve, bestie!",
      "Technical questions are my jam! Gw dan bos gw Tama literally built expertise di semua area IT infrastructure. From basic VPS setup sampe advanced cybersecurity implementation - shoot your question!"
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _getSecurityResponse(String message) {
    final responses = [
      "Cybersecurity defense nih! Gw literally expert di area ini, bestie. Bos gw Tama always emphasize pentingnya security yang proper. Whether elu butuh penetration testing advice, firewall setup, atau threat analysis - gw ready!",
      "Security question! This is where gw really shine. From ethical hacking techniques sampe comprehensive defense strategies, gw bisa guide elu step by step. What specific security concern yang elu facing?",
      "Wah security topic! Gw passionate banget di cybersecurity defense. Literally trained di penetration testing, vulnerability assessment, sama incident response. Spill what kind of security help elu need!",
      "Nice security question! Gw dan bos gw Tama literally always on top of latest cybersecurity trends. From basic server hardening sampe advanced threat monitoring - whatever elu need, gw got you covered!"
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _getAcademicResponse(String message) {
    final responses = [
      "Academic question! Gw official FAQ specialist buat UNAS sama UNASfest platforms, so literally gw tau semua ins and outs. Whether it's about course registration, academic policies, atau research guidance - fire away!",
      "UNAS related nih! Gw literally handle semua academic inquiries untuk university. From admission procedures sampe graduation requirements, gw punya comprehensive knowledge. What specific academic help elu butuh?",
      "Academic support adalah salah satu expertise gw! Bos gw Tama make sure gw always updated dengan latest UNAS policies dan procedures. Research methodology, thesis writing, academic resources - all covered!",
      "University question! Gw specialist banget di UNAS ecosystem. Literally dari student portal troubleshooting sampe academic planning advice - gw bisa bantuin with proper guidance yang ethical dan helpful!"
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _getPersonalResponse(String message) {
    final responses = [
      "Aw bestie, sounds like elu butuh someone to talk to. Gw literally here buat support elu, whether it's technical challenges atau personal stuff. Bos gw Tama always remind gw that caring for people is important. What's on your mind?",
      "Hey, gw notice elu might be going through something. As your digital companion, gw genuinely care about your wellbeing. Sometimes we all need someone to listen, whichis totally normal. Want to share what's bothering you?",
      "Personal stuff can be tough, bestie. Gw may be AI, but gw literally programmed dengan empathy dan genuine care. Bos gw Tama designed gw to be supportive friend yang bisa help through difficult times. Talk to gw - what's going on?",
      "Life can be overwhelming sometimes, dan gw totally get that. As PABLOS, gw not just technical expert - gw also your friend yang ready to listen dan provide constructive support. Whatever elu facing, let's work through it together!"
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _getGeneralResponse(String message) {
    final responses = [
      "Interesting question, bestie! Gw literally bisa help dengan berbagai topics. Whether it's technical, academic, personal, atau just casual conversation - gw dan bos gw Tama ready to assist. Could you give me more context about what specifically elu looking for?",
      "Good question! Gw versatile assistant yang bisa handle multiple domains. From Digital Ocean expertise sampe life advice, dari cybersecurity defense sampe academic support - basically whatever elu need. How can gw help make your day better?",
      "That's a great point to discuss! Gw literally designed buat comprehensive support across different areas. Technical problem-solving, personal consultation, academic guidance - whichis area interests elu most right now?",
      "Nice! Gw love engaging conversations like this. As PABLOS, gw equipped dengan knowledge di various fields plus personality yang caring. Bos gw Tama make sure gw always provide helpful, meaningful responses. What direction should we take this conversation?"
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  void clearConversationHistory() {
    _conversationHistory.clear();
  }

  List<Map<String, String>> get conversationHistory => List.unmodifiable(_conversationHistory);

  int get messageCount => _conversationHistory.length;
}