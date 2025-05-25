class AppConstants {
  // App Information
  static const String appName = 'PABLOS';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Tama The God AI Assistant';
  static const String author = 'Tama The God';
  
  // AI Agent Configuration
  static const String agentId = '6c58e25c-3913-11f0-bf8f-4e013e2ddde4';
  static const String chatbotId = 'SKmeFU5N3XgR9bdQ16Nwl86jsj2df73Q';
  static const String baseUrl = 'https://wnkqkhbxixel3rjeb66derpx.agents.do-ai.run';
  
  // API Endpoints
  static const String chatEndpoint = '/api/chat';
  static const String statusEndpoint = '/api/status';
  static const String configEndpoint = '/api/config';
  
  // Storage Keys
  static const String themeKey = 'hacker_theme_mode';
  static const String fontSizeKey = 'font_size_multiplier';
  static const String chatHistoryKey = 'chat_history';
  static const String settingsKey = 'app_settings';
  static const String userPrefsKey = 'user_preferences';
  
  // Animation Durations
  static const int splashDuration = 3000;
  static const int typingDelay = 1500;
  static const int messageAnimationDuration = 300;
  static const int glitchAnimationDuration = 150;
  static const int scanlineAnimationDuration = 3000;
  
  // UI Constants
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;
  static const double buttonHeight = 48.0;
  static const double avatarSize = 40.0;
  static const double iconSize = 24.0;
  
  // Chat Configuration
  static const int maxMessageLength = 5000;
  static const int maxChatHistory = 1000;
  static const int typingIndicatorTimeout = 30;
  static const int connectionTimeout = 30;
  
  // PABLOS Personality Responses
  static const List<String> openingMessages = [
    "Halo bestie! Gw Pablos, literally siap bantuin elu anything! From droplet setup sampe curhat session - what's up?",
    "Wassup! Butuh bantuan technical, mau diskusi UNAS/UNASfest, or just pengen ngobrol? Gw dan bos gw Tama ready to help!",
    "Hai there! Gw your digital companion yang bisa handle everything - server issues, academic stuff, or kalo elu butuh someone to talk to. Spill!",
    "Hello! Dari cybersecurity defense sampe website optimization, from VPS troubleshooting sampe life advice - literally anything, just hit me up!"
  ];
  
  static const List<String> errorMessages = [
    "Wah sorry bestie! Gw lagi ada technical issues nih. Bos gw Tama lagi fixing the connection. Coba tanya lagi in a bit ya!",
    "Hmm, connection ke AI system gw lagi unstable nih. Literally kayak server lagi overload. Give me a sec to reconnect!",
    "Oops! Gw lagi experiencing some glitches. This is what happens when you're dealing with advanced AI systems, whichis sometimes unpredictable!",
    "Technical difficulties detected! Gw dan bos gw Tama working on it. Meanwhile, bisa coba restart the conversation atau wait a moment?"
  ];
  
  static const List<String> loadingMessages = [
    'Processing neural networks...',
    'Accessing knowledge base...',
    'Consulting with Tama...',
    'Generating response...',
    'Optimizing answer...',
    'Initializing AI protocols...',
    'Loading expertise modules...',
    'Connecting to Digital Ocean...',
    'Activating cybersecurity mode...',
    'Scanning academic database...',
  ];
  
  // Quick Action Commands
  static const Map<String, String> quickActions = {
    'Digital Ocean Help': 'Gw butuh bantuan dengan Digital Ocean droplet setup',
    'Cybersecurity Advice': 'Bisa kasih advice tentang cybersecurity defense?',
    'Website Development': 'Bantuin gw dengan website development dong',
    'UNAS Academic': 'Gw punya pertanyaan tentang UNAS/UNASfest',
    'Server Troubleshoot': 'Server gw bermasalah, bisa bantuin troubleshoot?',
    'Penetration Testing': 'Gimana cara melakukan ethical penetration testing?',
    'Academic Research': 'Bantuin gw dengan methodology research dong',
    'General Chat': 'Hai Pablos! Gw pengen ngobrol aja nih',
  };
  
  // Hacker Terminal Commands
  static const List<String> terminalCommands = [
    'sudo pablos --init',
    'nmap -sV target_system',
    'ssh root@pablos.ai',
    'docker run -d pablos/ai',
    'git clone https://github.com/tama/pablos',
    'python3 pablos_ai.py --mode=expert',
    'curl -X POST https://api.pablos.ai/chat',
    'systemctl status pablos.service',
  ];
  
  // System Status Messages
  static const Map<String, String> systemStatus = {
    'online': 'SYSTEM OPERATIONAL',
    'offline': 'CONNECTION LOST',
    'connecting': 'ESTABLISHING LINK',
    'error': 'SYSTEM ERROR',
    'maintenance': 'MAINTENANCE MODE',
    'updating': 'UPDATING PROTOCOLS',
  };
  
  // File Export Settings
  static const String exportFileName = 'pablos_chat_history';
  static const String exportFileExtension = '.json';
  static const String exportDateFormat = 'yyyy-MM-dd_HH-mm-ss';
  
  // Validation Rules
  static const int minMessageLength = 1;
  static const int maxUsernameLength = 50;
  static const int maxExportFileSize = 10 * 1024 * 1024; // 10MB
  
  // Feature Flags
  static const bool enableMatrixRain = true;
  static const bool enableGlitchEffects = true;
  static const bool enableHapticFeedback = true;
  static const bool enableAnalytics = false;
  static const bool enableDebugMode = true;
  
  // Accessibility
  static const double minFontSize = 12.0;
  static const double maxFontSize = 24.0;
  static const double defaultFontSizeMultiplier = 1.0;
  
  // Network Configuration
  static const int maxRetryAttempts = 3;
  static const int retryDelay = 2000; // milliseconds
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'PABLOS-Mobile/1.0.0',
  };
}