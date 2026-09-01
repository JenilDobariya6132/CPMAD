import 'package:flutter/material.dart';

import '../models/student.dart';

class ProfileHeader extends StatelessWidget {
  final Student student;

  const ProfileHeader({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(24),

        child: Row(
          children: [

            // ================= IMAGE =================

            Container(
              width: 130,
              height: 130,

              decoration:
                  BoxDecoration(
                shape: BoxShape.circle,

                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .primary,

                  width: 4,
                ),
              ),

              child: ClipOval(
                child: Image.asset(
                  student.profileImage,

                  fit: BoxFit.cover,

                  errorBuilder:
                      (context, error, stackTrace) {
                    return Icon(
                      Icons.person,

                      size: 75,

                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 25),

            // ================= DETAILS =================

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    student.name,

                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    student.qualification,

                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Student • Developer',

                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .primary,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    student.about,

                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}