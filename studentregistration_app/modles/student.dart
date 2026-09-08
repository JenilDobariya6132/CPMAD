class Student {
  String name;
  String email;
  String phone;
  String password;
  String gender;
  List<String> courses;
  int age;
  bool notifications;
  bool darkMode;

  Student({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.gender,
    required this.courses,
    required this.age,
    required this.notifications,
    required this.darkMode,
  });
}
