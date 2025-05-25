import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/chat_message.dart';
import '../services/pablos_ai_service.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _isConnected = false;
  final PablosAIService _aiService = PablosAIService();

  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;
  bool get isConnected => _isConnected;

  // PABLOS Opening Messages
  final List<String> _openingMessages = [
    "Halo bestie! Gw Pablos, literally siap bantuin elu anything! From droplet setup sampe curhat session - what's up?",
    "Wassup! Butuh bantuan technical, mau diskusi UNAS/UNASfest, or just pengen ngobrol? Gw dan bos gw Tama ready to help!",
    "Hai there! Gw your digital companion yang bisa handle everything - server issues, academic stuff, or kalo elu butuh someone to talk to. Spill!",
    "Hello! Dari cybersecurity defense sampe website optimization, from VPS troubleshooting sampe life advice - literally anything, just hit me up!"
  ];

  void initializeChat() {
    _isConnected = true;
    
    // Add welcome message from PABLOS
    final welcomeMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _getRandomOpeningMessage(),
      isUser: false,
      timestamp: DateTime.now(),
      sender: 'PABLOS',
      messageType: MessageType.welcome,
    );
    
    _messages.add(welcomeMessage);
    notifyListeners();
  }

  String _getRandomOpeningMessage() {
    final random = DateTime.now().millisecond % _openingMessages.length;
    return _openingMessages[random];
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
      sender: 'User',
    );

    _messages.add(userMessage);
    _isTyping = true;
    notifyListeners();

    try {
      // Get AI response using the integrated chatbot
      final response = await _aiService.sendMessage(text);
      
      await Future.delayed(const Duration(milliseconds: 1500)); // Simulate typing
      
      final aiMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
        sender: 'PABLOS',
        messageType: _determineMessageType(response),
      );

      _messages.add(aiMessage);
    } catch (e) {
      // Fallback response if AI service fails
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: _getErrorResponse(text),
        isUser: false,
        timestamp: DateTime.now(),
        sender: 'PABLOS',
        messageType: MessageType.error,
      );

      _messages.add(errorMessage);
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }

  MessageType _determineMessageType(String response) {
    final lowercaseResponse = response.toLowerCase();
    
    if (lowercaseResponse.contains('digital ocean') || 
        lowercaseResponse.contains('droplet') ||
        lowercaseResponse.contains('vps')) {
      return MessageType.technical;
    } else if (lowercaseResponse.contains('cybersecurity') ||
               lowercaseResponse.contains('security') ||
               lowercaseResponse.contains('hack')) {
      return MessageType.security;
    } else if (lowercaseResponse.contains('unas') ||
               lowercaseResponse.contains('academic') ||
               lowercaseResponse.contains('university')) {
      return MessageType.academic;
    } else if (lowercaseResponse.contains('website') ||
               lowercaseResponse.contains('web dev') ||
               lowercaseResponse.contains('frontend')) {
      return MessageType.development;
    } else {
      return MessageType.general;
    }
  }

  String _getErrorResponse(String userMessage) {
    final errorResponses = [
      "Wah sorry bestie! Gw lagi ada technical issues nih. Bos gw Tama lagi fixing the connection. Coba tanya lagi in a bit ya!",
      "Hmm, connection ke AI system gw lagi unstable nih. Literally kayak server lagi overload. Give me a sec to reconnect!",
      "Oops! Gw lagi experiencing some glitches. This is what happens when you're dealing with advanced AI systems, whichis sometimes unpredictable!",
      "Technical difficulties detected! Gw dan bos gw Tama working on it. Meanwhile, bisa coba restart the conversation atau wait a moment?"
    ];
    
    final random = DateTime.now().millisecond % errorResponses.length;
    return errorResponses[random];
  }

  void clearChat() {
    _messages.clear();
    initializeChat();
  }

  void toggleConnection() {
    _isConnected = !_isConnected;
    notifyListeners();
  }

  // Quick action methods
  void sendQuickMessage(String message) {
    sendMessage(message);
  }

  void sendTechnicalHelp() {
    sendMessage("Gw butuh bantuan technical untuk Digital Ocean setup");
  }

  void sendSecurityAdvice() {
    sendMessage("Bisa kasih advice tentang cybersecurity defense?");
  }

  void sendAcademicHelp() {
    sendMessage("Bantuin gw dengan pertanyaan akademik UNAS dong");
  }

  void sendGeneralChat() {
    sendMessage("Hai Pablos! Gw pengen ngobrol aja nih");
  }

  // Advanced features
  void regenerateLastResponse() {
    if (_messages.isNotEmpty && !_messages.last.isUser) {
      _messages.removeLast();
      if (_messages.isNotEmpty && _messages.last.isUser) {
        final lastUserMessage = _messages.last.text;
        sendMessage(lastUserMessage);
      }
    }
  }

  void exportChat() {
    // TODO: Implement chat export functionality
    if (kDebugMode) {
      print('Exporting chat history...');
    }
  }

  List<ChatMessage> searchMessages(String query) {
    return _messages.where((message) {
      return message.text.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  int get messageCount => _messages.length;
  int get userMessageCount => _messages.where((m) => m.isUser).length;
  int get aiMessageCount => _messages.where((m) => !m.isUser).length;

  @override
  void dispose() {
    _messages.clear();
    super.dispose();
  }
}