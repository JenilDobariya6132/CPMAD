import 'package:flutter/material.dart';
import '../modles/student.dart';

class RegistrationController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  String? gender;
  List<String> courses = [];
  double age = 18;
  bool notifications = false;
  bool darkMode = false;

  Student? submittedStudent;

  bool submit() {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    if (gender == null || courses.isEmpty) {
      return false;
    }

    submittedStudent = Student(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      password: passwordController.text,
      gender: gender!,
      courses: courses,
      age: age.round(),
      notifications: notifications,
      darkMode: darkMode,
    );

    return true;
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
  }
}
