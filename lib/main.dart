import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/chat_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const PABLOSApp());
}

class PABLOSApp extends StatelessWidget {
  const PABLOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style for hacker theme
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0A0A0A),
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return MaterialApp(
      title: 'PABLOS - Tama The God',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkHackerTheme,
      home: const SplashScreen(),
      routes: {
        '/chat': (context) => const ChatScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  String _currentText = '';
  final String _fullText = 'INITIALIZING PABLOS SYSTEM...';
  int _textIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startTypewriterEffect();
    _navigateToChat();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _animationController.forward();
  }

  void _startTypewriterEffect() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _typeNextCharacter();
    });
  }

  void _typeNextCharacter() {
    if (_textIndex < _fullText.length) {
      setState(() {
        _currentText += _fullText[_textIndex];
        _textIndex++;
      });
      
      Future.delayed(const Duration(milliseconds: 80), () {
        _typeNextCharacter();
      });
    }
  }

  void _navigateToChat() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/chat');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF001122),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Hacker-style logo
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF00FF41),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00FF41).withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Text(
                          'PABLOS',
                          style: TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00FF41),
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Subtitle
                      const Text(
                        'TAMA THE GOD',
                        style: TextStyle(
                          fontFamily: 'Courier',
                          fontSize: 16,
                          color: Color(0xFF00FFFF),
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Typewriter text
                      Container(
                        height: 30,
                        child: Text(
                          '$_currentText${_textIndex < _fullText.length ? '█' : ''}',
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 14,
                            color: Color(0xFF00FF41),
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Loading indicator
                      Container(
                        width: 200,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: const LinearProgressIndicator(
                          backgroundColor: Color(0xFF1A1A1A),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF00FF41),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}