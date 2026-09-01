class Student {
  final String name;
  final String qualification;
  final String enrollmentNo;
  final String semester;
  final String college;
  final String department;
  final String cgpa;

  final String email;
  final String phone;
  final String location;

  final String profileImage;

  final String about;

  final List<String> skills;
  final List<String> achievements;

  const Student({
    required this.name,
    required this.qualification,
    required this.enrollmentNo,
    required this.semester,
    required this.college,
    this.department = 'Information & Communication Tech',
    this.cgpa = '8.85 / 10',
    required this.email,
    required this.phone,
    required this.location,
    required this.profileImage,
    required this.about,
    required this.skills,
    this.achievements = const [
      '1st Place - College Hackathon 2025',
      'Flutter & Mobile App Development Certification',
      'Smart India Hackathon Finalist',
    ],
  });
}