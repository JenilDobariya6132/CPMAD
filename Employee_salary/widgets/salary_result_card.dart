import 'package:flutter/material.dart';
import '../models/employee.dart';

class SalaryResultCard extends StatelessWidget {
  final Employee employee;

  const SalaryResultCard({
    super.key,
    required this.employee,
  });

  String formatSalary(double value) {
    return '₹${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    double basic = employee.calculateBasicSalary();
    double hra = employee.calculateHRA();
    double da = employee.calculateDA();
    double allowances = employee.calculateAllowances();
    double deductions = employee.calculateDeductions();
    double netSalary = employee.calculateNetSalary();

    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(top: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Salary Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(),

            Text(
              'Employee: ${employee.name}',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 15),

            salaryRow(
              'Gross Salary',
              employee.grossSalary,
            ),

            salaryRow(
              'Basic Salary',
              basic,
            ),

            salaryRow(
              'HRA',
              hra,
            ),

            salaryRow(
              'DA',
              da,
            ),

            salaryRow(
              'Total Allowances',
              allowances,
            ),

            salaryRow(
              'Deductions',
              deductions,
            ),

            const Divider(),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green.shade50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Net Salary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    formatSalary(netSalary),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget salaryRow(String title, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            formatSalary(value),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}