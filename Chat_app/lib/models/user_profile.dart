import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isOnline;
  final DateTime lastSeen;
  final String statusMessage;

  UserProfile({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.isOnline,
    required this.lastSeen,
    this.statusMessage = 'Available',
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    DateTime parseDateTime(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return DateTime.now();
    }

    return UserProfile(
      id: doc.id,
      name: data['name'] ?? 'User',
      avatarUrl: data['avatarUrl'] ?? 'https://i.pravatar.cc/150?u=${doc.id}',
      isOnline: data['isOnline'] ?? false,
      lastSeen: parseDateTime(data['lastSeen']),
      statusMessage: data['statusMessage'] ?? 'Available',
    );
  }

  factory UserProfile.fromMap(String id, Map<String, dynamic> data) {
    DateTime parseDateTime(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return DateTime.now();
    }

    return UserProfile(
      id: id,
      name: data['name'] ?? 'User',
      avatarUrl: data['avatarUrl'] ?? 'https://i.pravatar.cc/150?u=$id',
      isOnline: data['isOnline'] ?? false,
      lastSeen: parseDateTime(data['lastSeen']),
      statusMessage: data['statusMessage'] ?? 'Available',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'avatarUrl': avatarUrl,
      'isOnline': isOnline,
      'lastSeen': FieldValue.serverTimestamp(),
      'statusMessage': statusMessage,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'avatarUrl': avatarUrl,
      'isOnline': isOnline,
      'lastSeen': lastSeen.toIso8601String(),
      'statusMessage': statusMessage,
    };
  }
}
