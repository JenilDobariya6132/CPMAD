import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/chat_room.dart';
import '../models/user_profile.dart';
import '../services/firebase_service.dart';
import '../widgets/create_room_dialog.dart';
import '../widgets/online_indicator.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

class RoomsScreen extends StatefulWidget {
  final UserProfile currentUser;
  final Function(UserProfile user) onUserChanged;

  const RoomsScreen({
    super.key,
    required this.currentUser,
    required this.onUserChanged,
  });

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = ['All', 'General', 'Development', 'Cloud', 'Gaming', 'Design'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCreateRoomModal(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (_) => CreateRoomDialog(
        onCreate: (name, description, category, iconEmoji) async {
          await FirebaseService.instance.createRoom(
            name: name,
            description: description,
            category: category,
            iconEmoji: iconEmoji,
          );
          messenger.showSnackBar(
            SnackBar(
              content: Text('Room "$name" created in Firestore!'),
              backgroundColor: const Color(0xFF10B981),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.forum_rounded, color: Color(0xFF6366F1), size: 28),
            SizedBox(width: 10),
            Text(
              'Realtime Chat Rooms',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          // Current User Profile Button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                    currentUser: widget.currentUser,
                    onUserChanged: widget.onUserChanged,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: OnlineAvatar(user: widget.currentUser, radius: 18),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF1E293B),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF0F172A),
                ),
                child: Row(
                  children: [
                    OnlineAvatar(user: widget.currentUser, radius: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.currentUser.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          OnlineStatusText(user: widget.currentUser),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'ONLINE MEMBERS',
                  style: TextStyle(
                    color: Color(0xFF6366F1),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              // StreamBuilder for Online Users List
              Expanded(
                child: StreamBuilder<List<UserProfile>>(
                  stream: FirebaseService.instance.getUsersStream(),
                  builder: (context, snapshot) {
                    final users = snapshot.data ?? [];
                    if (users.isEmpty) {
                      return const Center(
                        child: Text('No users found', style: TextStyle(color: Colors.grey)),
                      );
                    }
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final u = users[index];
                        return ListTile(
                          leading: OnlineAvatar(user: u, radius: 18),
                          title: Text(u.name, style: const TextStyle(color: Colors.white, fontSize: 14)),
                          subtitle: Text(
                            u.statusMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E293B),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search chat rooms...',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Category Filter Pills
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = cat == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: const Color(0xFF6366F1),
                          backgroundColor: const Color(0xFF0F172A),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey.shade400,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedCategory = cat);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Real-time Chat Rooms Firestore StreamBuilder
          Expanded(
            child: StreamBuilder<List<ChatRoom>>(
              stream: FirebaseService.instance.getRoomsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF6366F1)),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading rooms: ${snapshot.error}',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                }

                var rooms = snapshot.data ?? [];

                // Category filter
                if (_selectedCategory != 'All') {
                  rooms = rooms.where((r) => r.category == _selectedCategory).toList();
                }

                // Search query filter
                if (_searchQuery.isNotEmpty) {
                  rooms = rooms.where((r) =>
                      r.name.toLowerCase().contains(_searchQuery) ||
                      r.description.toLowerCase().contains(_searchQuery)).toList();
                }

                if (rooms.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off_rounded, color: Colors.grey, size: 48),
                        const SizedBox(height: 12),
                        const Text(
                          'No chat rooms found',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap + to create a new Firestore chat room!',
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    final timeStr = room.lastMessageTime != null
                        ? DateFormat('jm').format(room.lastMessageTime!)
                        : '';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          width: 48,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(room.iconEmoji, style: const TextStyle(fontSize: 24)),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                room.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6366F1).withAlpha(40),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                room.category,
                                style: const TextStyle(
                                  color: Color(0xFF818CF8),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              room.lastMessage.isNotEmpty ? room.lastMessage : room.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: room.lastMessage.isNotEmpty
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (timeStr.isNotEmpty)
                              Text(
                                timeStr,
                                style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                              ),
                            const SizedBox(height: 4),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                room: room,
                                currentUser: widget.currentUser,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6366F1),
        onPressed: () => _openCreateRoomModal(context),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('New Room', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
