import 'package:flutter/material.dart';

class PreferenceSwitches extends StatelessWidget {
  final bool notifications;
  final bool darkMode;
  final Function(bool) onNotificationsChanged;
  final Function(bool) onDarkModeChanged;

  const PreferenceSwitches({
    super.key,
    required this.notifications,
    required this.darkMode,
    required this.onNotificationsChanged,
    required this.onDarkModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Preferences',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        SwitchListTile(
          title: const Text('Receive Notifications'),
          value: notifications,
          onChanged: onNotificationsChanged,
        ),

        SwitchListTile(
          title: const Text('Dark Mode Preference'),
          value: darkMode,
          onChanged: onDarkModeChanged,
        ),
      ],
    );
  }
}
