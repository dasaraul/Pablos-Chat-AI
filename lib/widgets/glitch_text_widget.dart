import 'package:flutter/material.dart';
import 'dart:math';
import '../utils/app_theme.dart';

class GlitchTextWidget extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final bool isGlitching;
  final Duration glitchDuration;
  final double glitchIntensity;
  final bool autoGlitch;
  final Duration autoGlitchInterval;

  const GlitchTextWidget({
    super.key,
    required this.text,
    this.style,
    this.isGlitching = false,
    this.glitchDuration = const Duration(milliseconds: 150),
    this.glitchIntensity = 1.0,
    this.autoGlitch = false,
    this.autoGlitchInterval = const Duration(seconds: 5),
  });

  @override
  State<GlitchTextWidget> createState() => _GlitchTextWidgetState();
}

class _GlitchTextWidgetState extends State<GlitchTextWidget>
    with TickerProviderStateMixin {
  late AnimationController _glitchController;
  late AnimationController _autoGlitchController;
  late Animation<double> _offsetAnimation;
  late Animation<double> _opacityAnimation;
  
  String _glitchedText = '';
  bool _isCurrentlyGlitching = false;
  final Random _random = Random();

  // Glitch character set
  static const String _glitchChars = 
      '!@#\$%^&*()_+-=[]{}|;:,.<>?~`'
      'ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ'
      '0123456789'
      'アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン';

  @override
  void initState() {
    super.initState();
    _glitchedText = widget.text;
    
    _glitchController = AnimationController(
      duration: widget.glitchDuration,
      vsync: this,
    );

    _autoGlitchController = AnimationController(
      duration: widget.autoGlitchInterval,
      vsync: this,
    );

    _offsetAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glitchController,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: _glitchController,
      curve: Curves.easeInOut,
    ));

    _glitchController.addListener(_updateGlitchText);
    _glitchController.addStatusListener(_onGlitchStatusChanged);

    if (widget.autoGlitch) {
      _startAutoGlitch();
    }

    if (widget.isGlitching) {
      _startGlitch();
    }
  }

  void _startAutoGlitch() {
    _autoGlitchController.repeat();
    _autoGlitchController.addListener(() {
      if (_autoGlitchController.value == 0.0 && !_isCurrentlyGlitching) {
        _startGlitch();
      }
    });
  }

  void _startGlitch() {
    if (!_isCurrentlyGlitching) {
      _isCurrentlyGlitching = true;
      _glitchController.forward().then((_) {
        _glitchController.reverse();
      });
    }
  }

  void _updateGlitchText() {
    if (_glitchController.isAnimating) {
      setState(() {
        _glitchedText = _generateGlitchedText();
      });
    }
  }

  void _onGlitchStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      setState(() {
        _isCurrentlyGlitching = false;
        _glitchedText = widget.text;
      });
    }
  }

  String _generateGlitchedText() {
    final glitchLevel = _glitchController.value * widget.glitchIntensity;
    final chars = widget.text.split('');
    final result = StringBuffer();

    for (int i = 0; i < chars.length; i++) {
      if (_random.nextDouble() < glitchLevel * 0.3) {
        // Replace with random glitch character
        result.write(_glitchChars[_random.nextInt(_glitchChars.length)]);
      } else if (_random.nextDouble() < glitchLevel * 0.2) {
        // Duplicate character
        result.write(chars[i]);
        result.write(chars[i]);
      } else if (_random.nextDouble() < glitchLevel * 0.1) {
        // Skip character
        continue;
      } else {
        // Keep original character
        result.write(chars[i]);
      }
    }

    return result.toString();
  }

  @override
  void didUpdateWidget(GlitchTextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.text != oldWidget.text) {
      _glitchedText = widget.text;
    }
    
    if (widget.isGlitching != oldWidget.isGlitching) {
      if (widget.isGlitching) {
        _startGlitch();
      }
    }
    
    if (widget.autoGlitch != oldWidget.autoGlitch) {
      if (widget.autoGlitch) {
        _startAutoGlitch();
      } else {
        _autoGlitchController.stop();
      }
    }
  }

  @override
  void dispose() {
    _glitchController.dispose();
    _autoGlitchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_glitchController]),
      builder: (context, child) {
        return Stack(
          children: [
            // Red channel (offset left)
            if (_isCurrentlyGlitching)
              Transform.translate(
                offset: Offset(
                  -_offsetAnimation.value * 2 * widget.glitchIntensity,
                  _offsetAnimation.value * 1 * widget.glitchIntensity,
                ),
                child: Text(
                  _glitchedText,
                  style: (widget.style ?? const TextStyle()).copyWith(
                    color: AppTheme.cyberRed.withOpacity(
                      _opacityAnimation.value * 0.7,
                    ),
                  ),
                ),
              ),
            
            // Blue channel (offset right)
            if (_isCurrentlyGlitching)
              Transform.translate(
                offset: Offset(
                  _offsetAnimation.value * 2 * widget.glitchIntensity,
                  -_offsetAnimation.value * 1 * widget.glitchIntensity,
                ),
                child: Text(
                  _glitchedText,
                  style: (widget.style ?? const TextStyle()).copyWith(
                    color: AppTheme.hackerBlue.withOpacity(
                      _opacityAnimation.value * 0.7,
                    ),
                  ),
                ),
              ),
            
            // Main text
            Transform.translate(
              offset: _isCurrentlyGlitching
                  ? Offset(
                      (_random.nextDouble() - 0.5) * 2 * widget.glitchIntensity,
                      (_random.nextDouble() - 0.5) * 1 * widget.glitchIntensity,
                    )
                  : Offset.zero,
              child: Text(
                _glitchedText,
                style: widget.style,
              ),
            ),
          ],
        );
      },
    );
  }
}

