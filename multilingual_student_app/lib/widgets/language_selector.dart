import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';

class LanguageSelector
    extends StatelessWidget {
  final String selectedLanguage;

  final Function(String) onChanged;

  const LanguageSelector({
    super.key,

    required this.selectedLanguage,

    required this.onChanged,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return DropdownButton<String>(
      value: selectedLanguage,

      dropdownColor: Colors.white,

      underline: const SizedBox(),

      items: [
        DropdownMenuItem(
          value: 'en',

          child: Text(
            context.tr.translate(
              'english',
            ),
          ),
        ),

        DropdownMenuItem(
          value: 'gu',

          child: Text(
            context.tr.translate(
              'gujarati',
            ),
          ),
        ),

        DropdownMenuItem(
          value: 'hi',

          child: Text(
            context.tr.translate(
              'hindi',
            ),
          ),
        ),
      ],

      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}