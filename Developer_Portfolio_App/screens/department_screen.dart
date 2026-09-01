import 'package:flutter/material.dart';

import '../models/department.dart';
import '../widgets/contact_item.dart';

class DepartmentScreen extends StatelessWidget {
  const DepartmentScreen({super.key});

  static const Department department = Department(
    name: 'Dept. of Information & Communication Technology',
    code: 'ICT-DEPT',
    description:
        'The Department of ICT focuses on modern software engineering, mobile systems, communication networks, and emerging computing technologies to empower students for high-impact software careers.',
    email: 'ict.department@abc-tech.edu.in',
    phone: '+91 281 2345678',
    location: 'Building B, 3rd Floor, ABC Institute',
    faculty: [
      FacultyMember(
        name: 'Dr. Rajesh Sharma',
        designation: 'Head of Department & Professor',
        specialization: 'Mobile Computing & Wireless Networks',
        email: 'rsharma@abc-tech.edu.in',
      ),
      FacultyMember(
        name: 'Prof. Ananya Patel',
        designation: 'Associate Professor',
        specialization: 'Flutter App Development & UI/UX',
        email: 'apatel@abc-tech.edu.in',
      ),
      FacultyMember(
        name: 'Prof. Vikram Mehta',
        designation: 'Assistant Professor',
        specialization: 'Cloud Computing & DevOps',
        email: 'vmehta@abc-tech.edu.in',
      ),
      FacultyMember(
        name: 'Prof. Sneha Verma',
        designation: 'Assistant Professor',
        specialization: 'Data Structures & Algorithms',
        email: 'sverma@abc-tech.edu.in',
      ),
    ],
    courses: [
      CourseInfo(
        code: 'ICT501',
        title: 'Mobile Application Development with Flutter',
        credits: '4 Credits',
        semester: 'Semester 5',
      ),
      CourseInfo(
        code: 'ICT502',
        title: 'Database Management Systems',
        credits: '4 Credits',
        semester: 'Semester 5',
      ),
      CourseInfo(
        code: 'ICT503',
        title: 'Computer Networks & Security',
        credits: '3 Credits',
        semester: 'Semester 5',
      ),
      CourseInfo(
        code: 'ICT504',
        title: 'Web Engineering & Microservices',
        credits: '3 Credits',
        semester: 'Semester 5',
      ),
    ],
    facilities: [
      DepartmentFacility(
        name: 'Advanced App Development Lab',
        description: 'Equipped with high-performance workstations and testing devices.',
        icon: Icons.developer_board,
      ),
      DepartmentFacility(
        name: 'IoT & Embedded Systems Lab',
        description: 'Microcontrollers, sensor kits, and edge computing units.',
        icon: Icons.sensors,
      ),
      DepartmentFacility(
        name: 'Cloud Computing Research Center',
        description: 'Server infrastructure for virtualization and containerized apps.',
        icon: Icons.cloud_done,
      ),
      DepartmentFacility(
        name: 'Departmental Library & Innovation Hub',
        description: 'Access to research journals, tech publications, and project space.',
        icon: Icons.menu_book,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.domain,
                              size: 32,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  department.name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Code: ${department.code}',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        department.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Faculty Section
              _sectionHeader(context, Icons.people, 'Faculty Members'),
              const SizedBox(height: 10),
              ...department.faculty.map((f) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          f.name.replaceAll('Dr. ', '').replaceAll('Prof. ', '')[0],
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        f.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(f.designation),
                          Text(
                            'Specialization: ${f.specialization}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.email_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  )),

              const SizedBox(height: 20),

              // Courses Section
              _sectionHeader(context, Icons.school, 'Offered Courses'),
              const SizedBox(height: 10),
              ...department.courses.map((c) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              c.code,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      c.semester,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Chip(
                                      label: Text(
                                        c.credits,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),

              const SizedBox(height: 20),

              // Facilities Section
              _sectionHeader(context, Icons.build, 'Department Facilities'),
              const SizedBox(height: 10),
              ...department.facilities.map((fac) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            fac.icon,
                            size: 28,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fac.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  fac.description,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),

              const SizedBox(height: 20),

              // Contact Section
              _sectionHeader(context, Icons.contact_phone, 'Department Contact'),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ContactWidget(
                        icon: Icons.email,
                        title: 'Email',
                        value: department.email,
                      ),
                      ContactWidget(
                        icon: Icons.phone,
                        title: 'Phone',
                        value: department.phone,
                      ),
                      ContactWidget(
                        icon: Icons.location_on,
                        title: 'Office Location',
                        value: department.location,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, IconData icon, String title) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
