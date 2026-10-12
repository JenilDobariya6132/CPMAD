import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String roomId;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String text;
  final DateTime timestamp;
  final bool isEdited;
  final DateTime? editedAt;
  final String? replyToMessageId;
  final String? replyToText;

  ChatMessage({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.text,
    required this.timestamp,
    this.isEdited = false,
    this.editedAt,
    this.replyToMessageId,
    this.replyToText,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    DateTime parseDateTime(dynamic val) {
      if (val is Timestamp) {
        return val.toDate();
      } else if (val is String) {
        return DateTime.tryParse(val) ?? DateTime.now();
      } else if (val is int) {
        return DateTime.fromMillisecondsSinceEpoch(val);
      }
      return DateTime.now();
    }

    return ChatMessage(
      id: doc.id,
      roomId: data['roomId'] ?? '',
      senderId: data['senderId'] ?? 'unknown',
      senderName: data['senderName'] ?? 'Anonymous',
      senderAvatar: data['senderAvatar'] ?? 'https://i.pravatar.cc/150?u=anonymous',
      text: data['text'] ?? '',
      timestamp: parseDateTime(data['timestamp']),
      isEdited: data['isEdited'] ?? false,
      editedAt: data['editedAt'] != null ? parseDateTime(data['editedAt']) : null,
      replyToMessageId: data['replyToMessageId'],
      replyToText: data['replyToText'],
    );
  }

  factory ChatMessage.fromMap(String id, Map<String, dynamic> data) {
    DateTime parseDateTime(dynamic val) {
      if (val is Timestamp) {
        return val.toDate();
      } else if (val is String) {
        return DateTime.tryParse(val) ?? DateTime.now();
      } else if (val is int) {
        return DateTime.fromMillisecondsSinceEpoch(val);
      }
      return DateTime.now();
    }

    return ChatMessage(
      id: id,
      roomId: data['roomId'] ?? '',
      senderId: data['senderId'] ?? 'unknown',
      senderName: data['senderName'] ?? 'Anonymous',
      senderAvatar: data['senderAvatar'] ?? 'https://i.pravatar.cc/150?u=anonymous',
      text: data['text'] ?? '',
      timestamp: parseDateTime(data['timestamp']),
      isEdited: data['isEdited'] ?? false,
      editedAt: data['editedAt'] != null ? parseDateTime(data['editedAt']) : null,
      replyToMessageId: data['replyToMessageId'],
      replyToText: data['replyToText'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'roomId': roomId,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'isEdited': isEdited,
      if (editedAt != null) 'editedAt': Timestamp.fromDate(editedAt!),
      if (replyToMessageId != null) 'replyToMessageId': replyToMessageId,
      if (replyToText != null) 'replyToText': replyToText,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isEdited': isEdited,
      if (editedAt != null) 'editedAt': editedAt!.toIso8601String(),
      if (replyToMessageId != null) 'replyToMessageId': replyToMessageId,
      if (replyToText != null) 'replyToText': replyToText,
    };
  }
}
