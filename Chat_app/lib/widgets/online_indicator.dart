import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_profile.dart';

class OnlineAvatar extends StatelessWidget {
  final UserProfile user;
  final double radius;
  final bool showStatusBadge;

  const OnlineAvatar({
    super.key,
    required this.user,
    this.radius = 22,
    this.showStatusBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    final initials = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: Theme.of(context).primaryColor.withAlpha(50),
          child: ClipOval(
            child: user.avatarUrl.isNotEmpty
                ? Image.network(
                    user.avatarUrl,
                    width: radius * 2,
                    height: radius * 2,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        alignment: Alignment.center,
                        color: const Color(0xFF334155),
                        child: Text(
                          initials,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: radius * 0.9,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    alignment: Alignment.center,
                    color: const Color(0xFF334155),
                    child: Text(
                      initials,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: radius * 0.9,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
        ),
        if (showStatusBadge)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: radius * 0.65,
              height: radius * 0.65,
              decoration: BoxDecoration(
                color: user.isOnline ? const Color(0xFF10B981) : const Color(0xFF9CA3AF),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
                boxShadow: user.isOnline
                    ? [
                        BoxShadow(
                          color: const Color(0xFF10B981).withAlpha(128),
                          blurRadius: 4,
                          spreadRadius: 1,
                        )
                      ]
                    : [],
              ),
            ),
          ),
      ],
    );
  }
}

class OnlineStatusText extends StatelessWidget {
  final UserProfile user;
  final TextStyle? style;

  const OnlineStatusText({
    super.key,
    required this.user,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    if (user.isOnline) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Online',
            style: style ??
                const TextStyle(
                  color: Color(0xFF10B981),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
          ),
        ],
      );
    } else {
      final timeStr = DateFormat('jm').format(user.lastSeen);
      return Text(
        'Last seen $timeStr',
        style: style ??
            TextStyle(
              color: Colors.white.withAlpha(150),
              fontSize: 12,
            ),
      );
    }
  }
}
