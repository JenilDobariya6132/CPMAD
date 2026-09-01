class Employee {
  String name;
  double grossSalary;

  Employee({
    required this.name,
    required this.grossSalary,
  });

  // Basic salary = 50% of gross salary
  double calculateBasicSalary() {
    return grossSalary * 0.50;
  }

  // HRA = 20% of basic salary
  double calculateHRA() {
    return calculateBasicSalary() * 0.20;
  }

  // DA = 10% of basic salary
  double calculateDA() {
    return calculateBasicSalary() * 0.10;
  }

  // Total allowances
  double calculateAllowances() {
    return calculateHRA() + calculateDA();
  }

  // Deduction = 5% of basic salary
  double calculateDeductions() {
    return calculateBasicSalary() * 0.05;
  }

  // Net salary
  double calculateNetSalary() {
    return calculateBasicSalary() +
        calculateAllowances() -
        calculateDeductions();
  }
}