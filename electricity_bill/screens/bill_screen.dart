import 'package:flutter/material.dart';

import '../models/electricity_bill.dart';
import '../widgets/bill_result_card.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController unitsController =
      TextEditingController();

  ElectricityBill? bill;

  void calculateBill() {
    String name = nameController.text.trim();
    String unitsText = unitsController.text.trim();

    if (name.isEmpty) {
      showMessage('Please enter consumer name.');
      return;
    }

    if (unitsText.isEmpty) {
      showMessage('Please enter electricity units.');
      return;
    }

    double? units = double.tryParse(unitsText);

    if (units == null || units < 0) {
      showMessage(
        'Please enter valid units.',
      );
      return;
    }

    setState(() {
      bill = ElectricityBill(
        consumerName: name,
        units: units,
      );
    });
  }

  void clearData() {
    nameController.clear();
    unitsController.clear();

    setState(() {
      bill = null;
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
    unitsController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Electricity Bill Calculator',
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,

          children: [

            const Icon(
              Icons.electric_bolt,
              size: 70,
              color: Colors.orange,
            ),

            const SizedBox(height: 10),

            const Text(
              'Electricity Bill Calculator',
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: nameController,

              decoration: const InputDecoration(
                labelText: 'Consumer Name',
                hintText: 'Enter consumer name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: unitsController,

              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),

              decoration: const InputDecoration(
                labelText: 'Units Consumed',
                hintText: 'Enter electricity units',
                border: OutlineInputBorder(),
                prefixIcon:
                    Icon(Icons.electric_meter),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: calculateBill,

              icon: const Icon(
                Icons.calculate,
              ),

              label: const Text(
                'Calculate Bill',
              ),

              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
              ),
            ),

            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: clearData,

              icon: const Icon(
                Icons.clear,
              ),

              label: const Text(
                'Clear',
              ),
            ),

            if (bill != null)
              BillResultCard(
                bill: bill!,
              ),
          ],
        ),
      ),
    );
  }
}