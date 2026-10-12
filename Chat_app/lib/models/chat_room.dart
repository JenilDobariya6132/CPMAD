import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String id;
  final String name;
  final String description;
  final String iconEmoji;
  final String category;
  final DateTime createdAt;
  final String lastMessage;
  final DateTime? lastMessageTime;
  final int memberCount;

  ChatRoom({
    required this.id,
    required this.name,
    required this.description,
    this.iconEmoji = '💬',
    this.category = 'General',
    required this.createdAt,
    this.lastMessage = '',
    this.lastMessageTime,
    this.memberCount = 1,
  });

  factory ChatRoom.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    DateTime parseDateTime(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return DateTime.now();
    }

    return ChatRoom(
      id: doc.id,
      name: data['name'] ?? 'Unnamed Room',
      description: data['description'] ?? '',
      iconEmoji: data['iconEmoji'] ?? '💬',
      category: data['category'] ?? 'General',
      createdAt: parseDateTime(data['createdAt']),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: data['lastMessageTime'] != null ? parseDateTime(data['lastMessageTime']) : null,
      memberCount: data['memberCount'] ?? 1,
    );
  }

  factory ChatRoom.fromMap(String id, Map<String, dynamic> data) {
    DateTime parseDateTime(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return DateTime.now();
    }

    return ChatRoom(
      id: id,
      name: data['name'] ?? 'Unnamed Room',
      description: data['description'] ?? '',
      iconEmoji: data['iconEmoji'] ?? '💬',
      category: data['category'] ?? 'General',
      createdAt: parseDateTime(data['createdAt']),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: data['lastMessageTime'] != null ? parseDateTime(data['lastMessageTime']) : null,
      memberCount: data['memberCount'] ?? 1,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'iconEmoji': iconEmoji,
      'category': category,
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': lastMessage,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'memberCount': memberCount,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'iconEmoji': iconEmoji,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'lastMessage': lastMessage,
      if (lastMessageTime != null) 'lastMessageTime': lastMessageTime!.toIso8601String(),
      'memberCount': memberCount,
    };
  }
}
