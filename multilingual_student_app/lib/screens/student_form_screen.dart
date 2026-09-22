import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../models/student.dart';

class StudentFormScreen extends StatefulWidget {
  const StudentFormScreen({super.key});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final courseController = TextEditingController();
  final marksController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<void> selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  void saveStudent() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final student = Student(
      name: nameController.text,
      email: emailController.text,
      age: int.parse(ageController.text),
      course: courseController.text,
      marks: double.parse(marksController.text),
      date: selectedDate,
    );

    Navigator.pop(context, student);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    courseController.dispose();
    marksController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr.translate('addStudent'),
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: context.tr.translate('name'),
                  hintText: context.tr.translate('enterName'),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.tr.translate(
                      'requiredName',
                    );
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: context.tr.translate('email'),
                  hintText: context.tr.translate('enterEmail'),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.tr.translate(
                      'requiredEmail',
                    );
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: context.tr.translate('age'),
                  hintText: context.tr.translate('enterAge'),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.tr.translate(
                      'requiredAge',
                    );
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: courseController,
                decoration: InputDecoration(
                  labelText: context.tr.translate('course'),
                  hintText: context.tr.translate('enterCourse'),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.tr.translate(
                      'requiredCourse',
                    );
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: marksController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: context.tr.translate('marks'),
                  hintText: context.tr.translate('enterMarks'),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.tr.translate(
                      'requiredMarks',
                    );
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${context.tr.translate('date')}: '
                      '${selectedDate.day}/'
                      '${selectedDate.month}/'
                      '${selectedDate.year}',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: selectDate,
                    child: Text(
                      context.tr.translate('date'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveStudent,
                  child: Text(
                    context.tr.translate('save'),
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
