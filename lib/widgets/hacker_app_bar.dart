import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/chat_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_theme.dart';
import '../screens/settings_screen.dart';

class HackerAppBar extends StatefulWidget {
  const HackerAppBar({super.key});

  @override
  State<HackerAppBar> createState() => _HackerAppBarState();
}

class _HackerAppBarState extends State<HackerAppBar>
    with TickerProviderStateMixin {
  late AnimationController _glitchController;
  late AnimationController _statusController;
  bool _isGlitching = false;

  @override
  void initState() {
    super.initState();
    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _statusController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _statusController.repeat();
    _startRandomGlitches();
  }

  void _startRandomGlitches() {
    Future.delayed(Duration(seconds: 5 + (DateTime.now().second % 10)), () {
      if (mounted) {
        _triggerGlitch();
        _startRandomGlitches();
      }
    });
  }

  void _triggerGlitch() {
    setState(() => _isGlitching = true);
    _glitchController.forward().then((_) {
      _glitchController.reverse().then((_) {
        if (mounted) setState(() => _isGlitching = false);
      });
    });
  }

  @override
  void dispose() {
    _glitchController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        color: AppTheme.carbonGray,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderGreen, width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              // Top row with window controls and system info
              _buildTopRow(),
              const SizedBox(height: 8),
              // Main app bar content
              _buildMainContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      children: [
        // Terminal window controls
        _buildWindowControls(),
        const Spacer(),
        // System status
        _buildSystemStatus(),
      ],
    );
  }

  Widget _buildWindowControls() {
    return Row(
      children: [
        _buildControlButton(Colors.red, Icons.close, () {
          // Show exit confirmation
          _showExitDialog();
        }),
        const SizedBox(width: 8),
        _buildControlButton(Colors.yellow, Icons.minimize, () {
          // Minimize functionality
        }),
        const SizedBox(width: 8),
        _buildControlButton(AppTheme.terminalGreen, Icons.crop_square, () {
          // Maximize functionality
        }),
      ],
    );
  }

  Widget _buildControlButton(Color color, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Icon(
          icon,
          color: Colors.black,
          size: 10,
        ),
      ),
    );
  }

  Widget _buildSystemStatus() {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return Row(
          children: [
            // Connection status
            AnimatedBuilder(
              animation: _statusController,
              builder: (context, child) {
                return Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: chatProvider.isConnected
                        ? AppTheme.terminalGreen
                        : AppTheme.cyberRed,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (chatProvider.isConnected
                                ? AppTheme.terminalGreen
                                : AppTheme.cyberRed)
                            .withOpacity(_statusController.value),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            Text(
              chatProvider.isConnected ? 'ONLINE' : 'OFFLINE',
              style: const TextStyle(
                color: AppTheme.matrixGreen,
                fontFamily: 'FiraCode',
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMainContent() {
    return Row(
      children: [
        // PABLOS Logo and Title
        Expanded(child: _buildTitle()),
        // Action buttons
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildTitle() {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return GestureDetector(
          onTap: _triggerGlitch,
          child: Row(
            children: [
              // Animated logo
              FadeInLeft(
                duration: const Duration(milliseconds: 1000),
                child: Container(
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
                        color: AppTheme.terminalGreen.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.terminal,
                    color: AppTheme.terminalGreen,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Title with glitch effect
              Expanded(
                child: AnimatedBuilder(
                  animation: _glitchController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: _isGlitching
                          ? Offset(
                              (_glitchController.value - 0.5) * 4,
                              (_glitchController.value - 0.5) * 2,
                            )
                          : Offset.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isGlitching ? 'P4BL05' : 'PABLOS',
                            style: TextStyle(
                              fontFamily: 'FiraCode',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _isGlitching
                                  ? AppTheme.cyberRed
                                  : AppTheme.terminalGreen,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            '"Tama The God" AI System',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 10,
                              color: _isGlitching
                                  ? AppTheme.hackerBlue
                                  : AppTheme.matrixGreen,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return Row(
          children: [
            // Message counter
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.deepGray,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderGreen, width: 1),
              ),
              child: Text(
                '${chatProvider.messageCount}',
                style: const TextStyle(
                  color: AppTheme.terminalGreen,
                  fontFamily: 'FiraCode',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            
            // Clear chat button
            _buildActionButton(
              icon: Icons.refresh,
              onTap: () => _showClearChatDialog(),
              tooltip: 'Clear Chat',
            ),
            
            // Settings button
            _buildActionButton(
              icon: Icons.settings,
              onTap: () => _openSettings(),
              tooltip: 'Settings',
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.deepGray,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderGreen, width: 1),
          ),
          child: Icon(
            icon,
            color: AppTheme.terminalGreen,
            size: 18,
          ),
        ),
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.carbonGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppTheme.borderGreen, width: 1),
        ),
        title: const Text(
          'Exit PABLOS?',
          style: TextStyle(
            color: AppTheme.terminalGreen,
            fontFamily: 'FiraCode',
          ),
        ),
        content: const Text(
          'Are you sure you want to terminate the AI session?',
          style: TextStyle(
            color: AppTheme.ghostWhite,
            fontFamily: 'JetBrainsMono',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.matrixGreen),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Add exit functionality
            },
            child: const Text(
              'Exit',
              style: TextStyle(color: AppTheme.cyberRed),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.carbonGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppTheme.borderGreen, width: 1),
        ),
        title: const Text(
          'Clear Chat History?',
          style: TextStyle(
            color: AppTheme.terminalGreen,
            fontFamily: 'FiraCode',
          ),
        ),
        content: const Text(
          'This will delete all conversation history. This action cannot be undone.',
          style: TextStyle(
            color: AppTheme.ghostWhite,
            fontFamily: 'JetBrainsMono',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.matrixGreen),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ChatProvider>().clearChat();
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppTheme.cyberRed),
            ),
          ),
        ],
      ),
    );
  }

  void _openSettings() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SettingsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}