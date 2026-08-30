import '../models/student.dart';

class ResultService {
  Future<Student> loadStudentResult() async {
    // Simulate loading data from server/database
    await Future.delayed(const Duration(seconds: 2));

    return Student(
      name: 'Demo Student',
      rollNo: 'ST101',
      marks: {
        'COMPUTER Network ': 85,
        'DAA': 78,
        'DSIP': 90,
        'CPMAD': 88,
        '.Net': 76,
      },
    );
  }
}