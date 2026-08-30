import 'package:flutter/material.dart';

import '../models/student.dart';
import '../services/result_service.dart';
import '../widgets/mark_input.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollController = TextEditingController();

  final Map<String, TextEditingController> markControllers = {
    'COMPUTER Network ': TextEditingController(),
    'DAA': TextEditingController(),
    'DSIP': TextEditingController(),
    'CPMAD': TextEditingController(),
    '.Net': TextEditingController(),
  };

  Student? student;
  bool isLoading = false;

  // Calculate result
  void calculateResult() {
    String name = nameController.text.trim();
    String rollNo = rollController.text.trim();

    if (name.isEmpty || rollNo.isEmpty) {
      showMessage('Please enter student name and roll number.');
      return;
    }

    Map<String, double> marks = {};

    for (String subject in markControllers.keys) {
      String value = markControllers[subject]!.text.trim();

      if (value.isEmpty) {
        showMessage('Please enter marks for $subject.');
        return;
      }

      double? mark = double.tryParse(value);

      if (mark == null || mark < 0 || mark > 100) {
        showMessage(
          'Enter valid marks for $subject between 0 and 100.',
        );
        return;
      }

      marks[subject] = mark;
    }

    setState(() {
      student = Student(
        name: name,
        rollNo: rollNo,
        marks: marks,
      );
    });
  }

  // Simulate asynchronous loading
  Future<void> loadDemoResult() async {
    setState(() {
      isLoading = true;
      student = null;
    });

    Student loadedStudent =
        await ResultService().loadStudentResult();

    setState(() {
      student = loadedStudent;
      isLoading = false;

      nameController.text = loadedStudent.name;
      rollController.text = loadedStudent.rollNo;

      loadedStudent.marks.forEach((subject, mark) {
        markControllers[subject]!.text = mark.toString();
      });
    });
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    rollController.dispose();

    for (final controller in markControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Result Calculator'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            const Text(
              'Student Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Student Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: rollController,
              decoration: const InputDecoration(
                labelText: 'Roll Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Subject Marks',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // Loop through all subjects
            ...markControllers.entries.map(
              (entry) => MarkInput(
                subject: entry.key,
                controller: entry.value,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: calculateResult,
              icon: const Icon(Icons.calculate),
              label: const Text('Calculate Result'),
            ),

            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: isLoading ? null : loadDemoResult,
              icon: const Icon(Icons.cloud_download),
              label: const Text('Load Demo Result'),
            ),

            const SizedBox(height: 20),

            if (isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Loading student result...'),
                  ],
                ),
              ),

            if (student != null && !isLoading)
              buildResultCard(student!),
          ],
        ),
      ),
    );
  }

  Widget buildResultCard(Student student) {
    double total = student.calculateTotal();
    double percentage = student.calculatePercentage();
    String grade = student.calculateGrade();
    String result = student.getResult();

    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(top: 15),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Result',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(),

            Text(
              'Name: ${student.name}',
              style: const TextStyle(fontSize: 18),
            ),

            Text(
              'Roll No: ${student.rollNo}',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 15),

            const Text(
              'Subject-wise Marks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            ...student.marks.entries.map(
              (entry) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(entry.key),
                trailing: Text(
                  '${entry.value.toStringAsFixed(0)} / 100',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const Divider(),

            Text(
              'Total: ${total.toStringAsFixed(2)} / 500',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              'Percentage: ${percentage.toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 18),
            ),

            Text(
              'Grade: $grade',
              style: const TextStyle(fontSize: 18),
            ),

            Text(
              'Result: $result',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: result == 'PASS'
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}