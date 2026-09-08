import 'package:flutter/material.dart';

class CourseSelection extends StatelessWidget {
  final List<String> courses;
  final Function(String, bool) onChanged;

  const CourseSelection({
    super.key,
    required this.courses,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final allCourses = ['Flutter', 'Python', 'Java'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Courses / Skills',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        ...allCourses.map(
          (course) => CheckboxListTile(
            title: Text(course),
            value: courses.contains(course),
            onChanged: (value) {
              onChanged(course, value ?? false);
            },
          ),
        ),
      ],
    );
  }
}
