import 'package:flutter/material.dart';

import '../models/electricity_bill.dart';

class BillResultCard extends StatelessWidget {
  final ElectricityBill bill;

  const BillResultCard({
    super.key,
    required this.bill,
  });

  String formatAmount(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    double energyCharge = bill.calculateEnergyCharge();
    double totalBill = bill.calculateTotalBill();

    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(top: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Electricity Bill',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(),

            Text(
              'Consumer Name: ${bill.consumerName}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Units Consumed: ${bill.units.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Applicable Slab: ${bill.getSlab()}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            billRow(
              'Energy Charge',
              energyCharge,
            ),

            billRow(
              'Fixed Charge',
              ElectricityBill.fixedCharge,
            ),

            const Divider(),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    'Total Bill',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    formatAmount(totalBill),
                    style: TextStyle(
                      fontSize: 28,
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

  Widget billRow(String title, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [

          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),

          Text(
            formatAmount(amount),
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