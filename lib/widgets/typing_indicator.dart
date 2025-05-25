import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../utils/app_theme.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _dotController1;
  late AnimationController _dotController2;
  late AnimationController _dotController3;
  late AnimationController _glowController;

  late Animation<double> _dot1Animation;
  late Animation<double> _dot2Animation;
  late Animation<double> _dot3Animation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Individual dot controllers with staggered timing
    _dotController1 = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _dotController2 = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _dotController3 = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Glow effect controller
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Dot animations (scale effect)
    _dot1Animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _dotController1, curve: Curves.easeInOut),
    );
    _dot2Animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _dotController2, curve: Curves.easeInOut),
    );
    _dot3Animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _dotController3, curve: Curves.easeInOut),
    );

    // Glow animation
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() {
    // Start dot animations with staggered delays
    _dotController1.repeat(reverse: true);
    
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _dotController2.repeat(reverse: true);
    });
    
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _dotController3.repeat(reverse: true);
    });

    // Start glow animation
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _dotController1.dispose();
    _dotController2.dispose();
    _dotController3.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PABLOS Avatar
            _buildPablosAvatar(),
            const SizedBox(width: 12),
            
            // Typing Bubble
            Flexible(
              child: _buildTypingBubble(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPablosAvatar() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.darkGreen,
            border: Border.all(
              color: AppTheme.terminalGreen,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.terminalGreen.withOpacity(_glowAnimation.value * 0.5),
                blurRadius: 8 * _glowAnimation.value,
                spreadRadius: 2 * _glowAnimation.value,
              ),
            ],
          ),
          child: const Icon(
            Icons.psychology_alt,
            color: AppTheme.terminalGreen,
            size: 20,
          ),
        );
      },
    );
  }

  Widget _buildTypingBubble() {
    return AnimatedBuilder(
      animation: Listenable.merge([_glowAnimation]),
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.carbonGray,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(16),
            ),
            border: Border.all(
              color: AppTheme.borderGreen,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.terminalGreen.withOpacity(_glowAnimation.value * 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with PABLOS name and typing indicator
              Row(
                children: [
                  const Text(
                    'PABLOS',
                    style: TextStyle(
                      color: AppTheme.terminalGreen,
                      fontFamily: 'FiraCode',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '🤖',
                    style: TextStyle(fontSize: 12),
                  ),
                  const Spacer(),
                  _buildTypingText(),
                ],
              ),
              const SizedBox(height: 12),
              
              // Animated dots
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAnimatedDot(_dot1Animation, 0),
                  const SizedBox(width: 4),
                  _buildAnimatedDot(_dot2Animation, 200),
                  const SizedBox(width: 4),
                  _buildAnimatedDot(_dot3Animation, 400),
                  const SizedBox(width: 12),
                  _buildProcessingText(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTypingText() {
    return Pulse(
      infinite: true,
      duration: const Duration(milliseconds: 1000),
      child: const Text(
        'typing...',
        style: TextStyle(
          color: AppTheme.matrixGreen,
          fontFamily: 'JetBrainsMono',
          fontSize: 10,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildAnimatedDot(Animation<double> animation, int delay) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.terminalGreen.withOpacity(animation.value),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.terminalGreen.withOpacity(animation.value * 0.5),
                  blurRadius: 4 * animation.value,
                  spreadRadius: 1 * animation.value,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProcessingText() {
    final processingTexts = [
      'Processing neural networks...',
      'Accessing knowledge base...',
      'Consulting with Tama...',
      'Generating response...',
      'Optimizing answer...',
    ];

    return StreamBuilder<int>(
      stream: Stream.periodic(
        const Duration(milliseconds: 1500),
        (index) => index % processingTexts.length,
      ),
      builder: (context, snapshot) {
        final textIndex = snapshot.data ?? 0;
        return FadeTransition(
          opacity: _glowAnimation,
          child: Text(
            processingTexts[textIndex],
            style: const TextStyle(
              color: AppTheme.matrixGreen,
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      },
    );
  }
}