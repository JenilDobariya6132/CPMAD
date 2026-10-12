import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../models/chat_room.dart';
import '../models/user_profile.dart';

class FirebaseService {
  static final FirebaseService instance = FirebaseService._internal();
  FirebaseService._internal();

  bool _isFirebaseAvailable = false;
  bool get isFirebaseAvailable => _isFirebaseAvailable;

  // In-memory fallback state for live interactive demo if Firebase is not linked
  final Map<String, List<ChatMessage>> _demoMessages = {};
  final List<ChatRoom> _demoRooms = [];
  final List<UserProfile> _demoUsers = [];

  final StreamController<List<ChatRoom>> _demoRoomsController = StreamController<List<ChatRoom>>.broadcast();
  final Map<String, StreamController<List<ChatMessage>>> _demoMessageControllers = {};
  final StreamController<List<UserProfile>> _demoUsersController = StreamController<List<UserProfile>>.broadcast();

  Future<void> initialize() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        _isFirebaseAvailable = true;
        debugPrint('Firebase initialized successfully.');
      } else {
        await Firebase.initializeApp();
        _isFirebaseAvailable = true;
        debugPrint('Firebase initialized successfully.');
      }
    } catch (e) {
      _isFirebaseAvailable = false;
      debugPrint('Firebase not configured or initialized: $e. Using local real-time stream engine fallback.');
      _initDemoData();
    }
  }

  void _initDemoData() {
    _demoRooms.addAll([
      ChatRoom(
        id: 'general',
        name: 'General Discussion',
        description: 'Welcome everyone! Say hi to the community.',
        iconEmoji: '💬',
        category: 'General',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        lastMessage: 'Welcome to the real-time chat application!',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ChatRoom(
        id: 'flutter_dev',
        name: 'Flutter & Dart',
        description: 'Discuss Widgets, Streams, Firestore, and state management.',
        iconEmoji: '💙',
        category: 'Development',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        lastMessage: 'StreamBuilder automatically rebuilds on new snapshots!',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
      ChatRoom(
        id: 'firebase_help',
        name: 'Firebase & Firestore',
        description: 'Cloud Firestore queries, rules, and real-time updates.',
        iconEmoji: '🔥',
        category: 'Cloud',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        lastMessage: 'Firestore real-time streams handle instant synchronization.',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
    ]);

    _demoUsers.addAll([
      UserProfile(
        id: 'user_alex',
        name: 'Alex Rivera',
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
        isOnline: true,
        lastSeen: DateTime.now(),
        statusMessage: 'Coding in Dart 🚀',
      ),
      UserProfile(
        id: 'user_sarah',
        name: 'Sarah Chen',
        avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
        isOnline: true,
        lastSeen: DateTime.now(),
        statusMessage: 'Designing UI components ✨',
      ),
      UserProfile(
        id: 'user_devin',
        name: 'Devin Vance',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        isOnline: false,
        lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
        statusMessage: 'Away for coffee ☕',
      ),
    ]);

    _demoMessages['general'] = [
      ChatMessage(
        id: 'msg_1',
        roomId: 'general',
        senderId: 'user_sarah',
        senderName: 'Sarah Chen',
        senderAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
        text: 'Welcome to our real-time chat application powered by Cloud Firestore and Streams!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      ChatMessage(
        id: 'msg_2',
        roomId: 'general',
        senderId: 'user_alex',
        senderName: 'Alex Rivera',
        senderAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
        text: 'You can create, edit, delete messages in real-time, switch rooms, and monitor online status!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
    ];

    _demoMessages['flutter_dev'] = [
      ChatMessage(
        id: 'msg_f1',
        roomId: 'flutter_dev',
        senderId: 'user_alex',
        senderName: 'Alex Rivera',
        senderAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
        text: 'StreamBuilder makes updating Flutter UI with Firestore effortless.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
    ];

    _demoMessages['firebase_help'] = [
      ChatMessage(
        id: 'msg_fb1',
        roomId: 'firebase_help',
        senderId: 'user_sarah',
        senderName: 'Sarah Chen',
        senderAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
        text: 'Firestore `.snapshots()` delivers instant real-time data pushes to subscribers.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 40)),
      ),
    ];
  }

  // --- STREAMS ---

  /// Retrieve all chat rooms via real-time Firestore Stream
  Stream<List<ChatRoom>> getRoomsStream() {
    if (_isFirebaseAvailable) {
      return FirebaseFirestore.instance
          .collection('chat_rooms')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => ChatRoom.fromFirestore(doc)).toList();
      });
    } else {
      // Return simulated reactive stream
      Future.microtask(() => _demoRoomsController.add(List.from(_demoRooms)));
      return _demoRoomsController.stream;
    }
  }

  /// Retrieve messages for a room via real-time Firestore Stream
  Stream<List<ChatMessage>> getMessagesStream(String roomId) {
    if (_isFirebaseAvailable) {
      return FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(roomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList();
      });
    } else {
      if (!_demoMessageControllers.containsKey(roomId)) {
        _demoMessageControllers[roomId] = StreamController<List<ChatMessage>>.broadcast();
      }
      final list = _demoMessages[roomId] ?? [];
      Future.microtask(() => _demoMessageControllers[roomId]!.add(List.from(list.reversed)));
      return _demoMessageControllers[roomId]!.stream;
    }
  }

  /// Retrieve all users via real-time Stream for online status indicators
  Stream<List<UserProfile>> getUsersStream() {
    if (_isFirebaseAvailable) {
      return FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => UserProfile.fromFirestore(doc)).toList();
      });
    } else {
      Future.microtask(() => _demoUsersController.add(List.from(_demoUsers)));
      return _demoUsersController.stream;
    }
  }

  // --- CRUD OPERATIONS ---

  /// Create and store a new message in Firestore
  Future<void> sendMessage({
    required String roomId,
    required String text,
    required UserProfile sender,
    String? replyToId,
    String? replyToText,
  }) async {
    if (text.trim().isEmpty) return;

    if (_isFirebaseAvailable) {
      final batch = FirebaseFirestore.instance.batch();
      final msgRef = FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(roomId)
          .collection('messages')
          .doc();

      final roomRef = FirebaseFirestore.instance.collection('chat_rooms').doc(roomId);

      batch.set(msgRef, {
        'roomId': roomId,
        'senderId': sender.id,
        'senderName': sender.name,
        'senderAvatar': sender.avatarUrl,
        'text': text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'isEdited': false,
        if (replyToId != null) 'replyToMessageId': replyToId,
        if (replyToText != null) 'replyToText': replyToText,
      });

      batch.update(roomRef, {
        'lastMessage': text.trim(),
        'lastMessageTime': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } else {
      final newMessage = ChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        roomId: roomId,
        senderId: sender.id,
        senderName: sender.name,
        senderAvatar: sender.avatarUrl,
        text: text.trim(),
        timestamp: DateTime.now(),
        replyToMessageId: replyToId,
        replyToText: replyToText,
      );

      _demoMessages.putIfAbsent(roomId, () => []);
      _demoMessages[roomId]!.add(newMessage);

      // Update room last message
      final index = _demoRooms.indexWhere((r) => r.id == roomId);
      if (index != -1) {
        final room = _demoRooms[index];
        _demoRooms[index] = ChatRoom(
          id: room.id,
          name: room.name,
          description: room.description,
          iconEmoji: room.iconEmoji,
          category: room.category,
          createdAt: room.createdAt,
          lastMessage: text.trim(),
          lastMessageTime: DateTime.now(),
          memberCount: room.memberCount,
        );
        _demoRoomsController.add(List.from(_demoRooms));
      }

      if (_demoMessageControllers.containsKey(roomId)) {
        _demoMessageControllers[roomId]!.add(List.from(_demoMessages[roomId]!.reversed));
      }
    }
  }

  /// Update an existing message in Firestore (Edit)
  Future<void> editMessage(String roomId, String messageId, String newText) async {
    if (newText.trim().isEmpty) return;

    if (_isFirebaseAvailable) {
      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(roomId)
          .collection('messages')
          .doc(messageId)
          .update({
        'text': newText.trim(),
        'isEdited': true,
        'editedAt': FieldValue.serverTimestamp(),
      });
    } else {
      final list = _demoMessages[roomId];
      if (list != null) {
        final idx = list.indexWhere((m) => m.id == messageId);
        if (idx != -1) {
          final old = list[idx];
          list[idx] = ChatMessage(
            id: old.id,
            roomId: old.roomId,
            senderId: old.senderId,
            senderName: old.senderName,
            senderAvatar: old.senderAvatar,
            text: newText.trim(),
            timestamp: old.timestamp,
            isEdited: true,
            editedAt: DateTime.now(),
            replyToMessageId: old.replyToMessageId,
            replyToText: old.replyToText,
          );
          if (_demoMessageControllers.containsKey(roomId)) {
            _demoMessageControllers[roomId]!.add(List.from(list.reversed));
          }
        }
      }
    }
  }

  /// Delete a message from Firestore (Delete)
  Future<void> deleteMessage(String roomId, String messageId) async {
    if (_isFirebaseAvailable) {
      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(roomId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } else {
      final list = _demoMessages[roomId];
      if (list != null) {
        list.removeWhere((m) => m.id == messageId);
        if (_demoMessageControllers.containsKey(roomId)) {
          _demoMessageControllers[roomId]!.add(List.from(list.reversed));
        }
      }
    }
  }

  /// Create a new chat room in Firestore
  Future<String> createRoom({
    required String name,
    required String description,
    required String category,
    required String iconEmoji,
  }) async {
    if (_isFirebaseAvailable) {
      final docRef = await FirebaseFirestore.instance.collection('chat_rooms').add({
        'name': name.trim(),
        'description': description.trim(),
        'category': category.isEmpty ? 'General' : category,
        'iconEmoji': iconEmoji.isEmpty ? '💬' : iconEmoji,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': 'Room created',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'memberCount': 1,
      });
      return docRef.id;
    } else {
      final id = 'room_${DateTime.now().millisecondsSinceEpoch}';
      final newRoom = ChatRoom(
        id: id,
        name: name.trim(),
        description: description.trim(),
        category: category.isEmpty ? 'General' : category,
        iconEmoji: iconEmoji.isEmpty ? '💬' : iconEmoji,
        createdAt: DateTime.now(),
        lastMessage: 'Room created',
        lastMessageTime: DateTime.now(),
        memberCount: 1,
      );
      _demoRooms.insert(0, newRoom);
      _demoMessages[id] = [];
      _demoRoomsController.add(List.from(_demoRooms));
      return id;
    }
  }

  /// Delete a chat room
  Future<void> deleteRoom(String roomId) async {
    if (_isFirebaseAvailable) {
      await FirebaseFirestore.instance.collection('chat_rooms').doc(roomId).delete();
    } else {
      _demoRooms.removeWhere((r) => r.id == roomId);
      _demoMessages.remove(roomId);
      _demoRoomsController.add(List.from(_demoRooms));
    }
  }

  /// Update online presence indicator in Firestore
  Future<void> updateUserPresence(String userId, bool isOnline, {String? statusMessage}) async {
    if (_isFirebaseAvailable) {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'isOnline': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
        if (statusMessage != null) 'statusMessage': statusMessage,
      }, SetOptions(merge: true));
    } else {
      final idx = _demoUsers.indexWhere((u) => u.id == userId);
      if (idx != -1) {
        final u = _demoUsers[idx];
        _demoUsers[idx] = UserProfile(
          id: u.id,
          name: u.name,
          avatarUrl: u.avatarUrl,
          isOnline: isOnline,
          lastSeen: DateTime.now(),
          statusMessage: statusMessage ?? u.statusMessage,
        );
        _demoUsersController.add(List.from(_demoUsers));
      }
    }
  }
}
