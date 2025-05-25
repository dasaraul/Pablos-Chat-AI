import 'package:flutter/material.dart';
import 'dart:math';
import '../utils/app_theme.dart';

class MatrixRainWidget extends StatefulWidget {
  final bool isEnabled;
  final double opacity;
  final int columns;
  final double speed;

  const MatrixRainWidget({
    super.key,
    this.isEnabled = true,
    this.opacity = 0.1,
    this.columns = 20,
    this.speed = 1.0,
  });

  @override
  State<MatrixRainWidget> createState() => _MatrixRainWidgetState();
}

class _MatrixRainWidgetState extends State<MatrixRainWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<MatrixColumn> _columns;
  final Random _random = Random();

  // Matrix characters (Japanese katakana, numbers, symbols)
  static const String _matrixChars = 
      'アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン'
      '0123456789'
      '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: (50 / widget.speed).round()),
      vsync: this,
    );

    _initializeColumns();
    
    if (widget.isEnabled) {
      _controller.repeat();
    }
  }

  void _initializeColumns() {
    _columns = List.generate(widget.columns, (index) {
      return MatrixColumn(
        x: index,
        characters: [],
        speed: _random.nextDouble() * 2 + 1,
        maxLength: _random.nextInt(15) + 5,
      );
    });

    // Initialize some columns with characters
    for (var column in _columns) {
      if (_random.nextBool()) {
        _addCharacterToColumn(column);
      }
    }
  }

  void _addCharacterToColumn(MatrixColumn column) {
    if (column.characters.length < column.maxLength) {
      column.characters.add(MatrixCharacter(
        char: _matrixChars[_random.nextInt(_matrixChars.length)],
        y: 0.0,
        opacity: 1.0,
        isHead: column.characters.isEmpty,
      ));
    }
  }

  @override
  void didUpdateWidget(MatrixRainWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isEnabled != oldWidget.isEnabled) {
      if (widget.isEnabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
    
    if (widget.columns != oldWidget.columns) {
      _initializeColumns();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          _updateMatrix();
          return CustomPaint(
            painter: MatrixPainter(
              columns: _columns,
              opacity: widget.opacity,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }

  void _updateMatrix() {
    final size = MediaQuery.of(context).size;
    final columnWidth = size.width / widget.columns;
    final maxRows = (size.height / 20).ceil();

    for (var column in _columns) {
      // Update existing characters
      for (var i = column.characters.length - 1; i >= 0; i--) {
        var character = column.characters[i];
        character.y += character.isHead ? column.speed * 2 : column.speed;
        
        // Fade out trailing characters
        if (!character.isHead) {
          character.opacity -= 0.05;
        }
        
        // Remove characters that are off screen or fully faded
        if (character.y > maxRows + 5 || character.opacity <= 0) {
          column.characters.removeAt(i);
        }
      }

      // Update head character
      if (column.characters.isNotEmpty) {
        column.characters.first.isHead = true;
        
        // Update positions for trailing effect
        for (var i = 1; i < column.characters.length; i++) {
          column.characters[i].isHead = false;
        }
      }

      // Randomly add new characters to column
      if (_random.nextDouble() < 0.02 && column.characters.length < column.maxLength) {
        _addCharacterToColumn(column);
      }

      // Randomly change characters in column
      for (var character in column.characters) {
        if (_random.nextDouble() < 0.01) {
          character.char = _matrixChars[_random.nextInt(_matrixChars.length)];
        }
      }
    }
  }
}

class MatrixPainter extends CustomPainter {
  final List<MatrixColumn> columns;
  final double opacity;

  MatrixPainter({
    required this.columns,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final columnWidth = size.width / columns.length;
    const fontSize = 16.0;
    const charHeight = 20.0;

    for (var i = 0; i < columns.length; i++) {
      final column = columns[i];
      final x = i * columnWidth + columnWidth / 2;

      for (var character in column.characters) {
        final y = character.y * charHeight;
        
        if (y >= 0 && y <= size.height + charHeight) {
          final paint = TextPainter(
            text: TextSpan(
              text: character.char,
              style: TextStyle(
                fontFamily: 'FiraCode',
                fontSize: fontSize,
                color: character.isHead 
                    ? AppTheme.ghostWhite.withOpacity(opacity * character.opacity)
                    : AppTheme.terminalGreen.withOpacity(opacity * character.opacity * 0.7),
                fontWeight: character.isHead ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            textDirection: TextDirection.ltr,
          );
          
          paint.layout();
          paint.paint(
            canvas, 
            Offset(x - paint.width / 2, y),
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant MatrixPainter oldDelegate) {
    return true; // Always repaint for animation
  }
}

class MatrixColumn {
  final int x;
  final List<MatrixCharacter> characters;
  final double speed;
  final int maxLength;

  MatrixColumn({
    required this.x,
    required this.characters,
    required this.speed,
    required this.maxLength,
  });
}

class MatrixCharacter {
  String char;
  double y;
  double opacity;
  bool isHead;

  MatrixCharacter({
    required this.char,
    required this.y,
    required this.opacity,
    required this.isHead,
  });
}