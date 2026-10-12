import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/firebase_service.dart';
import '../widgets/online_indicator.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfile currentUser;
  final Function(UserProfile user) onUserChanged;

  const ProfileScreen({
    super.key,
    required this.currentUser,
    required this.onUserChanged,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool _isOnline;
  late TextEditingController _statusController;
  late TextEditingController _nameController;

  final List<UserProfile> _presetUsers = [
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
      isOnline: true,
      lastSeen: DateTime.now(),
      statusMessage: 'Building Firebase backend 🔥',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _isOnline = widget.currentUser.isOnline;
    _statusController = TextEditingController(text: widget.currentUser.statusMessage);
    _nameController = TextEditingController(text: widget.currentUser.name);
  }

  @override
  void dispose() {
    _statusController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('User Profile & Status', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Current user avatar card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                children: [
                  OnlineAvatar(user: widget.currentUser, radius: 44),
                  const SizedBox(height: 12),
                  Text(
                    widget.currentUser.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${widget.currentUser.id}',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Online Status:', style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 12),
                      Switch(
                        value: _isOnline,
                        activeColor: const Color(0xFF10B981),
                        onChanged: (val) {
                          setState(() => _isOnline = val);
                          FirebaseService.instance.updateUserPresence(
                            widget.currentUser.id,
                            val,
                          );
                          final updated = UserProfile(
                            id: widget.currentUser.id,
                            name: widget.currentUser.name,
                            avatarUrl: widget.currentUser.avatarUrl,
                            isOnline: val,
                            lastSeen: DateTime.now(),
                            statusMessage: _statusController.text,
                          );
                          widget.onUserChanged(updated);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Custom Status & Name
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Edit Details',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      labelStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _statusController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Status Message',
                      labelStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.save_rounded, color: Colors.white),
                      label: const Text('Update Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        final updated = UserProfile(
                          id: widget.currentUser.id,
                          name: _nameController.text.trim(),
                          avatarUrl: widget.currentUser.avatarUrl,
                          isOnline: _isOnline,
                          lastSeen: DateTime.now(),
                          statusMessage: _statusController.text.trim(),
                        );
                        FirebaseService.instance.updateUserPresence(
                          updated.id,
                          _isOnline,
                          statusMessage: updated.statusMessage,
                        );
                        widget.onUserChanged(updated);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile updated successfully!')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Switch active demo identity
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Switch Demo Identity',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Test real-time chat between different users in multiple windows or tabs:',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  ..._presetUsers.map((user) {
                    final isSelected = user.id == widget.currentUser.id;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      tileColor: isSelected ? const Color(0xFF6366F1).withAlpha(50) : null,
                      leading: OnlineAvatar(user: user, radius: 18),
                      title: Text(user.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(user.statusMessage, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded, color: Color(0xFF6366F1))
                          : OutlinedButton(
                              onPressed: () {
                                widget.onUserChanged(user);
                                setState(() {
                                  _isOnline = user.isOnline;
                                  _nameController.text = user.name;
                                  _statusController.text = user.statusMessage;
                                });
                              },
                              child: const Text('Switch', style: TextStyle(color: Color(0xFF38BDF8))),
                            ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
