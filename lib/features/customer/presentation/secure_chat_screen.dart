import 'package:book_me_mobile_app/features/shared/domain/entities/provider.dart';
import 'package:flutter/material.dart';

final Map<String, List<_ChatMessage>> _chatStore =
    <String, List<_ChatMessage>>{};

class SecureChatScreen extends StatefulWidget {
  const SecureChatScreen({
    required this.provider,
    required this.customerId,
    super.key,
  });

  final Provider provider;
  final String customerId;

  @override
  State<SecureChatScreen> createState() => _SecureChatScreenState();
}

class _SecureChatScreenState extends State<SecureChatScreen> {
  final _messageController = TextEditingController();
  late final String _conversationKey;
  late List<_ChatMessage> _messages;

  String _targetLanguage = 'English';

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _conversationKey = '${widget.customerId}:${widget.provider.id}';
    _messages = List<_ChatMessage>.from(
      _chatStore[_conversationKey] ??
          const <_ChatMessage>[
            _ChatMessage(
              sender: 'support',
              text:
                  'Chat is encrypted for this job and stored in the demo log.',
            ),
          ],
    );
    _chatStore[_conversationKey] = _messages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Secure chat • ${widget.provider.id}'),
        actions: [
          PopupMenuButton<String>(
            initialValue: _targetLanguage,
            onSelected: (value) => setState(() => _targetLanguage = value),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'English', child: Text('English')),
              PopupMenuItem(value: 'Sinhala', child: Text('Sinhala')),
              PopupMenuItem(value: 'Tamil', child: Text('Tamil')),
            ],
            icon: const Icon(Icons.translate_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Translate to $_targetLanguage while chatting with support or the worker.',
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.tonalIcon(
                  onPressed: () =>
                      _appendSystemMessage('SOS sent to support team'),
                  icon: const Icon(Icons.shield_outlined),
                  label: const Text('SOS'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message.sender == 'customer';

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(message.text),
                        const SizedBox(height: 6),
                        Text(
                          'Translated: ${_translate(message.text)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Message securely',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(_ChatMessage(sender: 'customer', text: text));
      _messageController.clear();
      _chatStore[_conversationKey] = List<_ChatMessage>.from(_messages);
    });
  }

  void _appendSystemMessage(String text) {
    setState(() {
      _messages.add(_ChatMessage(sender: 'support', text: text));
      _chatStore[_conversationKey] = List<_ChatMessage>.from(_messages);
    });
  }

  String _translate(String text) {
    switch (_targetLanguage) {
      case 'Sinhala':
        return 'සිංහල: $text';
      case 'Tamil':
        return 'தமிழ்: $text';
      default:
        return text;
    }
  }
}

class _ChatMessage {
  const _ChatMessage({required this.sender, required this.text});

  final String sender;
  final String text;
}
