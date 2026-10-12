import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../models/chat_room.dart';
import '../models/user_profile.dart';
import '../services/firebase_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';
import '../widgets/online_indicator.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom room;
  final UserProfile currentUser;

  const ChatScreen({
    super.key,
    required this.room,
    required this.currentUser,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  ChatMessage? _replyingToMessage;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 1,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(widget.room.iconEmoji, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.room.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.room.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, color: Colors.white70),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: const Color(0xFF1E293B),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(widget.room.iconEmoji, style: const TextStyle(fontSize: 32)),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.room.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                              Text('Category: ${widget.room.category}', style: const TextStyle(color: Color(0xFF38BDF8))),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Description', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(widget.room.description, style: const TextStyle(color: Colors.white, fontSize: 14)),
                      const SizedBox(height: 16),
                      const Text('Real-Time Firestore Collection', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 4),
                      SelectableText(
                        'chat_rooms/${widget.room.id}/messages',
                        style: const TextStyle(color: Color(0xFF818CF8), fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Firestore StreamBuilder for Chat Messages
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: FirebaseService.instance.getMessagesStream(widget.room.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF6366F1)),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          'Firestore Stream Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  );
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF6366F1), size: 40),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No messages yet',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Be the first to start the conversation in ${widget.room.name}!',
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true, // Show newest messages at bottom
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == widget.currentUser.id;

                    return MessageBubble(
                      message: msg,
                      isMe: isMe,
                      onEdit: (messageId, newText) {
                        FirebaseService.instance.editMessage(
                          widget.room.id,
                          messageId,
                          newText,
                        );
                      },
                      onDelete: (messageId) {
                        FirebaseService.instance.deleteMessage(
                          widget.room.id,
                          messageId,
                        );
                      },
                      onReply: (replyMsg) {
                        setState(() => _replyingToMessage = replyMsg);
                      },
                    );
                  },
                );
              },
            ),
          ),
          // Input field
          MessageInput(
            replyToMessage: _replyingToMessage,
            onCancelReply: () => setState(() => _replyingToMessage = null),
            onSendMessage: (text, {replyTo}) async {
              await FirebaseService.instance.sendMessage(
                roomId: widget.room.id,
                text: text,
                sender: widget.currentUser,
                replyToId: replyTo?.id,
                replyToText: replyTo != null ? '${replyTo.senderName}: ${replyTo.text}' : null,
              );
              _scrollToBottom();
            },
          ),
        ],
      ),
    );
  }
}
