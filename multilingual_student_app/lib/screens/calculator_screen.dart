import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final number1Controller = TextEditingController();

  final number2Controller = TextEditingController();

  String operation = 'addition';

  String result = '';

  void calculate() {
    final n1 = double.tryParse(
      number1Controller.text,
    );

    final n2 = double.tryParse(
      number2Controller.text,
    );

    if (n1 == null || n2 == null) {
      setState(() {
        result = context.tr.translate(
          'enterNumbers',
        );
      });

      return;
    }

    double answer = 0;

    if (operation == 'addition') {
      answer = n1 + n2;
    }

    if (operation == 'subtraction') {
      answer = n1 - n2;
    }

    if (operation == 'multiplication') {
      answer = n1 * n2;
    }

    if (operation == 'division') {
      if (n2 == 0) {
        setState(() {
          result = context.tr.translate(
            'cannotDivide',
          );
        });

        return;
      }

      answer = n1 / n2;
    }

    setState(() {
      result = answer.toString();
    });
  }

  @override
  void dispose() {
    number1Controller.dispose();
    number2Controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr.translate(
            'calculatorTitle',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: number1Controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: context.tr.translate(
                  'number1',
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: number2Controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: context.tr.translate(
                  'number2',
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              initialValue: operation,
              decoration: InputDecoration(
                labelText: context.tr.translate(
                  'calculator',
                ),
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: 'addition',
                  child: Text(
                    context.tr.translate(
                      'addition',
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 'subtraction',
                  child: Text(
                    context.tr.translate(
                      'subtraction',
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 'multiplication',
                  child: Text(
                    context.tr.translate(
                      'multiplication',
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 'division',
                  child: Text(
                    context.tr.translate(
                      'division',
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  operation = value;
                });
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: calculate,
                child: Text(
                  context.tr.translate(
                    'calculate',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              '${context.tr.translate('result')}: $result',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
