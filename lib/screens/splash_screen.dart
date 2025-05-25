import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../utils/app_theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _typewriterController;
  late AnimationController _glitchController;
  String _displayText = '';
  final String _fullText = 'PABLOS > Initializing AI System...';
  int _currentIndex = 0;

  final List<String> _bootSequence = [
    '[OK] Loading Neural Networks...',
    '[OK] Connecting to Digital Ocean...',
    '[OK] Initializing Cybersecurity Protocols...',
    '[OK] Loading UNAS Database...',
    '[OK] Activating Tama The God Mode...',
    '[READY] PABLOS System Online!',
  ];

  @override
  void initState() {
    super.initState();
    _typewriterController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _startTypewriterEffect();
  }

  void _startTypewriterEffect() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    for (int i = 0; i < _fullText.length; i++) {
      if (mounted) {
        setState(() {
          _displayText = _fullText.substring(0, i + 1);
        });
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }

    await Future.delayed(const Duration(milliseconds: 1000));
    _startBootSequence();
  }

  void _startBootSequence() async {
    for (String sequence in _bootSequence) {
      if (mounted) {
        setState(() {
          _currentIndex = _bootSequence.indexOf(sequence);
        });
        await Future.delayed(const Duration(milliseconds: 800));
      }
    }

    await Future.delayed(const Duration(milliseconds: 1000));
    _navigateToHome();
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 1000),
      ),
    );
  }

  @override
  void dispose() {
    _typewriterController.dispose();
    _glitchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.terminalGradient,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Spacer(flex: 2),
                
                // Main Logo/Title
                FadeInDown(
                  duration: const Duration(milliseconds: 1000),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.terminalGreen,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.terminalGreen.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.terminal,
                          size: 64,
                          color: AppTheme.terminalGreen,
                        ),
                      ),
                      const SizedBox(height: 24),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'PABLOS',
                              style: TextStyle(
                                fontFamily: 'FiraCode',
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.terminalGreen,
                                letterSpacing: 2,
                              ),
                            ),
                            TextSpan(
                              text: '\n"Tama The God"',
                              style: TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 16,
                                color: AppTheme.matrixGreen,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 1),

                // Typewriter Effect
                FadeInUp(
                  duration: const Duration(milliseconds: 1500),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: AppTheme.hackerBorder,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: AppTheme.cyberRed,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.yellow,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: AppTheme.terminalGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              'terminal',
                              style: TextStyle(
                                fontFamily: 'FiraCode',
                                fontSize: 12,
                                color: AppTheme.matrixGreen,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _displayText,
                          style: const TextStyle(
                            fontFamily: 'FiraCode',
                            fontSize: 14,
                            color: AppTheme.ghostWhite,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...List.generate(
                          _currentIndex + 1,
                          (index) => index < _bootSequence.length
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    _bootSequence[index],
                                    style: TextStyle(
                                      fontFamily: 'FiraCode',
                                      fontSize: 12,
                                      color: _bootSequence[index].contains('[OK]')
                                          ? AppTheme.terminalGreen
                                          : _bootSequence[index]
                                                  .contains('[READY]')
                                              ? AppTheme.hackerBlue
                                              : AppTheme.ghostWhite,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        if (_displayText.isNotEmpty)
                          Pulse(
                            infinite: true,
                            duration: const Duration(milliseconds: 1000),
                            child: const Text(
                              '█',
                              style: TextStyle(
                                fontFamily: 'FiraCode',
                                fontSize: 14,
                                color: AppTheme.terminalGreen,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // Loading Animation
                FadeInUp(
                  duration: const Duration(milliseconds: 2000),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 200,
                        child: LinearProgressIndicator(
                          backgroundColor: AppTheme.deepGray,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.terminalGreen,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Accessing secured AI protocols...',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12,
                          color: AppTheme.matrixGreen,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}