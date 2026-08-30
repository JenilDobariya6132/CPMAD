class Student {
  String name;
  String rollNo;
  Map<String, double> marks;

  Student({
    required this.name,
    required this.rollNo,
    required this.marks,
  });

  // Calculate total marks
  double calculateTotal() {
    double total = 0;

    for (double mark in marks.values) {
      total += mark;
    }

    return total;
  }

  // Calculate percentage
  double calculatePercentage() {
    double total = calculateTotal();
    return total / marks.length;
  }

  // Calculate grade
  String calculateGrade() {
    double percentage = calculatePercentage();

    if (percentage >= 90) {
      return 'A+';
    } else if (percentage >= 80) {
      return 'A';
    } else if (percentage >= 70) {
      return 'B';
    } else if (percentage >= 60) {
      return 'C';
    } else if (percentage >= 50) {
      return 'D';
    } else {
      return 'F';
    }
  }

  // Check pass/fail
  bool isPassed() {
    for (double mark in marks.values) {
      if (mark < 35) {
        return false;
      }
    }

    return true;
  }

  // Get final result
  String getResult() {
    return isPassed() ? 'PASS' : 'FAIL';
  }
}