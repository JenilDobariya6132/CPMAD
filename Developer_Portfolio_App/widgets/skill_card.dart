import 'package:flutter/material.dart';

class SkillWidget extends StatelessWidget {
  final String skill;

  const SkillWidget({
    super.key,
    required this.skill,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),

      decoration:
          BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer,

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize:
            MainAxisSize.min,

        children: [

          Icon(
            Icons.code,

            size: 18,

            color: Theme.of(context)
                .colorScheme
                .primary,
          ),

          const SizedBox(width: 7),

          Text(
            skill,

            style:
                const TextStyle(
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}