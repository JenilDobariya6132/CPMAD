import 'package:flutter/material.dart';

class ContactWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ContactWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 8,
      ),

      child: Row(
        children: [

          Container(
            padding:
                const EdgeInsets.all(10),

            decoration:
                BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer,

              borderRadius:
                  BorderRadius.circular(10),
            ),

            child: Icon(
              icon,

              color: Theme.of(context)
                  .colorScheme
                  .primary,
            ),
          ),

          const SizedBox(width: 15),

          Flexible(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style:
                      const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,

                  overflow:
                      TextOverflow.ellipsis,

                  style:
                      const TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}