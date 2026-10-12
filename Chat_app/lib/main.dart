import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_profile.dart';
import 'screens/rooms_screen.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.instance.initialize();
  runApp(const RealtimeChatApp());
}

class RealtimeChatApp extends StatefulWidget {
  const RealtimeChatApp({super.key});

  @override
  State<RealtimeChatApp> createState() => _RealtimeChatAppState();
}

class _RealtimeChatAppState extends State<RealtimeChatApp> with WidgetsBindingObserver {
  late UserProfile _currentUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initial default user identity
    _currentUser = UserProfile(
      id: 'user_alex',
      name: 'Alex Rivera',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      isOnline: true,
      lastSeen: DateTime.now(),
      statusMessage: 'Coding in Flutter 🚀',
    );

    // Set online status in Firebase
    FirebaseService.instance.updateUserPresence(_currentUser.id, true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    FirebaseService.instance.updateUserPresence(_currentUser.id, false);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // User came to foreground
      FirebaseService.instance.updateUserPresence(_currentUser.id, true);
      setState(() {
        _currentUser = UserProfile(
          id: _currentUser.id,
          name: _currentUser.name,
          avatarUrl: _currentUser.avatarUrl,
          isOnline: true,
          lastSeen: DateTime.now(),
          statusMessage: _currentUser.statusMessage,
        );
      });
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // User left app
      FirebaseService.instance.updateUserPresence(_currentUser.id, false);
      setState(() {
        _currentUser = UserProfile(
          id: _currentUser.id,
          name: _currentUser.name,
          avatarUrl: _currentUser.avatarUrl,
          isOnline: false,
          lastSeen: DateTime.now(),
          statusMessage: _currentUser.statusMessage,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real-Time Chat App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF6366F1),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E293B),
          elevation: 0,
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF38BDF8),
          surface: Color(0xFF1E293B),
        ),
      ),
      home: RoomsScreen(
        currentUser: _currentUser,
        onUserChanged: (newUser) {
          setState(() {
            _currentUser = newUser;
          });
        },
      ),
    );
  }
}
