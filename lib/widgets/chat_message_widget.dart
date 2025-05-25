import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import '../models/chat_message.dart';
import '../utils/app_theme.dart';

class ChatMessageWidget extends StatefulWidget {
  final ChatMessage message;

  const ChatMessageWidget({
    super.key,
    required this.message,
  });

  @override
  State<ChatMessageWidget> createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onMessageTap() {
    HapticFeedback.lightImpact();
    // Add any tap functionality here
  }

  void _onMessageLongPress() {
    HapticFeedback.mediumImpact();
    _showMessageOptions();
  }

  void _showMessageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.carbonGray,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        side: BorderSide(color: AppTheme.borderGreen, width: 1),
      ),
      builder: (context) => _buildMessageOptionsSheet(),
    );
  }

  Widget _buildMessageOptionsSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.borderGreen,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Message Options',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.terminalGreen,
              fontFamily: 'FiraCode',
            ),
          ),
          const SizedBox(height: 16),
          _buildOptionTile(
            icon: Icons.copy,
            title: 'Copy Message',
            onTap: () {
              Clipboard.setData(ClipboardData(text: widget.message.text));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Message copied to clipboard'),
                  backgroundColor: AppTheme.terminalGreen,
                ),
              );
            },
          ),
          if (!widget.message.isUser)
            _buildOptionTile(
              icon: Icons.refresh,
              title: 'Regenerate Response',
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement regenerate functionality
              },
            ),
          _buildOptionTile(
            icon: Icons.info_outline,
            title: 'Message Info',
            onTap: () {
              Navigator.pop(context);
              _showMessageInfo();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.terminalGreen),
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.ghostWhite,
          fontFamily: 'JetBrainsMono',
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      hoverColor: AppTheme.deepGray,
    );
  }

  void _showMessageInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.carbonGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppTheme.borderGreen, width: 1),
        ),
        title: Text(
          'Message Information',
          style: const TextStyle(
            color: AppTheme.terminalGreen,
            fontFamily: 'FiraCode',
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Sender', widget.message.sender),
            _buildInfoRow('Type', widget.message.messageTypeLabel),
            _buildInfoRow('Time', widget.message.fullFormattedTime),
            _buildInfoRow('Status', widget.message.status.name.toUpperCase()),
            _buildInfoRow('Word Count', widget.message.wordCount.toString()),
            _buildInfoRow('Character Count', widget.message.characterCount.toString()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppTheme.terminalGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: AppTheme.matrixGreen,
                fontFamily: 'FiraCode',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppTheme.ghostWhite,
                fontFamily: 'JetBrainsMono',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: widget.message.isUser
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.message.isUser) ...[
                    _buildAvatar(),
                    const SizedBox(width: 12),
                  ],
                  Flexible(
                    flex: 7,
                    child: _buildMessageBubble(),
                  ),
                  if (widget.message.isUser) ...[
                    const SizedBox(width: 12),
                    _buildAvatar(),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.message.isUser ? AppTheme.deepGray : AppTheme.darkGreen,
        border: Border.all(
          color: widget.message.isUser 
              ? AppTheme.matrixGreen 
              : AppTheme.terminalGreen,
          width: 2,
        ),
        boxShadow: _isHovered
            ? [
                BoxShadow(
                  color: (widget.message.isUser 
                      ? AppTheme.matrixGreen 
                      : AppTheme.terminalGreen).withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Icon(
        widget.message.isUser ? Icons.person : Icons.psychology_alt,
        color: widget.message.isUser 
            ? AppTheme.matrixGreen 
            : AppTheme.terminalGreen,
        size: 20,
      ),
    );
  }

  Widget _buildMessageBubble() {
    return GestureDetector(
      onTap: _onMessageTap,
      onLongPress: _onMessageLongPress,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.message.isUser ? AppTheme.deepGray : AppTheme.carbonGray,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: widget.message.isUser 
                ? const Radius.circular(16) 
                : const Radius.circular(4),
            bottomRight: widget.message.isUser 
                ? const Radius.circular(4) 
                : const Radius.circular(16),
          ),
          border: Border.all(
            color: widget.message.isUser 
                ? AppTheme.matrixGreen.withOpacity(0.3) 
                : AppTheme.borderGreen,
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: (widget.message.isUser 
                        ? AppTheme.matrixGreen 
                        : AppTheme.terminalGreen).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message Header
            if (!widget.message.isUser) ...[
              Row(
                children: [
                  Text(
                    widget.message.sender,
                    style: const TextStyle(
                      color: AppTheme.terminalGreen,
                      fontFamily: 'FiraCode',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.message.messageTypeIcon,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Spacer(),
                  Text(
                    widget.message.formattedTime,
                    style: const TextStyle(
                      color: AppTheme.matrixGreen,
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Message Content
            SelectableText(
              widget.message.text,
              style: TextStyle(
                color: widget.message.isUser 
                    ? AppTheme.ghostWhite 
                    : AppTheme.ghostWhite,
                fontFamily: 'JetBrainsMono',
                fontSize: 14,
                height: 1.4,
              ),
            ),

            // Message Footer for User Messages
            if (widget.message.isUser) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.message.formattedTime,
                    style: const TextStyle(
                      color: AppTheme.matrixGreen,
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    widget.message.status == MessageStatus.sent
                        ? Icons.check
                        : widget.message.status == MessageStatus.delivered
                            ? Icons.done_all
                            : Icons.schedule,
                    color: AppTheme.matrixGreen,
                    size: 12,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}