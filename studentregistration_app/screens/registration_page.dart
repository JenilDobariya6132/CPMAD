import 'package:flutter/material.dart';

import '../controllers/registration_controller.dart';
import '../widgets/student_text_field.dart';
import '../widgets/gender_selection.dart';
import '../widgets/course_selection.dart';
import '../widgets/age_slider.dart';
import '../widgets/preference_switches.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final controller = RegistrationController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submitForm() {
    if (controller.submit()) {
      setState(() {});

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration Successful!')));
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Registration'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: controller.formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StudentTextField(
                label: 'Name',
                controller: controller.nameController,
                icon: Icons.person,
              ),

              const SizedBox(height: 15),

              StudentTextField(
                label: 'Email',
                controller: controller.emailController,
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 15),

              StudentTextField(
                label: 'Phone',
                controller: controller.phoneController,
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 15),

              StudentTextField(
                label: 'Password',
                controller: controller.passwordController,
                icon: Icons.lock,
                password: true,
              ),

              const SizedBox(height: 20),

              GenderSelection(
                gender: controller.gender,
                onChanged: (value) {
                  setState(() {
                    controller.gender = value;
                  });
                },
              ),

              if (controller.gender == null)
                const Text(
                  'Please select gender',
                  style: TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 20),

              CourseSelection(
                courses: controller.courses,
                onChanged: (course, selected) {
                  setState(() {
                    if (selected) {
                      controller.courses.add(course);
                    } else {
                      controller.courses.remove(course);
                    }
                  });
                },
              ),

              if (controller.courses.isEmpty)
                const Text(
                  'Please select at least one course',
                  style: TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 20),

              AgeSlider(
                age: controller.age,
                onChanged: (value) {
                  setState(() {
                    controller.age = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              PreferenceSwitches(
                notifications: controller.notifications,
                darkMode: controller.darkMode,
                onNotificationsChanged: (value) {
                  setState(() {
                    controller.notifications = value;
                  });
                },
                onDarkModeChanged: (value) {
                  setState(() {
                    controller.darkMode = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitForm,
                  child: const Text('Register'),
                ),
              ),

              const SizedBox(height: 20),

              if (controller.submittedStudent != null)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Submitted Student Information\n\n'
                      'Name: ${controller.submittedStudent!.name}\n'
                      'Email: ${controller.submittedStudent!.email}\n'
                      'Phone: ${controller.submittedStudent!.phone}\n'
                      'Gender: ${controller.submittedStudent!.gender}\n'
                      'Courses: ${controller.submittedStudent!.courses.join(', ')}\n'
                      'Age: ${controller.submittedStudent!.age}\n'
                      'Notifications: ${controller.submittedStudent!.notifications ? 'Yes' : 'No'}\n'
                      'Dark Mode: ${controller.submittedStudent!.darkMode ? 'Yes' : 'No'}',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
