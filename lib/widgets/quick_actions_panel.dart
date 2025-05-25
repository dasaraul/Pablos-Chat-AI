import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/chat_provider.dart';
import '../utils/app_theme.dart';

class QuickActionsPanel extends StatelessWidget {
  const QuickActionsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.carbonGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderGreen, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.terminalGreen.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.flash_on,
                color: AppTheme.terminalGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Quick Actions',
                style: TextStyle(
                  color: AppTheme.terminalGreen,
                  fontFamily: 'FiraCode',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                'Tap to execute',
                style: TextStyle(
                  color: AppTheme.matrixGreen,
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Quick action buttons grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3.5,
            children: [
              _buildQuickActionButton(
                context,
                icon: Icons.cloud,
                label: 'Digital Ocean Help',
                command: 'Gw butuh bantuan dengan Digital Ocean droplet setup',
                color: AppTheme.terminalGreen,
              ),
              _buildQuickActionButton(
                context,
                icon: Icons.security,
                label: 'Cybersecurity Advice',
                command: 'Bisa kasih advice tentang cybersecurity defense?',
                color: AppTheme.cyberRed,
              ),
              _buildQuickActionButton(
                context,
                icon: Icons.web,
                label: 'Website Development',
                command: 'Bantuin gw dengan website development dong',
                color: AppTheme.hackerBlue,
              ),
              _buildQuickActionButton(
                context,
                icon: Icons.school,
                label: 'UNAS Academic',
                command: 'Gw punya pertanyaan tentang UNAS/UNASfest',
                color: AppTheme.matrixGreen,
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Additional quick commands
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildQuickChip(
                  context,
                  label: 'Server Troubleshoot',
                  command: 'Server gw bermasalah, bisa bantuin troubleshoot?',
                ),
                const SizedBox(width: 8),
                _buildQuickChip(
                  context,
                  label: 'Penetration Testing',
                  command: 'Gimana cara melakukan ethical penetration testing?',
                ),
                const SizedBox(width: 8),
                _buildQuickChip(
                  context,
                  label: 'Academic Research',
                  command: 'Bantuin gw dengan methodology research dong',
                ),
                const SizedBox(width: 8),
                _buildQuickChip(
                  context,
                  label: 'General Chat',
                  command: 'Hai Pablos! Gw pengen ngobrol aja nih',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String command,
    required Color color,
  }) {
    return FadeInUp(
      duration: const Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: () => _executeQuickAction(context, command),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.deepGray,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.ghostWhite,
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickChip(
    BuildContext context, {
    required String label,
    required String command,
  }) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 400),
      child: GestureDetector(
        onTap: () => _executeQuickAction(context, command),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlack,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderGreen, width: 1),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.terminalGreen,
              fontFamily: 'FiraCode',
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _executeQuickAction(BuildContext context, String command) {
    // Add haptic feedback
    // HapticFeedback.lightImpact(); // Uncomment if you want haptic feedback
    
    // Send the quick command
    context.read<ChatProvider>().sendQuickMessage(command);
  }
}