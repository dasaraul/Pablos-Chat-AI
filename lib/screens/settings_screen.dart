import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/theme_provider.dart';
import '../providers/chat_provider.dart';
import '../utils/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _scanlineController;

  @override
  void initState() {
    super.initState();
    _scanlineController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _scanlineController.repeat();
  }

  @override
  void dispose() {
    _scanlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.terminalGradient,
        child: SafeArea(
          child: Column(
            children: [
              // Custom Header
              _buildHeader(),
              
              // Settings Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('SYSTEM CONFIGURATION'),
                      _buildThemeSettings(),
                      const SizedBox(height: 24),
                      
                      _buildSectionTitle('INTERFACE SETTINGS'),
                      _buildInterfaceSettings(),
                      const SizedBox(height: 24),
                      
                      _buildSectionTitle('CHAT PREFERENCES'),
                      _buildChatSettings(),
                      const SizedBox(height: 24),
                      
                      _buildSectionTitle('SYSTEM STATUS'),
                      _buildSystemInfo(),
                      const SizedBox(height: 24),
                      
                      _buildSectionTitle('ADVANCED OPTIONS'),
                      _buildAdvancedSettings(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.carbonGray,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderGreen, width: 1),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.deepGray,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderGreen, width: 1),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppTheme.terminalGreen,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Animated scanline effect
          Expanded(
            child: Stack(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SYSTEM SETTINGS',
                      style: TextStyle(
                        color: AppTheme.terminalGreen,
                        fontFamily: 'FiraCode',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      'Configure PABLOS parameters',
                      style: TextStyle(
                        color: AppTheme.matrixGreen,
                        fontFamily: 'JetBrainsMono',
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                
                // Animated scanline
                AnimatedBuilder(
                  animation: _scanlineController,
                  builder: (context, child) {
                    return Positioned(
                      top: _scanlineController.value * 40,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppTheme.terminalGreen.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 20,
              color: AppTheme.terminalGreen,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.terminalGreen,
                fontFamily: 'FiraCode',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSettings() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.hackerBorder,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Theme Configuration',
                  style: TextStyle(
                    color: AppTheme.ghostWhite,
                    fontFamily: 'JetBrainsMono',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Theme selector
                DropdownButtonFormField<HackerThemeMode>(
                  value: themeProvider.currentTheme,
                  decoration: const InputDecoration(
                    labelText: 'Color Scheme',
                    prefixIcon: Icon(Icons.palette, color: AppTheme.terminalGreen),
                  ),
                  dropdownColor: AppTheme.carbonGray,
                  items: HackerThemeMode.values.map((theme) {
                    return DropdownMenuItem(
                      value: theme,
                      child: Text(
                        themeProvider.availableThemes[theme.index],
                        style: const TextStyle(
                          color: AppTheme.ghostWhite,
                          fontFamily: 'JetBrainsMono',
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (theme) {
                    if (theme != null) {
                      themeProvider.changeTheme(theme);
                    }
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Theme toggles
                _buildSwitchTile(
                  title: 'Glow Effects',
                  subtitle: 'Enable terminal glow animations',
                  value: themeProvider.isGlowEnabled,
                  onChanged: (value) => themeProvider.toggleGlow(),
                  icon: Icons.auto_awesome,
                ),
                
                _buildSwitchTile(
                  title: 'Animations',
                  subtitle: 'Enable UI animations and transitions',
                  value: themeProvider.isAnimationsEnabled,
                  onChanged: (value) => themeProvider.toggleAnimations(),
                  icon: Icons.animation,
                ),
                
                _buildSwitchTile(
                  title: 'Matrix Rain',
                  subtitle: 'Background digital rain effect',
                  value: themeProvider.isMatrixRainEnabled,
                  onChanged: (value) => themeProvider.toggleMatrixRain(),
                  icon: Icons.grain,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInterfaceSettings() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return FadeInUp(
          duration: const Duration(milliseconds: 700),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.hackerBorder,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Interface Preferences',
                  style: TextStyle(
                    color: AppTheme.ghostWhite,
                    fontFamily: 'JetBrainsMono',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Font size slider
                Text(
                  'Font Size: ${(themeProvider.fontSizeMultiplier * 100).round()}%',
                  style: const TextStyle(
                    color: AppTheme.matrixGreen,
                    fontFamily: 'FiraCode',
                    fontSize: 12,
                  ),
                ),
                Slider(
                  value: themeProvider.fontSizeMultiplier,
                  min: 0.8,
                  max: 1.5,
                  divisions: 7,
                  activeColor: AppTheme.terminalGreen,
                  inactiveColor: AppTheme.deepGray,
                  onChanged: (value) {
                    themeProvider.setFontSizeMultiplier(value);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatSettings() {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return FadeInUp(
          duration: const Duration(milliseconds: 800),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.hackerBorder,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chat Configuration',
                  style: TextStyle(
                    color: AppTheme.ghostWhite,
                    fontFamily: 'JetBrainsMono',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildActionButton(
                  title: 'Export Chat History',
                  subtitle: 'Download conversation log',
                  icon: Icons.download,
                  onTap: () => chatProvider.exportChat(),
                ),
                
                const SizedBox(height: 12),
                
                _buildActionButton(
                  title: 'Clear All Messages',
                  subtitle: 'Reset conversation history',
                  icon: Icons.delete_forever,
                  onTap: () => _showClearConfirmation(),
                  isDestructive: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSystemInfo() {
    return Consumer2<ChatProvider, ThemeProvider>(
      builder: (context, chatProvider, themeProvider, child) {
        return FadeInUp(
          duration: const Duration(milliseconds: 900),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.hackerBorder,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'System Status',
                  style: TextStyle(
                    color: AppTheme.ghostWhite,
                    fontFamily: 'JetBrainsMono',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildStatusRow('Connection', chatProvider.isConnected ? 'ONLINE' : 'OFFLINE'),
                _buildStatusRow('Messages', '${chatProvider.messageCount}'),
                _buildStatusRow('Theme', themeProvider.currentThemeName),
                _buildStatusRow('Version', 'PABLOS v1.0.0'),
                _buildStatusRow('Agent ID', '6c58e25c-3913-11f0'),
                _buildStatusRow('Status', 'OPERATIONAL'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdvancedSettings() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.hackerBorder,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Advanced Configuration',
              style: TextStyle(
                color: AppTheme.ghostWhite,
                fontFamily: 'JetBrainsMono',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildActionButton(
              title: 'Reset to Defaults',
              subtitle: 'Restore all settings to default values',
              icon: Icons.restore,
              onTap: () => _showResetConfirmation(),
            ),
            
            const SizedBox(height: 12),
            
            _buildActionButton(
              title: 'Debug Mode',
              subtitle: 'Enable diagnostic information',
              icon: Icons.bug_report,
              onTap: () => _showDebugInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.terminalGreen, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.ghostWhite,
                    fontFamily: 'JetBrainsMono',
                    fontSize: 12,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.matrixGreen,
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.terminalGreen,
            activeTrackColor: AppTheme.darkGreen,
            inactiveThumbColor: AppTheme.deepGray,
            inactiveTrackColor: AppTheme.carbonGray,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.deepGray,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDestructive 
                ? AppTheme.cyberRed.withOpacity(0.3) 
                : AppTheme.borderGreen.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? AppTheme.cyberRed : AppTheme.terminalGreen,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDestructive ? AppTheme.cyberRed : AppTheme.ghostWhite,
                      fontFamily: 'JetBrainsMono',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.matrixGreen,
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.matrixGreen,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: AppTheme.matrixGreen,
                fontFamily: 'FiraCode',
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppTheme.ghostWhite,
                fontFamily: 'JetBrainsMono',
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.carbonGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppTheme.cyberRed, width: 1),
        ),
        title: const Text(
          'CONFIRM DELETION',
          style: TextStyle(
            color: AppTheme.cyberRed,
            fontFamily: 'FiraCode',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'This action will permanently delete all chat history. This cannot be undone.',
          style: TextStyle(
            color: AppTheme.ghostWhite,
            fontFamily: 'JetBrainsMono',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.matrixGreen)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ChatProvider>().clearChat();
            },
            child: const Text('DELETE', style: TextStyle(color: AppTheme.cyberRed)),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.carbonGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppTheme.borderGreen, width: 1),
        ),
        title: const Text(
          'Reset Settings',
          style: TextStyle(color: AppTheme.terminalGreen, fontFamily: 'FiraCode'),
        ),
        content: const Text(
          'Reset all settings to default values?',
          style: TextStyle(color: AppTheme.ghostWhite, fontFamily: 'JetBrainsMono'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.matrixGreen)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ThemeProvider>().resetToDefaults();
            },
            child: const Text('Reset', style: TextStyle(color: AppTheme.terminalGreen)),
          ),
        ],
      ),
    );
  }

  void _showDebugInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.carbonGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppTheme.borderGreen, width: 1),
        ),
        title: const Text(
          'Debug Information',
          style: TextStyle(color: AppTheme.terminalGreen, fontFamily: 'FiraCode'),
        ),
        content: const SingleChildScrollView(
          child: Text(
            'PABLOS Debug Console\n\n'
            'Agent ID: 6c58e25c-3913-11f0-bf8f-4e013e2ddde4\n'
            'Chatbot ID: SKmeFU5N3XgR9bdQ16Nwl86jsj2df73Q\n'
            'Base URL: https://wnkqkhbxixel3rjeb66derpx.agents.do-ai.run\n'
            'Flutter Version: 3.10.0+\n'
            'Build Mode: Debug\n'
            'Platform: Web/Mobile\n\n'
            'Memory Usage: Normal\n'
            'Network Status: Connected\n'
            'AI Service: Active\n\n'
            'Author: Tama The God\n'
            'Version: 1.0.0',
            style: TextStyle(
              color: AppTheme.ghostWhite,
              fontFamily: 'JetBrainsMono',
              fontSize: 11,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppTheme.terminalGreen)),
          ),
        ],
      ),
    );
  }
}