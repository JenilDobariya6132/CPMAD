import 'package:flutter/material.dart';

import '../models/student.dart';
import '../widgets/profile_header.dart';
import '../widgets/info_card.dart';
import '../widgets/skill_card.dart';
import '../widgets/contact_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Student student = Student(
    name: 'Jenil Dobariya',
    qualification: 'B.Tech in Information & Communication Tech',
    enrollmentNo: '92400133024',
    semester: '5th Semester',
    college: 'ABC Institute of Technology',
    department: 'Dept. of ICT',
    cgpa: '6.92 / 10.0',
    email: 'jenildobariya47@email.com',
    phone: '+91 95740 33833',
    location: 'Rajkot, Gujarat',
    profileImage: 'assets/profile.jpg',
    about:
        'I am a passionate Computer Engineering student and developer interested in Flutter mobile app development, algorithm design, UI/UX design, and cloud technologies.',
    skills: [
      'Flutter',
      'Dart',
      'Python',
      'C++',
      'Java',
      'Firebase',
      'REST APIs',
      'UI/UX Design',
    ],
    achievements: [
      '1st Place - College Tech Fest Hackathon 2025',
      'Google Play Published App Developer',
      'Smart India Hackathon Finalist',
      'Academic Excellence Award - Sem 4',
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header (Image, Name, Degree, About)
          ProfileHeader(student: student),

          const SizedBox(height: 20),

          // Responsive Academic & Contact Layout
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 700) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _academicSection(context)),
                    const SizedBox(width: 20),
                    Expanded(child: _contactSection(context)),
                  ],
                );
              }
              return Column(
                children: [
                  _academicSection(context),
                  const SizedBox(height: 20),
                  _contactSection(context),
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          // Achievements Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Academic Achievements',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ...student.achievements.map(
                    (achievement) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              achievement,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Skills & Technical Proficiency
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.code,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Skills & Technologies',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: student.skills
                        .map((skill) => SkillWidget(skill: skill))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          // Footer
          Center(
            child: Text(
              '© 2026 ${student.name} • Student Developer Portfolio',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _academicSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.school,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Text(
                  'Academic Information',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 10),
            InfoCard(
              icon: Icons.account_balance,
              title: 'College',
              value: student.college,
            ),
            InfoCard(
              icon: Icons.domain,
              title: 'Department',
              value: student.department,
            ),
            InfoCard(
              icon: Icons.menu_book,
              title: 'Course & Specialization',
              value: student.qualification,
            ),
            InfoCard(
              icon: Icons.calendar_month,
              title: 'Semester',
              value: student.semester,
            ),
            InfoCard(
              icon: Icons.badge,
              title: 'Enrollment No.',
              value: student.enrollmentNo,
            ),
            InfoCard(
              icon: Icons.grade,
              title: 'Current CGPA',
              value: student.cgpa,
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.contact_mail,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Text(
                  'Contact Information',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ContactWidget(
              icon: Icons.email,
              title: 'Email',
              value: student.email,
            ),
            ContactWidget(
              icon: Icons.phone,
              title: 'Phone',
              value: student.phone,
            ),
            ContactWidget(
              icon: Icons.location_on,
              title: 'Location',
              value: student.location,
            ),
          ],
        ),
      ),
    );
  }
}
