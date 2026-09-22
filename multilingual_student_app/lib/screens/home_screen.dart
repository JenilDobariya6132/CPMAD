import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../localization/app_localizations.dart';
import '../models/student.dart';
import '../widgets/language_selector.dart';

import 'student_form_screen.dart';
import 'calculator_screen.dart';

class HomeScreen extends StatefulWidget {
  final String selectedLanguage;

  final Function(String) onLanguageChanged;

  const HomeScreen({
    super.key,

    required this.selectedLanguage,

    required this.onLanguageChanged,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  final List<Student> students = [];

  void addStudent(
    Student student,
  ) {
    setState(() {
      students.add(student);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.tr.translate(
            'studentAdded',
          ),
        ),
      ),
    );
  }

  void deleteStudent(
    int index,
  ) {
    setState(() {
      students.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.tr.translate(
            'studentDeleted',
          ),
        ),
      ),
    );
  }

  String getDateLocale() {
    if (widget.selectedLanguage == 'gu') {
      return 'gu';
    }

    if (widget.selectedLanguage == 'hi') {
      return 'hi';
    }

    return 'en';
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final dateLocale = getDateLocale();

    final dateFormat = DateFormat.yMMMMd(
      dateLocale,
    );

    final numberFormat =
        NumberFormat.decimalPattern(
      dateLocale,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr.translate(
            'appTitle',
          ),
        ),

        actions: [
          LanguageSelector(
            selectedLanguage:
                widget.selectedLanguage,

            onChanged: (language) {
              widget.onLanguageChanged(
                language,
              );
            },
          ),

          const SizedBox(width: 10),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Text(
              context.tr.translate(
                'selectLanguage',
              ),

              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.person_add,
                    ),

                    label: Text(
                      context.tr.translate(
                        'addStudent',
                      ),
                    ),

                    onPressed: () async {
                      final student =
                          await Navigator.push<
                              Student>(
                        context,

                        MaterialPageRoute(
                          builder: (context) =>
                              const StudentFormScreen(),
                        ),
                      );

                      if (student != null) {
                        addStudent(student);
                      }
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.calculate,
                    ),

                    label: Text(
                      context.tr.translate(
                        'calculator',
                      ),
                    ),

                    onPressed: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) =>
                              const CalculatorScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: students.isEmpty
                  ? Center(
                      child: Text(
                        context.tr.translate(
                          'noStudents',
                        ),

                        style:
                            const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount:
                          students.length,

                      itemBuilder:
                          (context, index) {
                        final student =
                            students[index];

                        return Card(
                          margin:
                              const EdgeInsets
                                  .only(
                            bottom: 10,
                          ),

                          child: ListTile(
                            leading:
                                CircleAvatar(
                              child: Text(
                                student.name[0]
                                    .toUpperCase(),
                              ),
                            ),

                            title: Text(
                              student.name,
                            ),

                            subtitle:
                                Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [
                                Text(
                                  '${context.tr.translate('email')}: ${student.email}',
                                ),

                                Text(
                                  '${context.tr.translate('age')}: ${numberFormat.format(student.age)}',
                                ),

                                Text(
                                  '${context.tr.translate('course')}: ${student.course}',
                                ),

                                Text(
                                  '${context.tr.translate('marks')}: ${numberFormat.format(student.marks)}',
                                ),

                                Text(
                                  '${context.tr.translate('date')}: ${dateFormat.format(student.date)}',
                                ),
                              ],
                            ),

                            trailing:
                                IconButton(
                              icon:
                                  const Icon(
                                Icons.delete,
                              ),

                              onPressed: () {
                                deleteStudent(
                                  index,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}