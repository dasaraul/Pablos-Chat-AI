import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/chat_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/chat_message_widget.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/hacker_app_bar.dart';
import '../widgets/quick_actions_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _showQuickActions = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().initializeChat();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      context.read<ChatProvider>().sendMessage(message);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.terminalGradient,
        child: Column(
          children: [
            // Custom Hacker App Bar
            const HackerAppBar(),

            // Chat Messages
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  return Column(
                    children: [
                      // Quick Actions Panel
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: _showQuickActions ? 120 : 0,
                        child: _showQuickActions
                            ? const QuickActionsPanel()
                            : const SizedBox(),
                      ),

                      // Chat List
                      Expanded(
                        child: chatProvider.messages.isEmpty
                            ? _buildWelcomeScreen()
                            : ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.all(16),
                                itemCount: chatProvider.messages.length +
                                    (chatProvider.isTyping ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index < chatProvider.messages.length) {
                                    return FadeInUp(
                                      duration: const Duration(milliseconds: 300),
                                      delay: Duration(milliseconds: index * 100),
                                      child: ChatMessageWidget(
                                        message: chatProvider.messages[index],
                                      ),
                                    );
                                  } else {
                                    return const TypingIndicator();
                                  }
                                },
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Message Input
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    final welcomeMessages = [
      "Halo bestie! Gw Pablos, literally siap bantuin elu anything!",
      "From droplet setup sampe curhat session - what's up?",
      "Gw dan bos gw Tama ready to help dengan segala macem!"
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          
          // Welcome Avatar
          FadeInDown(
            duration: const Duration(milliseconds: 1000),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.terminalGreen,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.terminalGreen.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
                gradient: const RadialGradient(
                  colors: [
                    AppTheme.darkGreen,
                    AppTheme.primaryBlack,
                  ],
                ),
              ),
              child: const Icon(
                Icons.psychology_alt,
                size: 60,
                color: AppTheme.terminalGreen,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Welcome Title
          FadeInUp(
            duration: const Duration(milliseconds: 1200),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'PABLOS AI\n',
                    style: TextStyle(
                      fontFamily: 'FiraCode',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.terminalGreen,
                      letterSpacing: 1,
                    ),
                  ),
                  TextSpan(
                    text: '"Tama The God" System',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 14,
                      color: AppTheme.matrixGreen,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Welcome Messages
          ...welcomeMessages.asMap().entries.map((entry) {
            return FadeInLeft(
              duration: const Duration(milliseconds: 800),
              delay: Duration(milliseconds: 1500 + (entry.key * 300)),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.hackerBorder,
                child: Row(
                  children: [
                    const Text(
                      '> ',
                      style: TextStyle(
                        fontFamily: 'FiraCode',
                        color: AppTheme.terminalGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 14,
                          color: AppTheme.ghostWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          const SizedBox(height: 32),

          // Capabilities Grid
          FadeInUp(
            duration: const Duration(milliseconds: 1000),
            delay: const Duration(milliseconds: 2500),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _buildCapabilityCard(
                  icon: Icons.cloud,
                  title: 'Digital Ocean',
                  subtitle: 'VPS Expert',
                ),
                _buildCapabilityCard(
                  icon: Icons.security,
                  title: 'Cybersecurity',
                  subtitle: 'Defense Pro',
                ),
                _buildCapabilityCard(
                  icon: Icons.web,
                  title: 'Web Dev',
                  subtitle: 'Full Stack',
                ),
                _buildCapabilityCard(
                  icon: Icons.school,
                  title: 'Academic',
                  subtitle: 'UNAS FAQ',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapabilityCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      decoration: AppTheme.hackerBorder,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: AppTheme.terminalGreen,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'FiraCode',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.terminalGreen,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              color: AppTheme.matrixGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.carbonGray,
        border: Border(
          top: BorderSide(color: AppTheme.borderGreen, width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Quick Actions Button
            IconButton(
              onPressed: () {
                setState(() {
                  _showQuickActions = !_showQuickActions;
                });
              },
              icon: Icon(
                _showQuickActions ? Icons.close : Icons.apps,
                color: AppTheme.terminalGreen,
              ),
            ),

            // Message Input Field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlack,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.borderGreen, width: 1),
                ),
                child: TextField(
                  controller: _messageController,
                  focusNode: _focusNode,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    color: AppTheme.ghostWhite,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: const TextStyle(
                      color: AppTheme.matrixGreen,
                      fontFamily: 'JetBrainsMono',
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    prefixIcon: const Icon(
                      Icons.terminal,
                      color: AppTheme.terminalGreen,
                      size: 20,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                  textInputAction: TextInputAction.send,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Send Button
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.darkGreen, AppTheme.terminalGreen],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.terminalGreen.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(
                  Icons.send,
                  color: AppTheme.primaryBlack,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}