// Preset glitch text widgets for common use cases
class GlitchTitle extends StatelessWidget {
  final String text;
  final bool autoGlitch;
  
  const GlitchTitle({
    super.key,
    required this.text,
    this.autoGlitch = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return GlitchTextWidget(
      text: text,
      autoGlitch: autoGlitch,
      style: const TextStyle(
        fontFamily: 'FiraCode',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppTheme.terminalGreen,
        letterSpacing: 1,
      ),
      glitchIntensity: 0.8,
      glitchDuration: const Duration(milliseconds: 200),
      autoGlitchInterval: const Duration(seconds: 8),
    );
  }
}

class GlitchSubtitle extends StatelessWidget {
  final String text;
  final bool autoGlitch;
  
  const GlitchSubtitle({
    super.key,
    required this.text,
    this.autoGlitch = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return GlitchTextWidget(
      text: text,
      autoGlitch: autoGlitch,
      style: const TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 14,
        color: AppTheme.matrixGreen,
        fontStyle: FontStyle.italic,
      ),
      glitchIntensity: 0.5,
      glitchDuration: const Duration(milliseconds: 100),
      autoGlitchInterval: const Duration(seconds: 12),
    );
  }
}

class GlitchButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool enabled;
  
  const GlitchButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.enabled = true,
  });
  
  @override
  State<GlitchButton> createState() => _GlitchButtonState();
}

class _GlitchButtonState extends State<GlitchButton> {
  bool _isGlitching = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enabled ? () {
        setState(() => _isGlitching = true);
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) setState(() => _isGlitching = false);
        });
        widget.onPressed();
      } : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: widget.enabled ? AppTheme.deepGray : AppTheme.carbonGray,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: widget.enabled 
                ? AppTheme.borderGreen 
                : AppTheme.borderGreen.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: GlitchTextWidget(
          text: widget.text,
          isGlitching: _isGlitching,
          style: TextStyle(
            fontFamily: 'FiraCode',
            fontSize: 12,
            color: widget.enabled 
                ? AppTheme.terminalGreen 
                : AppTheme.matrixGreen.withOpacity(0.5),
            fontWeight: FontWeight.w500,
          ),
          glitchIntensity: 0.6,
        ),
      ),
    );
  }
}